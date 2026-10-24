import SwiftUI

/// Everyday moments: what {K} meant, what RSD might hear, and a gentler way to say it.
struct TranslatorView: View {
    @State private var expanded: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    P("Everyday things can land very differently on an RSD brain. This isn't about tiptoeing — it's about saying what you mean in a way {J} can hear.")
                        .foregroundStyle(.secondary)
                    ForEach(Content.situations) { situation in
                        SituationCard(situation: situation, isExpanded: expanded == situation.id) {
                            withAnimation(.snappy) {
                                expanded = expanded == situation.id ? nil : situation.id
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Translate")
        }
    }
}

private struct SituationCard: View {
    let situation: Situation
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: toggle) {
                HStack(spacing: 12) {
                    Image(systemName: situation.symbol)
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 30)
                    Text(situation.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Row(label: "What you meant", symbol: "person.fill", tint: .blue, text: situation.youMeant)
                Row(label: "What RSD might hear", symbol: "ear.trianglebadge.exclamationmark", tint: .orange, text: situation.rsdHears)
                Row(label: "Try instead", symbol: "sparkles", tint: .green, text: situation.tryInstead)
                P(situation.why)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private struct Row: View {
        let label: String
        let symbol: String
        let tint: Color
        let text: String

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Label(label, systemImage: symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                P(text)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}
