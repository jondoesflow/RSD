import SwiftUI

/// Full-screen cards {J} can hold up when words won't come.
struct SignalCardsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Store.self) private var store
    @State private var selection = Content.signalCards.first?.id ?? ""

    private var cards: [SignalCard] {
        let pause = SignalCard(
            id: "word",
            title: store.profile.pauseWord,
            message: "That's our pause word. I need \(store.profile.pauseMinutes) minutes, and then I'll come and find you.",
            symbol: "pause.circle.fill",
            tint: "wobble"
        )
        return Content.signalCards + [pause]
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selection) {
                ForEach(cards) { card in
                    VStack(spacing: 28) {
                        Spacer()
                        Image(systemName: card.symbol)
                            .font(.system(size: 72))
                        Text(card.title)
                            .font(.largeTitle.bold())
                        Text(card.message.personalised(store.names))
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                        Text("Swipe for more cards")
                            .font(.footnote)
                            .opacity(0.7)
                            .padding(.bottom, 48)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(card.color.gradient)
                    .tag(card.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
            }
            .padding()
            .accessibilityLabel("Close")
        }
        .statusBarHidden()
    }
}
