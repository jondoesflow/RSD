import XCTest

/// Walks through the app in demo mode (neutral names, sample data) and attaches
/// a screenshot of each key screen. `.github/workflows/screenshots.yml` exports
/// them to the `app-store-screenshots` branch.
final class ScreenshotTests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-demo"]
        app.launch()
    }

    @MainActor
    func testAppStoreScreenshots() {
        // 1. Right now
        XCTAssertTrue(app.buttons["phase-storm"].waitForExistence(timeout: 15))
        snap("01-right-now")

        // 2. Storm guide
        app.buttons["phase-storm"].tap()
        XCTAssertTrue(app.navigationBars["Storm"].waitForExistence(timeout: 5))
        snap("02-storm")
        goBack()

        // 3. Signal cards
        let cards = app.buttons["Signal cards"]
        XCTAssertTrue(cards.waitForExistence(timeout: 5))
        cards.tap()
        XCTAssertTrue(app.buttons["Close"].waitForExistence(timeout: 5))
        snap("03-signal-cards")
        app.buttons["Close"].tap()

        // 4. Feelings finder with a few clues picked
        let finder = app.buttons["feelings-finder"]
        XCTAssertTrue(finder.waitForExistence(timeout: 5))
        finder.tap()
        for clue in ["Hot face or neck", "Stomach drop", "Close to tears", "Hide or leave the room"] {
            let chip = app.buttons[clue]
            XCTAssertTrue(chip.waitForExistence(timeout: 5), clue)
            chip.tap()
        }
        app.swipeUp()
        app.swipeUp()
        snap("04-feelings-finder")
        goBack()

        // 5. Translate, with one situation opened
        app.tabBars.buttons["Translate"].tap()
        let situation = app.buttons["situation-text"]
        XCTAssertTrue(situation.waitForExistence(timeout: 5))
        situation.tap()
        snap("05-translate")

        // 6. Our plan
        app.tabBars.buttons["Us"].tap()
        XCTAssertTrue(app.navigationBars["Alex & Sam"].waitForExistence(timeout: 5))
        snap("06-us")

        // 7. Understand
        app.tabBars.buttons["Understand"].tap()
        XCTAssertTrue(app.navigationBars["Understand"].waitForExistence(timeout: 5))
        snap("07-understand")
    }

    @MainActor
    private func goBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    @MainActor
    private func snap(_ name: String) {
        sleep(1) // let animations settle
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
