import SwiftUI

/// FortuneViewController from 2015: the fortunes in order, with Reset in the navigation bar.
struct FortunesView: View {
    @Environment(FortuneStore.self) private var store
    @State private var confirmingReset = false

    var body: some View {
        List(Array(store.fortunes.enumerated()), id: \.offset) { index, fortune in
            NavigationLink(value: Route.editFortune(index)) {
                Text(fortune)
                    .font(Theme.font(18))
                    .foregroundStyle(.black)
            }
            .accessibilityIdentifier("fortune-\(index + 1)")
        }
        .listStyle(.plain)
        .navigationTitle("Fortunes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Reset") { confirmingReset = true }
        }
        .alert("Reset Fortunes", isPresented: $confirmingReset) {
            Button("OK") { store.reset() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Go back to preset fortunes. You will lose all of your typed in fortunes.")
        }
    }
}

/// DetailViewController from 2015: a text field with Clear and Save.
struct EditFortuneView: View {
    let index: Int
    @Environment(FortuneStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 79) {
            TextField("", text: $text)
                .font(Theme.font(20))
                .foregroundStyle(.black)
                .padding(.horizontal, 8)
                .frame(height: 31)
                .background(.white, in: RoundedRectangle(cornerRadius: 5))
                .focused($focused)
                .submitLabel(.done)
                .onSubmit { focused = false }
                .accessibilityIdentifier("fortune-field")

            HStack(spacing: 46) {
                PaperButton(title: "Clear") { text = "" }
                PaperButton(title: "Save") {
                    store.update(index: index, to: text)
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.top, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Edit Fortune")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { text = store.fortunes[index] }
    }
}

#Preview {
    NavigationStack {
        FortunesView()
    }
    .environment(FortuneStore(storeURL: nil))
}
