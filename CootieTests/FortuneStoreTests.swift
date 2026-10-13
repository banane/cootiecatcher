import Foundation
import Testing
@testable import Cootie

@MainActor
struct FortuneStoreTests {
    private func throwawayDefaults() -> UserDefaults {
        let name = "FortuneStoreTests-\(UUID().uuidString)"
        return UserDefaults(suiteName: name)!
    }

    @Test func firstLaunchUsesThePresets() {
        let store = FortuneStore(defaults: throwawayDefaults())
        #expect(store.fortunes == FortuneStore.presets)
        #expect(store.fortune(number: 2) == "Giraffes are neat.")
    }

    @Test func keepsFortunesSavedByTheOldApp() {
        let defaults = throwawayDefaults()
        var saved = FortuneStore.presets
        saved[0] = "You will find a frog."
        defaults.set(saved, forKey: "fortunes")

        #expect(FortuneStore(defaults: defaults).fortune(number: 1) == "You will find a frog.")
    }

    @Test func ignoresASavedListOfTheWrongLength() {
        let defaults = throwawayDefaults()
        defaults.set(["Only one"], forKey: "fortunes")

        #expect(FortuneStore(defaults: defaults).fortunes == FortuneStore.presets)
    }

    @Test func editsAreTrimmedAndSaved() {
        let defaults = throwawayDefaults()
        FortuneStore(defaults: defaults).update(index: 7, to: "  Pizza for dinner.\n")

        #expect(FortuneStore(defaults: defaults).fortune(number: 8) == "Pizza for dinner.")
    }

    @Test func blankEditIsIgnored() {
        let store = FortuneStore(defaults: throwawayDefaults())
        store.update(index: 0, to: "   ")
        #expect(store.fortune(number: 1) == FortuneStore.presets[0])
    }

    @Test func resetRestoresThePresets() {
        let defaults = throwawayDefaults()
        let store = FortuneStore(defaults: defaults)
        store.update(index: 3, to: "Changed")
        store.reset()

        #expect(FortuneStore(defaults: defaults).fortunes == FortuneStore.presets)
    }
}
