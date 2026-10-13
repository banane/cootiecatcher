import Testing
@testable import Cootie

@MainActor
struct CootieGameTests {
    @Test func flapNumbersMatchThePhotos() {
        #expect(Flap.allCases.compactMap { Pose.tall.number(on: $0) }.sorted() == [1, 2, 5, 6])
        #expect(Flap.allCases.compactMap { Pose.wide.number(on: $0) }.sorted() == [3, 4, 7, 8])
        #expect(Pose.closed.number(on: .red) == nil)
    }

    @Test func framesAlternateWithClosedBetween() {
        #expect(CootieGame.frames(from: .closed, flips: 3) == [.tall, .closed, .wide, .closed, .tall])
        #expect(CootieGame.frames(from: .tall, flips: 1) == [.wide])
    }

    @Test func pickingAColorFlipsOncePerLetter() async {
        let game = CootieGame(frameDuration: .zero)
        var flips = 0
        game.onFlip = { flips += 1 }

        await game.tap(.blue)  // b-l-u-e: four flips from closed ends wide

        #expect(game.pose == .wide)
        #expect(game.stage == .pickNumber)
        #expect(flips == 1)
    }

    @Test func fullGameRevealsTheNumberPicked() async {
        let game = CootieGame(frameDuration: .zero)

        await game.tap(.red)       // three flips: closed → tall
        #expect(game.pose == .tall)
        await game.tap(.green)     // tall green is 6: even, so still tall
        #expect(game.pose == .tall)
        #expect(game.stage == .pickFortune)
        await game.tap(.blue)      // tall blue is 5

        #expect(game.fortuneNumber == 5)
        #expect(!game.canTap)
    }

    @Test func tapsAfterTheRevealAreIgnoredUntilPlayAgain() async {
        let game = CootieGame(frameDuration: .zero)
        await game.tap(.red)
        await game.tap(.red)       // tall red is 1: flips to wide
        await game.tap(.yellow)    // wide yellow is 3
        #expect(game.fortuneNumber == 3)

        await game.tap(.green)
        #expect(game.fortuneNumber == 3)

        game.playAgain()
        #expect(game.pose == .closed)
        #expect(game.stage == .pickColor)
        #expect(game.canTap)
    }
}
