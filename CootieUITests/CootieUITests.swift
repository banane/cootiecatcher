import XCTest

final class CootieUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-debugFastFlips", "YES", "-debugFreshFortunes", "YES"]
        app.launch()
    }

    /// Red (3 flips → tall), then 1 on red (→ wide), then 7 on green: "You will make an amazing pie."
    func testPlayingRevealsAFortune() {
        let catcher = app.otherElements["catcher"].exists ? app.otherElements["catcher"] : app.images["catcher"]
        XCTAssertEqual(catcher.value as? String, "closed")
        XCTAssertFalse(app.buttons["again"].isEnabled)

        app.buttons["flap-red"].tap()
        XCTAssertTrue(app.staticTexts["Pick a number"].waitForExistence(timeout: 3))
        XCTAssertEqual(catcher.value as? String, "tall")

        app.buttons["flap-red"].tap()
        XCTAssertTrue(app.staticTexts["Pick a number to see your fortune"].waitForExistence(timeout: 3))
        XCTAssertEqual(catcher.value as? String, "wide")

        app.buttons["flap-green"].tap()
        let fortune = app.staticTexts["fortune"]
        XCTAssertTrue(fortune.waitForExistence(timeout: 3))
        XCTAssertEqual(fortune.label, "You will make an amazing pie.")

        app.buttons["again"].tap()
        XCTAssertFalse(fortune.exists)
        XCTAssertEqual(catcher.value as? String, "closed")
    }

    func testEditedFortuneShowsInTheGame() {
        app.buttons["menu"].tap()
        app.buttons["Fortunes"].tap()
        app.buttons["fortune-1"].tap()

        let field = app.textFields["fortune-field"].exists ? app.textFields["fortune-field"] : app.textViews["fortune-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 3))
        field.clearAndType("You will find a frog.")
        app.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["fortune-1"].staticTexts["You will find a frog."].waitForExistence(timeout: 3))

        app.navigationBars.buttons.element(boundBy: 0).tap()  // back to Menu
        app.navigationBars.buttons.element(boundBy: 0).tap()  // back to the game

        app.buttons["flap-red"].tap()     // → tall
        app.buttons["flap-blue"].tap()    // 5 flips → wide
        XCTAssertTrue(app.staticTexts["Pick a number to see your fortune"].waitForExistence(timeout: 3))
        app.buttons["flap-red"].tap()     // wide red is 8
        XCTAssertEqual(app.staticTexts["fortune"].label, "Your wish will come true.")

        app.buttons["again"].tap()
        app.buttons["flap-red"].tap()     // → tall
        app.buttons["flap-red"].tap()     // 1 flip → wide
        XCTAssertTrue(app.staticTexts["Pick a number to see your fortune"].waitForExistence(timeout: 3))
        app.buttons["again"].tap()        // disabled until a fortune shows
        XCTAssertEqual(app.staticTexts["prompt"].label, "Pick a number to see your fortune")
    }
}

private extension XCUIElement {
    func clearAndType(_ text: String) {
        tap()
        if let current = value as? String, !current.isEmpty {
            typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        }
        typeText(text)
    }
}
