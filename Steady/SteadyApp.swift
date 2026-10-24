import SwiftUI

@main
struct SteadyApp: App {
    @State private var store = Store.forLaunch()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}

struct RootView: View {
    @Environment(Store.self) private var store

    var body: some View {
        TabView {
            NowView()
                .tabItem { Label("Right now", systemImage: "lifepreserver") }
            LearnView()
                .tabItem { Label("Understand", systemImage: "book") }
            TranslatorView()
                .tabItem { Label("Translate", systemImage: "bubble.left.and.text.bubble.right") }
            UsView()
                .tabItem { Label("Us", systemImage: "person.2") }
            ResourcesView()
                .tabItem { Label("Listen & read", systemImage: "headphones") }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !store.hasOnboarded },
            set: { store.hasOnboarded = !$0 }
        )) {
            WelcomeView()
                .environment(store)
        }
    }
}
