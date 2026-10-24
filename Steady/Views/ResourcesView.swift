import SwiftUI

struct ResourcesView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(Resource.Kind.allCases, id: \.self) { kind in
                    Section {
                        ForEach(Content.resources.filter { $0.kind == kind }) { resource in
                            ResourceRow(resource: resource)
                        }
                    } header: {
                        Label(kind.rawValue, systemImage: kind.symbol)
                    } footer: {
                        if kind == .support {
                            Text("If anyone is in immediate danger, call 999.")
                        }
                    }
                }
            }
            .navigationTitle("Listen & read")
        }
    }
}

private struct ResourceRow: View {
    let resource: Resource

    var body: some View {
        if let url = URL(string: resource.url) {
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(resource.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: url.scheme == "https" ? "arrow.up.right.square" : "phone.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                    Text(resource.by)
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                    Text(resource.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }
        }
    }
}
