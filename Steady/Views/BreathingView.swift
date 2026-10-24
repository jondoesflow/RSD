import SwiftUI

/// Box breathing (4-4-4-4). Doing it side by side helps co-regulate.
struct BreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step = 0
    @State private var running = false
    @State private var rounds = 0

    private let steps: [(label: String, scale: CGFloat)] = [
        ("Breathe in", 1.0),
        ("Hold", 1.0),
        ("Breathe out", 0.45),
        ("Hold", 0.45)
    ]
    private let seconds = 4.0

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("Sit side by side. Breathe at the circle's pace together. Nobody has to talk.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(0.15))
                        .frame(width: 280, height: 280)
                    Circle()
                        .fill(Color.teal.gradient)
                        .frame(width: 280, height: 280)
                        .scaleEffect(running ? steps[step].scale : 0.45)
                        .animation(.easeInOut(duration: seconds), value: step)
                        .animation(.easeInOut(duration: seconds), value: running)
                    Text(running ? steps[step].label : "Ready?")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .contentTransition(.opacity)
                }

                Text(rounds > 0 ? "\(rounds) round\(rounds == 1 ? "" : "s")" : " ")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Button(running ? "Stop" : "Start") {
                    running.toggle()
                    if running { step = 0; rounds = 0 }
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
                .controlSize(.large)
            }
            .padding()
            .navigationTitle("Breathe together")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
            .task(id: running) {
                guard running else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(seconds))
                    guard !Task.isCancelled, running else { return }
                    step = (step + 1) % steps.count
                    if step == 0 { rounds += 1 }
                }
            }
        }
    }
}
