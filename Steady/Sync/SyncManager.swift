import Foundation
import MultipeerConnectivity

/// Finds the partner's phone nearby and swaps data with it directly, over
/// Bluetooth and peer-to-peer Wi-Fi. The connection is encrypted and needs no
/// internet, account or server.
///
/// The first sync needs the other phone to tap Accept. After that the phones
/// recognise each other by device ID and connect on their own whenever both
/// have the Sync screen open.
final class SyncManager: NSObject, ObservableObject {
    enum Status: Equatable {
        case idle
        case searching
        case connecting(String)
        case syncing(String)
        case done(String)
        case failed(String)
    }

    struct NearbyPhone: Identifiable, Equatable {
        let peer: MCPeerID
        let deviceID: String?
        var id: MCPeerID { peer }
        var name: String { peer.displayName }
    }

    struct Invitation: Identifiable {
        let id = UUID()
        let name: String
        let deviceID: String?
        let reply: (Bool, MCSession?) -> Void
    }

    /// Sent with an invitation so a known partner can be accepted automatically.
    private struct Hello: Codable {
        let deviceID: String
    }

    static let serviceType = "steady-sync"

    @Published private(set) var status: Status = .idle
    @Published private(set) var nearby: [NearbyPhone] = []
    @Published private(set) var invitation: Invitation?

    private var store: Store?
    private var peerID: MCPeerID?
    private var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    /// Device IDs of peers we invited or accepted, so we know who we're talking to.
    private var deviceIDs: [MCPeerID: String] = [:]

    func start(store: Store) {
        stop()
        self.store = store
        let name = "\(store.ownerName ?? "Someone")'s iPhone"
        let peerID = MCPeerID(displayName: String(name.prefix(60)))
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                   discoveryInfo: ["device": store.device.deviceID],
                                                   serviceType: Self.serviceType)
        advertiser.delegate = self
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: Self.serviceType)
        browser.delegate = self

        self.peerID = peerID
        self.session = session
        self.advertiser = advertiser
        self.browser = browser
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
        status = .searching
    }

    func stop() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session?.disconnect()
        invitation?.reply(false, nil)
        advertiser = nil
        browser = nil
        session = nil
        peerID = nil
        invitation = nil
        nearby = []
        deviceIDs = [:]
        status = .idle
    }

    func connect(to phone: NearbyPhone) {
        guard let session, let browser, let store else { return }
        status = .connecting(phone.name)
        deviceIDs[phone.peer] = phone.deviceID
        let hello = try? JSONEncoder().encode(Hello(deviceID: store.device.deviceID))
        browser.invitePeer(phone.peer, to: session, withContext: hello, timeout: 30)
    }

    func respond(accept: Bool) {
        guard let invitation else { return }
        self.invitation = nil
        if accept {
            status = .connecting(invitation.name)
            invitation.reply(true, session)
        } else {
            invitation.reply(false, nil)
            status = .searching
        }
    }

    func forgetPairing() {
        store?.device.pairedDeviceID = nil
        store?.device.pairedName = nil
    }

    // MARK: Helpers (main thread)

    private func isPaired(_ deviceID: String?) -> Bool {
        guard let deviceID, let paired = store?.device.pairedDeviceID else { return false }
        return deviceID == paired
    }

    private func sendPayload(to peer: MCPeerID) {
        guard let session, let store else { return }
        do {
            let data = try JSONEncoder().encode(store.syncPayload)
            try session.send(data, toPeers: [peer], with: .reliable)
        } catch {
            status = .failed("Couldn't send: \(error.localizedDescription)")
        }
    }

    private func receive(_ data: Data, from peer: MCPeerID) {
        guard let store else { return }
        guard let payload = try? JSONDecoder().decode(SyncPayload.self, from: data) else {
            status = .failed("The other phone sent something Steady couldn't read. Make sure both have the latest version.")
            return
        }
        let result = store.applySync(from: payload)
        if let deviceID = deviceIDs[peer] {
            store.device.pairedDeviceID = deviceID
        }
        store.device.pairedName = payload.senderName.isEmpty ? peer.displayName : payload.senderName
        status = .done(result.summary)
    }
}

// MARK: - Finding phones

extension SyncManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async { [self] in
            guard browser === self.browser else { return }
            let phone = NearbyPhone(peer: peerID, deviceID: info?["device"])
            nearby.removeAll { $0.peer == peerID }
            nearby.append(phone)
            // Reconnect to a known partner automatically. Only one side invites,
            // so the two phones don't both start a connection at once.
            if isPaired(phone.deviceID), let mine = store?.device.deviceID, let theirs = phone.deviceID,
               mine < theirs, status == .searching {
                connect(to: phone)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [self] in
            nearby.removeAll { $0.peer == peerID }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        DispatchQueue.main.async { [self] in
            status = .failed("Couldn't look for nearby phones. Check that Steady is allowed to use the local network (Settings → Steady).")
        }
    }
}

// MARK: - Being found

extension SyncManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let hello = context.flatMap { try? JSONDecoder().decode(Hello.self, from: $0) }
        DispatchQueue.main.async { [self] in
            guard advertiser === self.advertiser, let session else {
                invitationHandler(false, nil)
                return
            }
            deviceIDs[peerID] = hello?.deviceID
            if isPaired(hello?.deviceID) {
                status = .connecting(peerID.displayName)
                invitationHandler(true, session)
            } else {
                invitation?.reply(false, nil)
                invitation = Invitation(name: peerID.displayName, deviceID: hello?.deviceID, reply: invitationHandler)
            }
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        DispatchQueue.main.async { [self] in
            status = .failed("Couldn't make this phone visible. Check that Steady is allowed to use the local network (Settings → Steady).")
        }
    }
}

// MARK: - Swapping data

extension SyncManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async { [self] in
            guard session === self.session else { return }
            switch state {
            case .connected:
                status = .syncing(peerID.displayName)
                sendPayload(to: peerID)
            case .notConnected:
                switch status {
                case .connecting, .syncing:
                    status = .failed("Lost the connection to \(peerID.displayName). Keep the phones close and try again.")
                default:
                    break
                }
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [self] in
            guard session === self.session else { return }
            receive(data, from: peerID)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
