import SwiftUI

/// Helps {J} put words to a feeling by picking body sensations, thoughts and
/// urges — then turns it into a message for {K}.
struct FeelingsFinderView: View {
    @Environment(Store.self) private var store
    @State private var selected: Set<String> = []

    private var ranked: [(flavour: Flavour, score: Int)] { FeelingsFinder.rank(selected) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                P("Hard to say what you're feeling? That's really common with ADHD. Tap anything that's true right now — there are no wrong answers.")
                    .foregroundStyle(.secondary)

                ForEach(FeelingClue.Kind.allCases, id: \.self) { kind in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(kind.rawValue).font(.headline)
                        FlowLayout(spacing: 8) {
                            ForEach(Content.clues.filter { $0.kind == kind }) { clue in
                                Chip(text: clue.text, isOn: selected.contains(clue.id)) {
                                    toggle(clue.id)
                                }
                            }
                        }
                    }
                }

                if let top = ranked.first {
                    result(top.flavour, also: ranked.dropFirst().first?.flavour)
                }
            }
            .padding()
            .animation(.default, value: selected)
        }
        .navigationTitle("Feelings finder")
        .toolbar {
            if !selected.isEmpty {
                Button("Clear") { selected.removeAll() }
            }
        }
    }

    private func toggle(_ id: String) {
        if selected.contains(id) { selected.remove(id) } else { selected.insert(id) }
    }

    @ViewBuilder
    private func result(_ flavour: Flavour, also second: Flavour?) -> some View {
        Card(title: "This sounds like: \(flavour.title)", symbol: flavour.symbol, tint: flavour.color) {
            Text(flavour.meaning)
                .fixedSize(horizontal: false, vertical: true)
            if let second {
                Text("With a bit of \(second.title.lowercased()) mixed in.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Divider()
            Text("What might help").font(.subheadline.bold())
            BulletList(items: flavour.helps, symbol: "arrow.right", tint: flavour.color)
        }

        ShareLink(item: FeelingsFinder.message(selected: selected, names: store.names)) {
            Label("Send this to \(store.names.partner)", systemImage: "paperplane.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(flavour.color)
        .controlSize(.large)

        Text("This is a prompt to help you find words, not a diagnosis.")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}

private struct Chip: View {
    let text: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundStyle(isOn ? Color.white : Color.primary)
                .background(isOn ? Color.accentColor : Color(.secondarySystemBackground), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

/// Wraps children onto multiple lines, like tags.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews: subviews)
        let height = rows.last.map { $0.y + $0.height } ?? 0
        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrange(width: bounds.width, subviews: subviews)
        for row in rows {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: bounds.minY + row.y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
        }
    }

    private struct Row {
        var indices: [Int] = []
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(width maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = [Row()]
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            var row = rows[rows.count - 1]
            let proposedWidth = row.indices.isEmpty ? size.width : row.width + spacing + size.width
            if proposedWidth > maxWidth && !row.indices.isEmpty {
                let nextY = row.y + row.height + spacing
                rows.append(Row(indices: [index], y: nextY, width: size.width, height: size.height))
                continue
            }
            row.indices.append(index)
            row.width = proposedWidth
            row.height = max(row.height, size.height)
            rows[rows.count - 1] = row
        }
        return rows
    }
}
