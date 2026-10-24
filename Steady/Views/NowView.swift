import SwiftUI

struct NowView: View {
    @Environment(Store.self) private var store
    @State private var showingCards = false
    @State private var showingBreathing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    P("Is {J} having an RSD moment? Pick what it looks like right now.")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    ForEach(Phase.allCases) { phase in
                        NavigationLink(value: phase) {
                            PhaseButton(phase: phase)
                        }
                        .buttonStyle(.plain)
                    }

                    pauseWordCard

                    HStack(spacing: 12) {
                        QuickAction(title: "Signal cards", symbol: "rectangle.portrait.on.rectangle.portrait", tint: .pink) {
                            showingCards = true
                        }
                        QuickAction(title: "Breathe together", symbol: "wind", tint: .teal) {
                            showingBreathing = true
                        }
                    }

                    NavigationLink {
                        FeelingsFinderView()
                    } label: {
                        Card(title: "What am I feeling?", symbol: "sparkle.magnifyingglass", tint: .purple) {
                            P("For {J}: tap what you notice in your body and head, and get a message to send {K}.")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)

                    checkIns
                }
                .padding()
            }
            .navigationTitle("Right now")
            .navigationDestination(for: Phase.self) { PhaseGuideView(phase: $0) }
            .fullScreenCover(isPresented: $showingCards) {
                SignalCardsView().environment(store)
            }
            .sheet(isPresented: $showingBreathing) {
                BreathingView()
            }
        }
    }

    private var pauseWordCard: some View {
        Card(title: "Our pause word", symbol: "pause.circle.fill", tint: .orange) {
            Text("“\(store.profile.pauseWord)”")
                .font(.title2.bold())
            P("Either of us can say it. It means: “I need \(store.profile.pauseMinutes) minutes to calm down, and I will come back.” It's a promise to return, not a way out.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var checkIns: some View {
        Card(title: "Send {J} a check-in", symbol: "paperplane.fill", tint: .blue) {
            P("Small, warm, no-pressure messages help RSD settle. Tap one to send.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ForEach(store.profile.checkIns, id: \.self) { message in
                ShareLink(item: message.personalised(store.names)) {
                    HStack {
                        P(message).multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                    }
                    .padding(12)
                    .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct PhaseButton: View {
    let phase: Phase

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: phase.symbol)
                .font(.system(size: 32))
                .frame(width: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text(phase.title).font(.title3.bold())
                Text(phase.subtitle).font(.subheadline).opacity(0.9)
            }
            Spacer()
            Image(systemName: "chevron.right").opacity(0.7)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(phase.color.gradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct QuickAction: View {
    let title: String
    let symbol: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: symbol).font(.title2)
                Text(title).font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .foregroundStyle(tint)
            .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct PhaseGuideView: View {
    @Environment(Store.self) private var store
    let phase: Phase

    private var guide: PhaseGuide { Content.guide(for: phase) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(phase.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Card(title: "What you might see", symbol: "eye", tint: phase.color) {
                    BulletList(items: guide.youMightSee, tint: phase.color)
                }
                Card(title: "What's happening inside {J}", symbol: "brain.head.profile", tint: phase.color) {
                    BulletList(items: guide.insideJon, tint: phase.color)
                }
                Card(title: "Do", symbol: "checkmark.circle.fill", tint: .green) {
                    BulletList(items: guide.doThis, symbol: "checkmark", tint: .green)
                }
                Card(title: "Try to avoid", symbol: "xmark.circle.fill", tint: .red) {
                    BulletList(items: guide.avoid, symbol: "xmark", tint: .red)
                }
                Card(title: "Things you could say", symbol: "quote.bubble.fill", tint: .blue) {
                    BulletList(items: guide.say, symbol: "text.bubble", tint: .blue)
                }

                if phase != .after && !store.profile.whatHelps.isEmpty {
                    Card(title: "{J} says this helps", symbol: "heart.text.square.fill", tint: .pink) {
                        BulletList(items: store.profile.whatHelps, symbol: "heart.fill", tint: .pink)
                    }
                }
                if phase == .storm && !store.profile.whatDoesnt.isEmpty {
                    Card(title: "{J} says this makes it worse", symbol: "hand.raised.fill", tint: .gray) {
                        BulletList(items: store.profile.whatDoesnt, symbol: "minus", tint: .gray)
                    }
                }
                if phase == .after {
                    NavigationLink {
                        StepsView(title: "Repairing together", intro: "A gentle way back to each other after an RSD storm.", steps: Content.repairSteps)
                    } label: {
                        Label("Open the repair guide", systemImage: "bandage")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(phase.color)
                    .controlSize(.large)
                }

                Text("Not every upset is RSD — sometimes {J} is upset about something real, and that deserves to be heard too.".personalised(store.names))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(phase.title)
    }
}
