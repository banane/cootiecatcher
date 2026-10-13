import XCTest

final class CootieUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-debugFastFlips", "YES", "-debugFreshFortunes", "YES"]
        app.launch()
    }

    /// Red (→ wide), 8 on red (stays wide), then 7 on green: "You will make an amazing pie."
    func testPlayingRevealsAFortune() {
        let catcher = app.otherElements["catcher"].exists ? app.otherElements["catcher"] : app.images["catcher"]
        XCTAssertEqual(catcher.value as? String, "closed")
        XCTAssertFalse(app.buttons["again"].exists)

        app.buttons["flap-red"].tap()
        XCTAssertTrue(catcher.waitForValue("wide"))

        app.buttons["flap-red"].tap()
        XCTAssertTrue(catcher.waitForValue("wide"))

        app.buttons["flap-green"].tap()
        let fortune = app.staticTexts["fortune"]
        XCTAssertTrue(fortune.waitForExistence(timeout: 3))
        XCTAssertEqual(fortune.label, "You will make an amazing pie.")
        XCTAssertFalse(app.buttons["flap-red"].isHittable)  // the fortune covers the catcher

        app.buttons["again"].tap()
        XCTAssertTrue(app.buttons["flap-red"].waitForHittable(timeout: 3))
        XCTAssertFalse(fortune.exists)
        XCTAssertEqual(catcher.value as? String, "closed")
    }

    func testEditedFortuneShowsInTheGame() {
        app.buttons["menu"].tap()
        app.buttons["Fortunes"].tap()
        app.buttons["fortune-1"].tap()

        let field = app.textFields["fortune-field"].exists ? app.textFields["fortune-field"] : app.textViews["fortune-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 3))
        app.buttons["Clear"].tap()
        field.tap()
        field.typeText("You will find a frog.")
        app.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["fortune-1"].staticTexts["You will find a frog."].waitForExistence(timeout: 3))

        app.navigationBars.buttons.element(boundBy: 0).tap()  // back to Menu
        app.navigationBars.buttons.element(boundBy: 0).tap()  // back to the game

        let catcher = app.otherElements["catcher"].exists ? app.otherElements["catcher"] : app.images["catcher"]
        app.buttons["flap-red"].tap()     // → wide
        XCTAssertTrue(catcher.waitForValue("wide"))
        app.buttons["flap-yellow"].tap()  // wide yellow is 3: → tall
        XCTAssertTrue(catcher.waitForValue("tall"))
        app.buttons["flap-red"].tap()     // tall red is 1, the fortune just edited
        XCTAssertTrue(app.staticTexts["fortune"].waitForExistence(timeout: 3))
        XCTAssertEqual(app.staticTexts["fortune"].label, "You will find a frog.")
    }
}

private extension XCUIElement {
    func waitForValue(_ expected: String, timeout: TimeInterval = 3) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while value as? String != expected && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return value as? String == expected
    }

    func waitForHittable(timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while !isHittable && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return isHittable
    }
}
