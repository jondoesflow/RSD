import SwiftUI

/// {J}'s personal RSD profile, the pause word, a letter to {K}, and the moments log.
struct UsView: View {
    @Environment(Store.self) private var store
    @State private var editingProfile = false
    @State private var newMoment: Moment?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    P(store.profile.letter)
                        .font(.body.italic())
                        .padding(.vertical, 6)
                } header: {
                    P("A note from {J}")
                }

                profileSection("What can set it off", items: store.profile.triggers, symbol: "bolt.fill", tint: .orange)
                profileSection("Early warning signs", items: store.profile.earlySigns, symbol: "exclamationmark.triangle.fill", tint: .yellow)
                profileSection("What helps", items: store.profile.whatHelps, symbol: "heart.fill", tint: .pink)
                profileSection("What makes it worse", items: store.profile.whatDoesnt, symbol: "hand.raised.fill", tint: .gray)

                Section {
                    Button {
                        newMoment = Moment()
                    } label: {
                        Label("Log a moment", systemImage: "plus.circle.fill")
                    }
                    NavigationLink {
                        MomentsView()
                    } label: {
                        LabeledContent("Moments log", value: "\(store.moments.count)")
                    }
                    NavigationLink {
                        SyncView()
                    } label: {
                        Label("Sync with \(store.otherName)", systemImage: "arrow.triangle.2.circlepath")
                    }
                    ForEach(store.commonTriggers) { item in
                        Label("“\(item.text)” — \(item.count) times", systemImage: "chart.bar.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Spotting patterns")
                } footer: {
                    P("Logging RSD moments — even briefly — makes patterns easier to see for both of you. Sync shares them between your two phones directly, with nothing sent online.")
                }
            }
            .navigationTitle("\(store.names.me) & \(store.names.partner)")
            .toolbar {
                Button("Edit") { editingProfile = true }
            }
            .sheet(isPresented: $editingProfile) {
                ProfileEditor().environment(store)
            }
            .sheet(item: $newMoment) { moment in
                MomentEditor(moment: moment).environment(store)
            }
        }
    }

    private func profileSection(_ title: String, items: [String], symbol: String, tint: Color) -> some View {
        Section(title) {
            if items.isEmpty {
                Text("Nothing added yet — tap Edit.").foregroundStyle(.secondary)
            }
            ForEach(items, id: \.self) { item in
                Label {
                    P(item)
                } icon: {
                    Image(systemName: symbol).foregroundStyle(tint)
                }
            }
        }
    }
}

struct ProfileEditor: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
                Section {
                    TextField("Your name", text: $store.profile.names.me)
                    TextField("Partner's name", text: $store.profile.names.partner)
                } header: {
                    Text("Names")
                } footer: {
                    Text("Used throughout the app.")
                }

                Section {
                    TextField("Pause word", text: $store.profile.pauseWord)
                    Stepper("Time-out: \(store.profile.pauseMinutes) minutes", value: $store.profile.pauseMinutes, in: 5...60, step: 5)
                } header: {
                    Text("Pause word")
                } footer: {
                    Text("Pick something neutral or silly that you'd never say by accident. Gottman's research suggests at least 20 minutes to properly calm down.")
                }

                Section {
                    TextField("Letter", text: $store.profile.letter, axis: .vertical)
                        .lineLimit(4...12)
                } header: {
                    Text("A note to your partner")
                } footer: {
                    Text("Write this on a calm day. Use {K} for your partner's name.")
                }

                EditableList(title: "What can set it off", footer: "Swipe to delete, drag to reorder.", items: $store.profile.triggers)
                EditableList(title: "Early warning signs", footer: "What do you (or they) notice first?", items: $store.profile.earlySigns)
                EditableList(title: "What helps", footer: "Shown on the Wobble and Storm guides.", items: $store.profile.whatHelps)
                EditableList(title: "What makes it worse", footer: "Shown on the Storm guide.", items: $store.profile.whatDoesnt)
                EditableList(title: "Check-in messages", footer: "Quick messages your partner can send from Right now.", items: $store.profile.checkIns)
            }
            .navigationTitle("Edit our plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }
}

struct MomentsView: View {
    @Environment(Store.self) private var store
    @State private var editing: Moment?

    var body: some View {
        List {
            if store.moments.isEmpty {
                ContentUnavailableView(
                    "No moments yet",
                    systemImage: "calendar.badge.clock",
                    description: Text("After an RSD moment, jot down what happened. Over time you'll see what sets it off and what helps.")
                )
            }
            ForEach(store.moments) { moment in
                Button {
                    editing = moment
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label(moment.phase.title, systemImage: moment.phase.symbol)
                                .foregroundStyle(moment.phase.color)
                                .font(.subheadline.bold())
                            Spacer()
                            Text(moment.date, format: .dateTime.day().month().hour().minute())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if !moment.trigger.isEmpty { Text(moment.trigger) }
                        if !moment.helped.isEmpty {
                            Text("Helped: \(moment.helped)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if !moment.loggedBy.isEmpty {
                            Label("Logged by \(moment.loggedBy)", systemImage: "person.crop.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .onDelete { store.deleteMoments(at: $0) }
        }
        .navigationTitle("Moments")
        .toolbar {
            Button {
                editing = Moment()
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $editing) { moment in
            MomentEditor(moment: moment).environment(store)
        }
    }
}

struct MomentEditor: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State var moment: Moment

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("When", selection: $moment.date)
                    Picker("How big", selection: $moment.phase) {
                        ForEach(Phase.allCases) { Text($0.title).tag($0) }
                    }
                }
                Section("What set it off?") {
                    TextField("e.g. A short text reply", text: $moment.trigger, axis: .vertical)
                }
                Section("What did it feel like?") {
                    TextField("e.g. Shame wave, hot face, wanted to hide", text: $moment.feltLike, axis: .vertical)
                }
                Section("What helped?") {
                    TextField("e.g. Pause word, then a hug", text: $moment.helped, axis: .vertical)
                }
                Section("Anything else?") {
                    TextField("Notes", text: $moment.notes, axis: .vertical)
                        .lineLimit(3...8)
                }
            }
            .navigationTitle("RSD moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.update(moment)
                        dismiss()
                    }
                }
            }
        }
    }
}
