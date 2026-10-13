import Foundation
import Testing
@testable import Cootie

@MainActor
struct FortuneStoreTests {
    private func throwawayStoreURL() -> URL {
        URL.temporaryDirectory.appending(path: "FortuneStoreTests-\(UUID().uuidString).sqlite")
    }

    @Test func firstLaunchAddsThePresets() {
        let store = FortuneStore(storeURL: nil)
        #expect(store.fortunes == FortuneStore.resetValues)
        #expect(store.fortune(number: 2) == "Giraffes are neat.")
    }

    @Test func editsAreSavedToTheStoreFile() {
        let url = throwawayStoreURL()
        FortuneStore(storeURL: url).update(index: 7, to: "Pizza for dinner.")

        let reopened = FortuneStore(storeURL: url)
        #expect(reopened.fortune(number: 8) == "Pizza for dinner.")
        #expect(reopened.fortunes.count == 8)
    }

    @Test func resetRestoresThePresets() {
        let url = throwawayStoreURL()
        let store = FortuneStore(storeURL: url)
        store.update(index: 3, to: "Changed")
        store.reset()

        #expect(store.fortunes == FortuneStore.resetValues)
        #expect(FortuneStore(storeURL: url).fortunes == FortuneStore.resetValues)
    }
}
