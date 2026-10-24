import SwiftUI

struct LearnView: View {
    @Environment(Store.self) private var store

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Content.voiceCards) { card in
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(systemName: "quote.opening")
                                        .foregroundStyle(.pink)
                                    Text(card.text)
                                        .font(.callout)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer(minLength: 0)
                                    Text("— \(store.names.me)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .frame(width: 240, height: 170, alignment: .topLeading)
                                .background(Color.pink.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                } header: {
                    P("In {J}'s words")
                }

                Section("Understanding RSD") {
                    ForEach(Content.topics) { topic in
                        NavigationLink(value: topic) {
                            HStack(spacing: 14) {
                                Image(systemName: topic.symbol)
                                    .font(.title2)
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: 36)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(topic.title).font(.headline)
                                    P(topic.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Tools") {
                    NavigationLink {
                        FeelingsFinderView()
                    } label: {
                        Label("Feelings finder", systemImage: "sparkle.magnifyingglass")
                    }
                    NavigationLink {
                        StepsView(title: "Repairing together", intro: "A gentle way back to each other after an RSD storm.", steps: Content.repairSteps)
                    } label: {
                        Label("Repairing together", systemImage: "bandage")
                    }
                    NavigationLink {
                        StepsView(title: "Looking after you", intro: "For {K}. Supporting someone with RSD matters — and so do you.", steps: Content.selfCare)
                    } label: {
                        P("Looking after you, {K}")
                    }
                }
            }
            .navigationTitle("Understand")
            .navigationDestination(for: LearnTopic.self) { LearnDetailView(topic: $0) }
        }
    }
}

struct LearnDetailView: View {
    let topic: LearnTopic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: topic.symbol)
                    .font(.system(size: 44))
                    .foregroundStyle(Color.accentColor)
                P(topic.summary)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                ForEach(topic.sections, id: \.self) { section in
                    Card(title: section.heading) {
                        P(section.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                if let source = topic.source {
                    Label("Sources: \(source)", systemImage: "books.vertical")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A generic numbered list of steps (repair guide, self-care).
struct StepsView: View {
    let title: String
    let intro: String
    let steps: [Step]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                P(intro)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    HStack(alignment: .top, spacing: 14) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.accentColor, in: Circle())
                        VStack(alignment: .leading, spacing: 6) {
                            P(step.title).font(.headline)
                            P(step.detail)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
