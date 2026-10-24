import SwiftUI

/// Pair with the partner's phone and swap moments and the plan, face to face.
struct SyncView: View {
    @Environment(Store.self) private var store
    @StateObject private var sync = SyncManager()

    private var owner: Binding<Role?> {
        Binding(get: { store.device.owner }, set: { store.device.owner = $0 })
    }

    var body: some View {
        List {
            Section {
                Picker("This phone belongs to", selection: owner) {
                    Text(store.names.me).tag(Role?.some(.me))
                    Text(store.names.partner).tag(Role?.some(.partner))
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Whose phone is this?")
            } footer: {
                Text("Used to show who logged each moment.")
            }

            if store.device.owner != nil {
                Section {
                    statusRow
                    ForEach(sync.nearby) { phone in
                        Button {
                            sync.connect(to: phone)
                        } label: {
                            HStack {
                                Label(phone.name, systemImage: "iphone")
                                Spacer()
                                Text(isPaired(phone) ? "Paired" : "Sync")
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        .disabled(isBusy)
                    }
                } header: {
                    Text("Nearby")
                } footer: {
                    Text("Open this screen on both phones and keep them close together. Bluetooth and Wi-Fi need to be on, but no internet is needed.")
                }

                if let name = store.device.pairedName {
                    Section("Paired") {
                        LabeledContent("Paired with", value: name)
                        if let last = store.device.lastSync {
                            LabeledContent("Last synced") {
                                Text(last, format: .relative(presentation: .named))
                            }
                        }
                        Button("Forget this pairing", role: .destructive) {
                            sync.forgetPairing()
                        }
                    }
                }

                Section {
                    Label("Moments log, including who logged each one", systemImage: "calendar.badge.clock")
                    Label("Your plan: triggers, signs, what helps, pause word, the note", systemImage: "list.bullet.clipboard")
                    Label("Phone to phone only. Encrypted, with no servers, accounts or internet.", systemImage: "lock.fill")
                } header: {
                    Text("What's shared")
                }
            }
        }
        .navigationTitle("Sync with \(store.otherName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if store.device.owner != nil { sync.start(store: store) }
        }
        .onChange(of: store.device.owner) { _, owner in
            if owner != nil { sync.start(store: store) } else { sync.stop() }
        }
        .onDisappear { sync.stop() }
        .alert(
            "\(sync.invitation?.name ?? "A phone") wants to sync",
            isPresented: Binding(get: { sync.invitation != nil }, set: { _ in })
        ) {
            Button("Accept") { sync.respond(accept: true) }
            Button("Decline", role: .cancel) { sync.respond(accept: false) }
        } message: {
            Text("Only accept if this is \(store.otherName)'s phone. After this, your phones will recognise each other.")
        }
    }

    private var isBusy: Bool {
        switch sync.status {
        case .connecting, .syncing: return true
        default: return false
        }
    }

    private func isPaired(_ phone: SyncManager.NearbyPhone) -> Bool {
        phone.deviceID != nil && phone.deviceID == store.device.pairedDeviceID
    }

    @ViewBuilder
    private var statusRow: some View {
        switch sync.status {
        case .idle, .searching:
            HStack(spacing: 12) {
                ProgressView()
                Text(sync.nearby.isEmpty ? "Looking for \(store.otherName)'s phone…" : "Tap a phone to sync")
                    .foregroundStyle(.secondary)
            }
        case .connecting(let name):
            HStack(spacing: 12) {
                ProgressView()
                Text("Connecting to \(name)…")
            }
        case .syncing(let name):
            HStack(spacing: 12) {
                ProgressView()
                Text("Syncing with \(name)…")
            }
        case .done(let summary):
            VStack(alignment: .leading, spacing: 8) {
                Label("Synced", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
                Text(summary).foregroundStyle(.secondary)
                Button("Sync again") { sync.start(store: store) }
            }
        case .failed(let message):
            VStack(alignment: .leading, spacing: 8) {
                Label("Couldn't sync", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .font(.headline)
                Text(message).foregroundStyle(.secondary)
                Button("Try again") { sync.start(store: store) }
            }
        }
    }
}
