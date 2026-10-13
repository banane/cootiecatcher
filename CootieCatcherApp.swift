import SwiftUI

@main
struct CootieCatcherApp: App {
    @State private var game: CootieGame
    @State private var fortunes: FortuneStore
    private let sound = SoundPlayer()

    init() {
        Theme.registerFont()
        Self.setNavigationBarLook()

        var duration: Double?
        var storeURL: URL? = FortuneStore.defaultStoreURL
        #if DEBUG
        // Launch arguments for UI tests: `-debugFastFlips YES` skips the flip animation and
        // `-debugFreshFortunes YES` starts from the preset fortunes without touching the real ones.
        if UserDefaults.standard.bool(forKey: "debugFastFlips") {
            duration = 0
        }
        if UserDefaults.standard.bool(forKey: "debugFreshFortunes") {
            storeURL = nil
        }
        #endif
        _game = State(initialValue: duration.map { CootieGame(duration: $0) } ?? CootieGame())
        _fortunes = State(initialValue: FortuneStore(storeURL: storeURL))
    }

    var body: some Scene {
        WindowGroup {
            RootView(game: game)
                .environment(fortunes)
                .onAppear { game.playSound = { [sound] in sound.play() } }
        }
    }

    /// setNavigationBarLook and the window tint from the 2015 AppDelegate, plus the bar button
    /// font from MenuViewController.
    static func setNavigationBarLook() {
        guard let font = UIFont(name: Theme.fontName, size: 18) else { return }
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowColor = UIColor.gray

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: font, .shadow: shadow]
        let buttons = UIBarButtonItemAppearance()
        buttons.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: font]
        appearance.buttonAppearance = buttons
        appearance.backButtonAppearance = buttons
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

enum Route: Hashable {
    case menu
    case fortunes
    case editFortune(Int)
}

struct RootView: View {
    let game: CootieGame
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            CootieView(game: game, showMenu: { path.append(.menu) })
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .menu: MenuView()
                    case .fortunes: FortunesView()
                    case .editFortune(let index): EditFortuneView(index: index)
                    }
                }
        }
        .tint(.black)
    }
}
