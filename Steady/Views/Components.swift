import SwiftUI

extension Phase {
    var color: Color {
        switch self {
        case .wobble: return .orange
        case .storm: return .indigo
        case .after: return .teal
        }
    }
}

extension Flavour {
    var color: Color {
        switch self {
        case .shame: return .blue
        case .anger: return .red
        case .anxious: return .orange
        case .shutdown: return .purple
        }
    }
}

extension SignalCard {
    var color: Color {
        switch tint {
        case "storm": return Phase.storm.color
        case "wobble": return Phase.wobble.color
        case "after": return Phase.after.color
        case "shutdown": return Flavour.shutdown.color
        default: return .accentColor
        }
    }
}

/// Replaces `{J}` / `{K}` with the couple's names.
struct P: View {
    @Environment(Store.self) private var store
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View { Text(text.personalised(store.names)) }
}

struct BulletList: View {
    let items: [String]
    var symbol = "circle.fill"
    var tint: Color = .secondary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Image(systemName: symbol)
                        .font(.caption2)
                        .foregroundStyle(tint)
                    P(item)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Card<Inner: View>: View {
    var title: String?
    var symbol: String?
    var tint: Color = .accentColor
    @ViewBuilder var content: Inner

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Label {
                    P(title).font(.headline)
                } icon: {
                    if let symbol { Image(systemName: symbol).foregroundStyle(tint) }
                }
            }
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

/// An editable list of short strings, used for the profile sections.
struct EditableList: View {
    let title: String
    let footer: String
    @Binding var items: [String]
    @State private var draft = ""

    var body: some View {
        Section {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .onDelete { items.remove(atOffsets: $0) }
            .onMove { items.move(fromOffsets: $0, toOffset: $1) }
            HStack {
                TextField("Add…", text: $draft)
                    .onSubmit(add)
                Button(action: add) { Image(systemName: "plus.circle.fill") }
                    .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        } header: {
            Text(title)
        } footer: {
            Text(footer)
        }
    }

    private func add() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !items.contains(text) else { return }
        items.append(text)
        draft = ""
    }
}
