//
//  CootieGame.swift
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Game logic from RootViewController.m (release 2, 2015), ported to Swift as written.
//

import Foundation
import Observation

/// The four flap buttons, with the tags they had in RootViewController.xib.
enum Flap: Int, CaseIterable, Identifiable {
    case red = 0, green = 1, blue = 2, yellow = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .red: "Red"
        case .green: "Green"
        case .blue: "Blue"
        case .yellow: "Yellow"
        }
    }
}

@MainActor
@Observable
final class CootieGame {
    var stage = 0
    var lastState = 0

    /* static arrays */
    let colors = ["red", "green", "blue", "yellow"]
    let imgNumsArray = [[1, 6, 5, 2],
                        [8, 7, 4, 3]]
    let masterImageArray = ["tall", "wide", "closed"]

    /// What closedImageView shows.
    private(set) var image = "closed"
    /// The fortune number showing, set by revealFortune. Nil while playing.
    private(set) var fortuneID: Int?

    /// Seconds for a whole flip, as in animateToy. Zero in tests.
    let duration: Double
    var playSound: () -> Void = {}
    private var animation: Task<Void, Never>?

    init(duration: Double = 2.0) {
        self.duration = duration
    }

    func click(_ sender: Flap) {
        let buttonInt = sender.rawValue
        var flipTimes = 0

        if stage == 0 {                         // color round- the char length of the word
            flipTimes = colors[buttonInt].count
        } else {                                // all other rounds interpret the id to displayed numbers based on state
            flipTimes = imgNumsArray[lastState][buttonInt]
        }

                                                // setup final display actions for rounds
        if stage < 2 {
            animateToy(flipTimes)
            playSound()
        } else if stage == 2 {
            revealFortune(flipTimes)
        }
    }

    func animateToy(_ numTimes: Int) {
        var alternator = lastState

        var animationArray: [String] = []

        for i in stride(from: 1, through: numTimes, by: 1) {

            // flip alternator
            alternator ^= 1
            animationArray.append(masterImageArray[alternator])

            // store the last state of tall/wide for next stage
            if i < numTimes && i != numTimes {
                animationArray.append(masterImageArray[2]) // helps make it the "look" of the cootiecatcher
            }
        }
        lastState = alternator

        startAnimating(animationArray, duration: duration)

        stage += 1
    }

    func cootieAnimationStopped() {
        image = masterImageArray[lastState]
    }

    func revealFortune(_ fortuneID: Int) {
        self.fortuneID = fortuneID

        //clean out closedimagearray
        image = masterImageArray[2]
    }

    func playAgain() {
        animation?.cancel()
        image = masterImageArray[2]

        fortuneID = nil

        // reset game state vars
        stage = 0
        lastState = 0
    }

    /// Stands in for closedImageView.animationImages + startAnimating, and
    /// performSelector:@selector(cootieAnimationStopped) afterDelay:duration.
    private func startAnimating(_ animationImages: [String], duration: Double) {
        animation?.cancel()
        animation = Task {
            for frame in animationImages {
                image = frame
                if duration > 0 {
                    try? await Task.sleep(for: .seconds(duration / Double(animationImages.count)))
                }
                if Task.isCancelled { return }
            }
            cootieAnimationStopped()
        }
    }

    /// Lets tests wait for the photos to finish.
    func waitForAnimation() async {
        await animation?.value
    }
}
