import SwiftUI

@main
struct CootieCatcherApp: App {
    @State private var game: CootieGame
    @State private var fortunes: FortuneStore
    private let sound = SoundPlayer()

    init() {
        Theme.registerFont()
        if let titleFont = UIFont(name: Theme.fontName, size: 18) {
            UINavigationBar.appearance().titleTextAttributes = [.font: titleFont]
        }
        if let largeTitleFont = UIFont(name: Theme.fontName, size: 32) {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: largeTitleFont]
        }

        var frameDuration = Duration.milliseconds(200)
        var defaults = UserDefaults.standard
        #if DEBUG
        // Launch arguments for UI tests: `-debugFastFlips YES` skips the flip animation and
        // `-debugFreshFortunes YES` starts from the preset fortunes without touching the real ones.
        if UserDefaults.standard.bool(forKey: "debugFastFlips") {
            frameDuration = .zero
        }
        if UserDefaults.standard.bool(forKey: "debugFreshFortunes") {
            let suite = "ui-tests"
            UserDefaults().removePersistentDomain(forName: suite)
            defaults = UserDefaults(suiteName: suite) ?? .standard
        }
        #endif
        _game = State(initialValue: CootieGame(frameDuration: frameDuration))
        _fortunes = State(initialValue: FortuneStore(defaults: defaults))
    }

    var body: some Scene {
        WindowGroup {
            RootView(game: game)
                .environment(fortunes)
                .onAppear { game.onFlip = { [sound] in sound.play() } }
        }
    }
}

enum Route: Hashable {
    case menu
    case about
    case fortunes
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
                    case .about: AboutView()
                    case .fortunes: FortunesView()
                    }
                }
        }
        .tint(.primary)
    }
}
