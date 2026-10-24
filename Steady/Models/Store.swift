import Foundation
import Observation

/// {J}'s own notes about how RSD shows up for them. Pre-filled with common
/// examples so there's something to react to — edit freely.
struct Profile: Codable, Equatable {
    var names = Names()
    var triggers: [String] = [
        "Short or delayed replies to messages",
        "Being reminded about something I forgot",
        "Feeling corrected in front of other people",
        "Hearing “we need to talk” with no context"
    ]
    var earlySigns: [String] = [
        "I go quiet or give one-word answers",
        "I start apologising a lot",
        "I get defensive about small things"
    ]
    var whatHelps: [String] = [
        "Tell me clearly that we're okay",
        "Give me 20 minutes, then come and find me",
        "A hug, if I'm not angry"
    ]
    var whatDoesnt: [String] = [
        "Being told I'm overreacting",
        "Trying to sort the problem out while I'm in it",
        "Being followed when I've asked for space"
    ]
    var pauseWord = "Pineapple"
    var pauseMinutes = 20
    var letter = "{K} — thank you for wanting to understand this. When RSD hits, it's not about how I feel about you. It's about how I suddenly feel about myself. You don't have to fix it. Just knowing you're on my side is what helps most."
    var checkIns: [String] = Content.defaultCheckIns
}

/// A logged RSD moment, so patterns become visible over time.
struct Moment: Codable, Identifiable, Equatable {
    var id = UUID()
    var date = Date()
    var phase: Phase = .wobble
    var trigger = ""
    var feltLike = ""
    var helped = ""
    var notes = ""
    /// Name of the person who logged it.
    var loggedBy = ""
    /// Last edit, used to pick the newest version when syncing.
    var updatedAt = Date()
}

extension Moment {
    private enum CodingKeys: String, CodingKey {
        case id, date, phase, trigger, feltLike, helped, notes, loggedBy, updatedAt
    }

    // Moments saved before sync existed have no loggedBy/updatedAt.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        date = try c.decode(Date.self, forKey: .date)
        phase = try c.decode(Phase.self, forKey: .phase)
        trigger = try c.decodeIfPresent(String.self, forKey: .trigger) ?? ""
        feltLike = try c.decodeIfPresent(String.self, forKey: .feltLike) ?? ""
        helped = try c.decodeIfPresent(String.self, forKey: .helped) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        loggedBy = try c.decodeIfPresent(String.self, forKey: .loggedBy) ?? ""
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? date
    }
}

struct TriggerCount: Identifiable, Equatable {
    var id: String { text }
    let text: String
    let count: Int
}

@Observable
final class Store {
    private static let profileKey = "steady.profile.v1"
    private static let momentsKey = "steady.moments.v1"
    private static let onboardedKey = "steady.onboarded.v1"
    private static let stampsKey = "steady.profileStamps.v1"
    private static let deletedKey = "steady.deletedMoments.v1"
    private static let deviceKey = "steady.device.v1"

    private let defaults: UserDefaults
    /// True while a synced change is applied, so it doesn't get a fresh timestamp.
    private var applyingSync = false

    var profile: Profile {
        didSet {
            save(profile, key: Self.profileKey)
            guard !applyingSync else { return }
            let now = Date()
            for field in ProfileField.allCases where field.differs(oldValue, profile) {
                profileStamps[field] = now
            }
        }
    }
    var moments: [Moment] { didSet { save(moments, key: Self.momentsKey) } }
    var hasOnboarded: Bool { didSet { defaults.set(hasOnboarded, forKey: Self.onboardedKey) } }
    private(set) var profileStamps: [ProfileField: Date] { didSet { save(profileStamps, key: Self.stampsKey) } }
    private(set) var deletedMoments: [UUID: Date] { didSet { save(deletedMoments, key: Self.deletedKey) } }
    var device: DeviceSettings { didSet { save(device, key: Self.deviceKey) } }

    var names: Names { profile.names }

    /// The name of whoever owns this phone, if they've said.
    var ownerName: String? { device.owner?.name(in: names) }

