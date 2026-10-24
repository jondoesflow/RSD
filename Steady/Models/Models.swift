import Foundation

// MARK: - Personalisation

/// The two people the app is for. Content strings use `{J}` for the person
/// with ADHD/RSD and `{K}` for their partner, swapped in at display time.
struct Names: Codable, Equatable {
    var me: String = "Jon"
    var partner: String = "Katie"
}

extension String {
    func personalised(_ names: Names) -> String {
        replacingOccurrences(of: "{J}", with: names.me)
            .replacingOccurrences(of: "{K}", with: names.partner)
    }
}

// MARK: - "Right now" guides

enum Phase: String, CaseIterable, Identifiable, Codable {
    case wobble, storm, after

    var id: String { rawValue }

    var title: String {
        switch self {
        case .wobble: return "Wobble"
        case .storm: return "Storm"
        case .after: return "After the storm"
        }
    }

    var subtitle: String {
        switch self {
        case .wobble: return "Something has landed badly. It's building."
        case .storm: return "Full RSD wave. Thinking brain is offline."
        case .after: return "It's passed. Time to reconnect gently."
        }
    }

    var symbol: String {
        switch self {
        case .wobble: return "cloud.sun"
        case .storm: return "cloud.bolt.rain"
        case .after: return "sun.horizon"
        }
    }
}

struct PhaseGuide {
    let phase: Phase
    let youMightSee: [String]
    let insideJon: [String]
    let doThis: [String]
    let avoid: [String]
    let say: [String]
}

// MARK: - Learn

struct LearnSection: Hashable {
    let heading: String
    let body: String
}

struct LearnTopic: Identifiable, Hashable {
    let id: String
    let title: String
    let symbol: String
    let summary: String
    let sections: [LearnSection]
    let source: String?
}

/// Short first-person cards: what the person with RSD wishes they could say.
struct VoiceCard: Identifiable, Hashable {
    let id = UUID()
    let text: String
}

// MARK: - Translator

struct Situation: Identifiable, Hashable {
    let id: String
    let title: String
    let symbol: String
    let youMeant: String
    let rsdHears: String
    let tryInstead: String
    let why: String
}

// MARK: - Feelings finder

enum Flavour: String, CaseIterable, Identifiable {
    case shame, anger, anxious, shutdown

    var id: String { rawValue }

    var title: String {
        switch self {
        case .shame: return "Shame wave"
        case .anger: return "Anger flash"
        case .anxious: return "Alarm bells"
        case .shutdown: return "Shutdown"
        }
    }

    var symbol: String {
        switch self {
        case .shame: return "drop.fill"
        case .anger: return "flame.fill"
        case .anxious: return "bell.fill"
        case .shutdown: return "moon.zzz.fill"
        }
    }

    var meaning: String {
        switch self {
        case .shame:
            return "The pain has turned inwards. Your brain has jumped from “that went badly” to “I am bad”. This is the internalised side of RSD — it can feel like sudden, heavy sadness or worthlessness."
        case .anger:
            return "The pain has turned outwards. Anger is acting as armour against the hurt underneath. Dr William Dodson describes this as an instant rage at whatever seemed to cause the pain — it is fast, and it passes."
        case .anxious:
            return "Your brain is scanning for rejection that might be coming. You may be replaying, checking faces and tone, or rushing to fix things before anyone is upset."
        case .shutdown:
            return "Your system has hit overwhelm and pulled the plug. Going quiet, numb or wanting to hide is protection, not indifference."
        }
    }

    var helps: [String] {
        switch self {
        case .shame:
            return ["Name it: “This is RSD, not the truth about me.”",
                    "Ask for a hug or a simple “I'm still here.”",
                    "Don't make big decisions or send long messages for a while."]
        case .anger:
            return ["Use the pause word and step away — it's not leaving, it's cooling.",
                    "Move: walk, stairs, cold water on the face.",
                    "Come back when your voice is back to normal volume."]
        case .anxious:
            return ["Ask one direct question: “Are we okay?” and believe the answer.",
                    "Write the worry down instead of replaying it.",
                    "Box breathing for two minutes."]
        case .shutdown:
            return ["Say (or show a card): “I'm overwhelmed, not angry. I need quiet.”",
                    "Low-demand comfort: blanket, music, dim lights.",
                    "Agree a time to check back in."]
        }
    }
}

struct FeelingClue: Identifiable, Hashable {
    enum Kind: String, CaseIterable { case body = "In my body", thought = "In my head", urge = "What I want to do" }
    let id: String
    let kind: Kind
    let text: String
    let flavours: [Flavour]
}

// MARK: - Signal cards

struct SignalCard: Identifiable, Hashable {
    let id: String
    let title: String
    let message: String
    let symbol: String
    let tint: String
}

// MARK: - Resources

struct Resource: Identifiable, Hashable {
    enum Kind: String, CaseIterable {
        case podcast = "Podcasts"
        case book = "Books"
        case additude = "From ADDitude"
        case article = "More articles"
        case support = "Support & crisis lines"

        var symbol: String {
            switch self {
            case .podcast: return "headphones"
            case .book: return "book.closed"
            case .additude: return "newspaper"
            case .article: return "doc.text"
            case .support: return "lifepreserver"
            }
        }
    }

    let id = UUID()
    let kind: Kind
    let title: String
    let by: String
    let detail: String
    let url: String
}

// MARK: - Repair & self-care

struct Step: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
}
