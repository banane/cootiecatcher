import AVFoundation

/// Plays the paper-rustle sound when the cootie catcher flips.
@MainActor
final class SoundPlayer {
    private let player: AVAudioPlayer?

    init(resource: String = "cootie", ext: String = "wav") {
        player = Bundle.main.url(forResource: resource, withExtension: ext)
            .flatMap { try? AVAudioPlayer(contentsOf: $0) }
        player?.prepareToPlay()
    }

    func play() {
        player?.currentTime = 0
        player?.play()
    }
}