    /// The other person: who this phone syncs with.
    var otherName: String { device.owner == .partner ? names.me : names.partner }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        profile = Self.load(Profile.self, key: Self.profileKey, from: defaults) ?? Profile()
        moments = Self.load([Moment].self, key: Self.momentsKey, from: defaults) ?? []
        hasOnboarded = defaults.bool(forKey: Self.onboardedKey)
        profileStamps = Self.load([ProfileField: Date].self, key: Self.stampsKey, from: defaults) ?? [:]
        deletedMoments = Self.load([UUID: Date].self, key: Self.deletedKey, from: defaults) ?? [:]
        device = Self.load(DeviceSettings.self, key: Self.deviceKey, from: defaults) ?? DeviceSettings()
    }

    func add(_ moment: Moment) {
        moments.insert(moment, at: 0)
        moments.sort { $0.date > $1.date }
    }

    /// Saves a new or edited moment, stamping who logged it and when.
    func update(_ moment: Moment) {
        var moment = moment
        moment.updatedAt = Date()
        if moment.loggedBy.isEmpty, let ownerName { moment.loggedBy = ownerName }
        guard let index = moments.firstIndex(where: { $0.id == moment.id }) else { return add(moment) }
        moments[index] = moment
        moments.sort { $0.date > $1.date }
    }

    func deleteMoments(at offsets: IndexSet) {
        let now = Date()
        for index in offsets { deletedMoments[moments[index].id] = now }
        moments = moments.enumerated().filter { !offsets.contains($0.offset) }.map(\.element)
    }

    // MARK: Sync

    /// Everything this phone shares with the paired phone.
    var syncPayload: SyncPayload {
        SyncPayload(senderName: ownerName ?? "", profile: profile, profileStamps: profileStamps,
                    moments: moments, deletedMoments: deletedMoments)
    }

    /// Merges the other phone's data in and returns what changed.
    @discardableResult
    func applySync(from remote: SyncPayload) -> SyncResult {
        let result = SyncMerge.merge(local: syncPayload, remote: remote)
        applyingSync = true
        defer { applyingSync = false }
        if result.payload.profile != profile { profile = result.payload.profile }
        if result.payload.moments != moments { moments = result.payload.moments }
        profileStamps = result.payload.profileStamps
        deletedMoments = result.payload.deletedMoments
        device.lastSync = Date()
        return result
    }

    /// The triggers mentioned most often in the log — a simple pattern spotter.
    var commonTriggers: [TriggerCount] {
        let counts = moments
            .map { $0.trigger.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
            .reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }
        return counts
            .filter { $0.value > 1 }
            .sorted { $0.value == $1.value ? $0.key < $1.key : $0.value > $1.value }
            .prefix(3)
            .map { TriggerCount(text: $0.key, count: $0.value) }
    }

    private func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String, from defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: - Feelings finder logic

enum FeelingsFinder {
    /// Ranks RSD "flavours" by how many of the selected clues point to them.
    static func rank(_ selected: Set<String>) -> [(flavour: Flavour, score: Int)] {
        var scores: [Flavour: Int] = [:]
        for clue in Content.clues where selected.contains(clue.id) {
            for flavour in clue.flavours { scores[flavour, default: 0] += 1 }
        }
        return Flavour.allCases
            .compactMap { flavour in scores[flavour].map { (flavour: flavour, score: $0) } }
            .sorted { $0.score == $1.score ? $0.flavour.rawValue < $1.flavour.rawValue : $0.score > $1.score }
    }

    /// A message {J} can send to {K} describing how they feel right now.
    static func message(selected: Set<String>, names: Names) -> String {
        let picked = Content.clues.filter { selected.contains($0.id) }.map(\.text)
        guard let top = rank(selected).first?.flavour else {
            return "I'm not sure what I'm feeling yet, but something's up. Can we check in?"
        }
        var lines = ["\(names.partner), I think I'm having an RSD moment — it feels like a \(top.title.lowercased())."]
        if !picked.isEmpty { lines.append("I'm noticing: " + picked.joined(separator: ", ") + ".") }
        if let help = top.helps.first { lines.append("What might help: " + help) }
        lines.append("It's not your fault. ❤️")
        return lines.joined(separator: "\n")
    }
}

// MARK: - Demo mode (App Store screenshots)

extension Store {
    /// Launch with `-demo` for a clean, sample-filled store with neutral names,
    /// kept apart from the real data. Used by the screenshot UI tests.
    static func forLaunch(arguments: [String] = ProcessInfo.processInfo.arguments) -> Store {
        guard arguments.contains("-demo") else { return Store() }
        let suite = "steady.demo"
        let defaults = UserDefaults(suiteName: suite) ?? .standard
        defaults.removePersistentDomain(forName: suite)
        let store = Store(defaults: defaults)
        store.profile.names = Names(me: "Alex", partner: "Sam")
        store.profile.pauseWord = "Pineapple"
        store.hasOnboarded = true
        let day: TimeInterval = 86_400
        store.moments = [
            Moment(date: Date().addingTimeInterval(-1 * day), phase: .wobble, trigger: "Short text reply", feltLike: "Alarm bells", helped: "A quick “we're okay”", loggedBy: "Sam"),
            Moment(date: Date().addingTimeInterval(-4 * day), phase: .storm, trigger: "Feedback at work", feltLike: "Shame wave", helped: "Pause word, then a walk", loggedBy: "Alex"),
            Moment(date: Date().addingTimeInterval(-9 * day), phase: .wobble, trigger: "Short text reply", feltLike: "Replaying it", helped: "Asked directly", loggedBy: "Alex")
        ]
        return store
    }
}
