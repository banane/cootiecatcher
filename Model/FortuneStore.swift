import Foundation
import Observation

/// The eight fortunes under the flaps, numbered 1–8. Players can rewrite them.
@MainActor
@Observable
final class FortuneStore {
    static let presets = [
        "You will be president.",
        "Giraffes are neat.",
        "Someone will steal your pencil.",
        "Give someone a dollar.",
        "Nobody gets you, like I get you.",
        "Your secret is safe.",
        "You will make an amazing pie.",
        "Your wish will come true.",
    ]

    /// The same key the Objective-C and UIKit versions used, so players keep the fortunes they typed.
    static let defaultsKey = "fortunes"

    private(set) var fortunes: [String]
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let saved = defaults.stringArray(forKey: Self.defaultsKey) ?? []
        fortunes = saved.count == Self.presets.count ? saved : Self.presets
    }

    /// The fortune for a flap number, 1–8.
    func fortune(number: Int) -> String {
        fortunes[number - 1]
    }

    /// Replaces a fortune. Blank text is ignored.
    func update(index: Int, to text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard fortunes.indices.contains(index), !trimmed.isEmpty else { return }
        fortunes[index] = trimmed
        save()
    }

    func reset() {
        fortunes = Self.presets
        save()
    }

    private func save() {
        defaults.set(fortunes, forKey: Self.defaultsKey)
    }
}
