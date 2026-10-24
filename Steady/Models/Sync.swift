import Foundation

// MARK: - Whose phone is this?

/// Which of the two people this phone belongs to. Stored per device, never synced.
enum Role: String, Codable, CaseIterable, Identifiable {
    case me, partner
    var id: String { rawValue }

    func name(in names: Names) -> String { self == .me ? names.me : names.partner }
}

/// Per-device settings for pairing. Never sent to the other phone except `deviceID`.
struct DeviceSettings: Codable, Equatable {
    var deviceID = UUID().uuidString
    var owner: Role?
    var pairedDeviceID: String?
    var pairedName: String?
    var lastSync: Date?
}

// MARK: - Profile fields

/// The plan is merged field by field, so editing the pause word on one phone
/// and the triggers on the other both survive a sync.
enum ProfileField: String, CaseIterable, Codable {
    case names, triggers, earlySigns, whatHelps, whatDoesnt, pause, letter, checkIns

    func differs(_ a: Profile, _ b: Profile) -> Bool {
        switch self {
        case .names: return a.names != b.names
        case .triggers: return a.triggers != b.triggers
        case .earlySigns: return a.earlySigns != b.earlySigns
        case .whatHelps: return a.whatHelps != b.whatHelps
        case .whatDoesnt: return a.whatDoesnt != b.whatDoesnt
        case .pause: return a.pauseWord != b.pauseWord || a.pauseMinutes != b.pauseMinutes
        case .letter: return a.letter != b.letter
        case .checkIns: return a.checkIns != b.checkIns
        }
    }

    func copy(from source: Profile, to target: inout Profile) {
        switch self {
        case .names: target.names = source.names
        case .triggers: target.triggers = source.triggers
        case .earlySigns: target.earlySigns = source.earlySigns
        case .whatHelps: target.whatHelps = source.whatHelps
        case .whatDoesnt: target.whatDoesnt = source.whatDoesnt
        case .pause:
            target.pauseWord = source.pauseWord
            target.pauseMinutes = source.pauseMinutes
        case .letter: target.letter = source.letter
        case .checkIns: target.checkIns = source.checkIns
        }
    }
}

// MARK: - What gets exchanged

/// Everything shared between the two phones. Sent over an encrypted,
/// direct device-to-device connection only.
struct SyncPayload: Codable, Equatable {
    var version = 1
    var senderName = ""
    var profile = Profile()
    /// When each plan field was last edited. Missing means "never edited here".
    var profileStamps: [ProfileField: Date] = [:]
    var moments: [Moment] = []
    /// Moments deleted, and when, so deletions spread to the other phone.
    var deletedMoments: [UUID: Date] = [:]
}

struct SyncResult: Equatable {
    var payload: SyncPayload
    var newMoments = 0
    var updatedMoments = 0
    var removedMoments = 0
    var updatedFields: [ProfileField] = []

    var summary: String {
        var parts: [String] = []
        if newMoments > 0 { parts.append("\(newMoments) new moment\(newMoments == 1 ? "" : "s")") }
        if updatedMoments > 0 { parts.append("\(updatedMoments) updated") }
        if removedMoments > 0 { parts.append("\(removedMoments) removed") }
        if !updatedFields.isEmpty { parts.append("plan updated") }
        return parts.isEmpty ? "Already up to date" : parts.joined(separator: ", ")
    }
}

enum SyncMerge {
    /// Combines the local and remote state. Both phones run this on each
    /// other's payload, so they end up identical.
    static func merge(local: SyncPayload, remote: SyncPayload) -> SyncResult {
        var merged = local
        var result = SyncResult(payload: local)

        // Deletions: keep the latest deletion time for every ID.
        for (id, date) in remote.deletedMoments {
            merged.deletedMoments[id] = max(date, merged.deletedMoments[id] ?? .distantPast)
        }

        // Moments: union by ID, newest edit wins, unless deleted after that edit.
        var byID = Dictionary(local.moments.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
        for incoming in remote.moments {
            if let existing = byID[incoming.id] {
                if incoming.updatedAt > existing.updatedAt {
                    byID[incoming.id] = incoming
                    result.updatedMoments += 1
                }
            } else {
                byID[incoming.id] = incoming
                result.newMoments += 1
            }
        }
        for (id, deletedAt) in merged.deletedMoments {
            guard let moment = byID[id], deletedAt >= moment.updatedAt else { continue }
            byID[id] = nil
            if local.moments.contains(where: { $0.id == id }) {
                result.removedMoments += 1
            } else {
                result.newMoments -= 1 // it arrived and was deleted in the same sync
            }
        }
        merged.moments = byID.values.sorted { $0.date > $1.date }

        // Plan: newest edit of each field wins.
        for field in ProfileField.allCases {
            guard let remoteStamp = remote.profileStamps[field],
                  remoteStamp > (local.profileStamps[field] ?? .distantPast) else { continue }
            if field.differs(remote.profile, merged.profile) {
                field.copy(from: remote.profile, to: &merged.profile)
                result.updatedFields.append(field)
            }
            merged.profileStamps[field] = remoteStamp
        }

        result.payload = merged
        return result
    }
}
