import SwiftUI

struct WelcomeView: View {
    @Environment(Store.self) private var store

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.accentColor)

                    Text("Steady")
                        .font(.largeTitle.bold())

                    Text("A pocket toolkit for understanding Rejection Sensitivity Dysphoria (RSD) — and for getting through RSD moments together.")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 14) {
                        feature("lifepreserver", "Right now", "Step-by-step help for a wobble, a storm, and the moments after.")
                        feature("book", "Understand", "What RSD is, why it's so intense, and what really helps.")
                        feature("bubble.left.and.text.bubble.right", "Translate", "Everyday moments, and how they can land.")
                        feature("person.2", "Us", "Your own plan, a moments log, and phone-to-phone sync with your partner.")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Who's it for?").font(.headline)
                        TextField("Person with RSD", text: $store.profile.names.me)
                            .textFieldStyle(.roundedBorder)
                        TextField("Their partner", text: $store.profile.names.partner)
                            .textFieldStyle(.roundedBorder)
                        Text("Whose phone is this?").font(.headline).padding(.top, 8)
                        Picker("Whose phone is this?", selection: $store.device.owner) {
                            Text(store.names.me.isEmpty ? "Person with RSD" : store.names.me).tag(Role?.some(.me))
                            Text(store.names.partner.isEmpty ? "Partner" : store.names.partner).tag(Role?.some(.partner))
                        }
                        .pickerStyle(.segmented)
                    }

                    Text("Steady is for understanding and connection — it isn't medical advice. If RSD is having a big impact, talk to a GP or ADHD specialist.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Button {
                        store.hasOnboarded = true
                    } label: {
                        Text("Let's begin")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(24)
            }
        }
    }

    private func feature(_ symbol: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(detail).foregroundStyle(.secondary)
            }
        }
    }
}
