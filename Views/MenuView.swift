import SwiftUI

struct MenuView: View {
    var body: some View {
        List {
            NavigationLink("About Cootie", value: Route.about)
            NavigationLink("Fortunes", value: Route.fortunes)
        }
        .font(Theme.font(18))
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("me_jenny")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 480)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityLabel("Anna and Jennifer")
                Text("By Anna Billstrom, with some help from her big sister Jennifer Huber.")
                    .font(Theme.font(20, relativeTo: .title3))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("About Cootie")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MenuView()
    }
}
