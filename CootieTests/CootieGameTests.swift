import Foundation
import Testing
@testable import Cootie

@MainActor
struct CootieGameTests {
    @Test func colorRoundFlipsOncePerLetter() async {
        let game = CootieGame(duration: 0)
        var sounds = 0
        game.playSound = { sounds += 1 }

        game.click(.red)            // r-e-d: three openings, wide/tall/wide
        await game.waitForAnimation()

        #expect(game.image == "wide")
        #expect(game.lastState == 1)
        #expect(game.stage == 1)
        #expect(sounds == 1)
    }

    @Test func evenFlipsEndWhereTheyStarted() async {
        let game = CootieGame(duration: 0)
        game.click(.blue)           // b-l-u-e: four openings end tall
        await game.waitForAnimation()
        #expect(game.image == "tall")
    }

    @Test func aFlipTakesTheWholeDurationHoweverManyPhotos() async {
        let game = CootieGame(duration: 0.3)
        let clock = ContinuousClock()

        let elapsed = await clock.measure {
            game.click(.yellow)     // six openings, eleven photos
            await game.waitForAnimation()
        }

        #expect(elapsed >= .milliseconds(300))
        #expect(elapsed < .milliseconds(1500))
        #expect(game.image == "tall")
    }

    @Test func twoFlipRoundsThenTheFortune() async {
        let game = CootieGame(duration: 0)

        game.click(.red)            // → wide
        await game.waitForAnimation()
        game.click(.green)          // wide green is 7: odd → tall
        await game.waitForAnimation()
        #expect(game.image == "tall")
        #expect(game.stage == 2)

        game.click(.blue)           // tall blue is 5
        #expect(game.fortuneID == 5)
        #expect(game.image == "closed")
    }

    @Test func playAgainResets() async {
        let game = CootieGame(duration: 0)
        game.click(.red)
        await game.waitForAnimation()
        game.click(.red)            // wide red is 8: even → wide
        await game.waitForAnimation()
        game.click(.yellow)         // wide yellow is 3
        #expect(game.fortuneID == 3)

        game.playAgain()
        #expect(game.fortuneID == nil)
        #expect(game.image == "closed")
        #expect(game.stage == 0)
        #expect(game.lastState == 0)
    }
}
