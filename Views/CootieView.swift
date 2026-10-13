import SwiftUI

/// The main screen: the paper cootie catcher, with a tap target over each coloured flap.
struct CootieView: View {
    let game: CootieGame
    let showMenu: () -> Void
    @Environment(FortuneStore.self) private var fortunes

    var body: some View {
        VStack(spacing: 20) {
            Text(game.prompt)
                .font(Theme.font(22, relativeTo: .title2))
                .foregroundStyle(.white)
                .frame(minHeight: 32)
                .accessibilityIdentifier("prompt")

            catcher

            fortuneCard

            Spacer(minLength: 0)

            HStack(spacing: 16) {
                PaperButton(title: "Again", action: game.playAgain)
                    .disabled(game.fortuneNumber == nil)
                    .accessibilityIdentifier("again")
                PaperButton(title: "Menu", action: showMenu)
                    .accessibilityIdentifier("menu")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }

    private var catcher: some View {
        Image(game.pose.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .accessibilityElement()
            .accessibilityLabel("Cootie catcher")
            .accessibilityValue(game.pose.rawValue)
            .accessibilityIdentifier("catcher")
            .overlay {
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    GridRow {
                        flapButton(.yellow)
                        flapButton(.blue)
                    }
                    GridRow {
                        flapButton(.red)
                        flapButton(.green)
                    }
                }
            }
            .frame(maxWidth: 420)
    }

    private func flapButton(_ flap: Flap) -> some View {
        Button {
            Task { await game.tap(flap) }
        } label: {
            Color.clear
                .contentShape(Rectangle())
        }
        .disabled(!game.canTap)
        .accessibilityLabel(flap.label)
        .accessibilityValue(game.pose.number(on: flap).map(String.init) ?? "")
        .accessibilityIdentifier("flap-\(flap.rawValue)")
    }

    @ViewBuilder
    private var fortuneCard: some View {
        if let number = game.fortuneNumber {
            Text(fortunes.fortune(number: number))
                .font(Theme.font(22, relativeTo: .title2))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(white: 0.95), in: RoundedRectangle(cornerRadius: 12))
                .accessibilityIdentifier("fortune")
                .transition(.scale.combined(with: .opacity))
        }
    }
}

/// White button with the hand-lettered font, as on the original main screen.
struct PaperButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.font(18))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(.white, in: RoundedRectangle(cornerRadius: 10))
                .opacity(isEnabled ? 1 : 0.5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CootieView(game: CootieGame(), showMenu: {})
        .environment(FortuneStore(defaults: UserDefaults(suiteName: "preview")!))
}
