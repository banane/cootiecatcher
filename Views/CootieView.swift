import SwiftUI

/// The main screen: the paper cootie catcher, with a tap target over each coloured flap.
struct CootieView: View {
    let game: CootieGame
    let showMenu: () -> Void
    @Environment(FortuneStore.self) private var fortunes

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)

            catcher

            Spacer(minLength: 0)

            HStack {
                Spacer()
                PaperButton(title: "Settings", action: showMenu)
                    .accessibilityIdentifier("menu")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Self.background.ignoresSafeArea())
        .overlay { fortuneScreen }
        .animation(.easeInOut(duration: 0.4), value: game.fortuneID)
    }

    private var catcher: some View {
        Image(game.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .accessibilityElement()
            .accessibilityLabel("Cootie catcher")
            .accessibilityValue(game.image)
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
            game.click(flap)
        } label: {
            Color.clear
                .contentShape(Rectangle())
        }
        .accessibilityLabel(flap.label)
        .accessibilityValue(number(on: flap).map(String.init) ?? "")
        .accessibilityIdentifier("flap-\(flap.label.lowercased())")
    }

    /// The number printed on a flap in the photo showing, for VoiceOver.
    private func number(on flap: Flap) -> Int? {
        guard let row = game.masterImageArray.firstIndex(of: game.image), row < 2 else { return nil }
        return game.imgNumsArray[row][flap.rawValue]
    }

    /// RootViewController's background.
    static let background = Color(white: 0.02173913043)

    /// The fortune on a black screen. As in revealFortune, the catcher and flaps are hidden,
    /// Again shows, and Settings stays.
    @ViewBuilder
    private var fortuneScreen: some View {
        if let number = game.fortuneID {
            VStack(spacing: 20) {
                Spacer()
                Text(fortunes.fortune(number: number))
                    .font(Theme.font(36, relativeTo: .largeTitle))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.5)
                    .accessibilityIdentifier("fortune")
                Spacer()
                HStack {
                    PaperButton(title: "Again", action: game.playAgain)
                        .accessibilityIdentifier("again")
                    Spacer()
                    PaperButton(title: "Settings", action: showMenu)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .accessibilityAddTraits(.isModal)
            .transition(.opacity)
        }
    }
}

/// The white button from the xibs, styled by makeCootie in UIButton+Cootie:
/// WalterTurncoat 18, 6pt padding, sized to fit its title.
struct PaperButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.font(18))
                .foregroundStyle(.black)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .frame(minHeight: 37)
                .background(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CootieView(game: CootieGame(), showMenu: {})
        .environment(FortuneStore(storeURL: nil))
}
