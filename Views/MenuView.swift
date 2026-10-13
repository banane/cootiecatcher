import SwiftUI

/// MenuViewController from 2015: white rows on the me_jenny photo. Contact Us, I've got an idea and
/// Discuss Cootie! went with the UserVoice SDK in 2024.
struct MenuView: View {
    @State private var showingAbout = false

    var body: some View {
        List {
            Group {
                NavigationLink("Fortunes", value: Route.fortunes)
                Button("About CootieCatcher") { showingAbout = true }
            }
            .foregroundStyle(.white)
            .font(Theme.font(18))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background {
            Image("me_jenny")
                .resizable()
                .ignoresSafeArea(edges: .bottom)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
        .alert("About CootieCatcher", isPresented: $showingAbout) {
            Button("Cool") {}
        } message: {
            Text("By Anna Billstrom, with some help from her big sister Jennifer Huber.")
        }
    }
}

#Preview {
    NavigationStack {
        MenuView()
    }
}
