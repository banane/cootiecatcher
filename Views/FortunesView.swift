import SwiftUI

/// The eight fortunes, numbered as on the flaps. Tap one to rewrite it.
struct FortunesView: View {
    @Environment(FortuneStore.self) private var store
    @State private var editing: EditTarget?
    @State private var confirmingReset = false

    private struct EditTarget: Identifiable {
        let index: Int
        var id: Int { index }
    }

    var body: some View {
        List(Array(store.fortunes.enumerated()), id: \.offset) { index, fortune in
            Button {
                editing = EditTarget(index: index)
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("\(index + 1)")
                        .foregroundStyle(.secondary)
                    Text(fortune)
                        .foregroundStyle(.primary)
                }
            }
            .accessibilityIdentifier("fortune-\(index + 1)")
        }
        .font(Theme.font(18))
        .navigationTitle("Fortunes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Reset") { confirmingReset = true }
        }
        .alert("Reset Fortunes?", isPresented: $confirmingReset) {
            Button("Reset", role: .destructive) { store.reset() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Go back to the preset fortunes. You will lose all of the fortunes you typed in.")
        }
        .sheet(item: $editing) { target in
            EditFortuneView(index: target.index)
        }
    }
}

struct EditFortuneView: View {
    let index: Int
    @Environment(FortuneStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @FocusState private var focused: Bool

    private var isBlank: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Fortune \(index + 1)") {
                    TextField("Fortune", text: $text, axis: .vertical)
                        .font(Theme.font(20))
                        .focused($focused)
                        .submitLabel(.done)
                        .onSubmit(save)
                        .accessibilityIdentifier("fortune-field")
                }
            }
            .navigationTitle("Update Fortune")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(isBlank)
                }
            }
            .onAppear {
                text = store.fortunes[index]
                focused = true
            }
        }
        .presentationDetents([.medium])
    }

    private func save() {
        guard !isBlank else { return }
        store.update(index: index, to: text)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        FortunesView()
    }
    .environment(FortuneStore(defaults: UserDefaults(suiteName: "preview")!))
}
