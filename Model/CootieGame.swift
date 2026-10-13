import Foundation
import Observation

/// One of the four coloured corners of the cootie catcher, laid out as in the photos:
/// yellow top-left, blue top-right, red bottom-left, green bottom-right.
enum Flap: String, CaseIterable, Identifiable {
    case yellow, blue, red, green

    var id: String { rawValue }

    /// The first pick spells the colour out, one flip per letter.
    var spellingLength: Int { rawValue.count }

    var label: String { rawValue.capitalized }
}

/// What the cootie catcher looks like right now. Each pose has its own photo.
enum Pose: String {
    case closed, tall, wide

    var imageName: String { rawValue }

    /// The number written inside each flap when the catcher is open this way, as printed on `tall.png` and `wide.png`.
    func number(on flap: Flap) -> Int? {
        switch (self, flap) {
        case (.tall, .red): 1
        case (.tall, .yellow): 2
        case (.tall, .blue): 5
        case (.tall, .green): 6
        case (.wide, .yellow): 3
        case (.wide, .blue): 4
        case (.wide, .green): 7
        case (.wide, .red): 8
        case (.closed, _): nil
        }
    }

    var opposite: Pose {
        switch self {
        case .tall: .wide
        case .wide, .closed: .tall
        }
    }
}

/// The game: pick a colour, pick a number, pick a number again to read your fortune.
@MainActor
@Observable
final class CootieGame {
    enum Stage: Equatable {
        case pickColor
        case pickNumber
        case pickFortune
        /// The fortune under this number (1–8) is showing.
        case revealed(Int)
    }

    private(set) var pose: Pose = .closed
    private(set) var stage: Stage = .pickColor
    private(set) var isFlipping = false

    /// How long each photo shows while flipping. Zero in tests.
    let frameDuration: Duration
    /// Called once at the start of every flip sequence, for the paper sound.
    var onFlip: () -> Void = {}

    init(frameDuration: Duration = .milliseconds(200)) {
        self.frameDuration = frameDuration
    }

    var fortuneNumber: Int? {
        if case .revealed(let number) = stage { number } else { nil }
    }

    var canTap: Bool {
        !isFlipping && fortuneNumber == nil
    }

    var prompt: String {
        switch stage {
        case .pickColor: "Pick a color"
        case .pickNumber: "Pick a number"
        case .pickFortune: "Pick a number to see your fortune"
        case .revealed: ""
        }
    }

    func tap(_ flap: Flap) async {
        guard canTap else { return }
        switch stage {
        case .pickColor:
            await flip(times: flap.spellingLength)
            stage = .pickNumber
        case .pickNumber:
            guard let number = pose.number(on: flap) else { return }
            await flip(times: number)
            stage = .pickFortune
        case .pickFortune:
            guard let number = pose.number(on: flap) else { return }
            stage = .revealed(number)
        case .revealed:
            break
        }
    }

    func playAgain() {
        guard !isFlipping else { return }
        pose = .closed
        stage = .pickColor
    }

    /// The photos shown while flipping `times` times from `start`: each opening, with the closed photo between them.
    static func frames(from start: Pose, flips times: Int) -> [Pose] {
        var frames: [Pose] = []
        var open = start
        for flip in 1...max(times, 1) {
            open = open.opposite
            frames.append(open)
            if flip < times { frames.append(.closed) }
        }
        return frames
    }

    private func flip(times: Int) async {
        isFlipping = true
        defer { isFlipping = false }
        onFlip()
        for frame in Self.frames(from: pose, flips: times) {
            pose = frame
            if frameDuration > .zero {
                try? await Task.sleep(for: frameDuration)
            }
        }
    }
}
