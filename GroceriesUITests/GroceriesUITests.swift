import XCTest

// Note: tests are passing fine locally. If they
// become flakey, consider calling wait(for: animationDelay)
// on cell selection/deselection and section expand/collapse.

final class GroceriesUITests: XCTestCase {
    
    // seconds
    private let animationDelay: Double = 0.3
    
    private let app = XCUIApplication()
    
    override func setUp() {
        app.launchArguments.append("--ui-testing")
        sleep(5)
    }

    // these are the only elements that are examined
    // in this file
    func testInitialStateOfElements() {
        let bananaCell = cell(.banana)
        let lambCell = cell(.lamb)
        let asparagusCell = cell(.asaparagus)
        let cabbageCell = cell(.cabbage)
        let header = header(.vegetables)
        XCTAssertTrue(bananaCell.exists)
        XCTAssertFalse(bananaCell.isSelected)
        XCTAssertTrue(lambCell.exists)
        XCTAssertFalse(lambCell.isSelected)
        XCTAssertTrue(cabbageCell.exists)
        XCTAssertFalse(cabbageCell.isSelected)
        XCTAssertTrue(asparagusCell.exists)
        XCTAssertFalse(asparagusCell.isSelected)
        XCTAssertTrue(header.exists)
    }

    func testToggleCabbageCellSelection() {
        
        app.launch()
        
        // given
        let cabbageCell = cell(.cabbage)
        
        // when
        cabbageCell.tap()
        
        // then
        XCTAssertTrue(cabbageCell.isSelected)
        
        // when
        cabbageCell.tap()
        
        // then
        XCTAssertFalse(cabbageCell.isSelected)
    }

    func testSingleSelectionMode() {
        
        app.launch()
        
        // given
        let asparagusCell = cell(.asaparagus)
        let cabbageCell = cell(.cabbage)

        // when
        cabbageCell.tap()
        
        // then
        XCTAssertTrue(cabbageCell.isSelected)
        
        // when
        asparagusCell.tap()
        
        // then
        XCTAssertFalse(cabbageCell.isSelected)
    }
    
    func testHeaderTapExpandsCollapses() {
        
        app.launch()
        
        // given
        let cabbageCell = cell(.cabbage)
        let header = header(.vegetables)
        
        // when
        header.tap()
        
        // and - animation completes
//        wait(for: animationDelay)
        
        // then
        XCTAssertFalse(cabbageCell.exists)
        
        // when
        header.tap()
        
        // then
        let exists = cabbageCell.waitForExistence(timeout: animationDelay)
        XCTAssertTrue(exists)
    }

    func testSelectionMemorised() {

        app.launch()
        
        // given
        let cabbageCell = cell(.cabbage)
        let header = header(.vegetables)
        
        // when - cabbage is selected
        cabbageCell.tap()
        header.tap()
        
        // and - animations complete
        wait(for: animationDelay)
        
        // when - section expands
        header.tap()
        
        // and - animation completes
        wait(for: animationDelay)
        
        // then - cell is still selected
        XCTAssertTrue(cabbageCell.isSelected)
    }

    func testCellDeselectionInCollapsedSection() {

        app.launch()
        
        // given
        let lambCell = cell(.lamb)
        let cabbageCell = cell(.cabbage)
        let header = header(.vegetables)

        // when
        cabbageCell.tap()
        header.tap()

        // and - animation completes
//        wait(for: animationDelay)
        
        // when
        lambCell.tap()
        header.tap()

        // and
        let exists = cabbageCell.waitForExistence(timeout: animationDelay)
        XCTAssertTrue(exists)
        
        // then - cell did deselect in collapsed state
        XCTAssertFalse(cabbageCell.isSelected)
    }
    
    func testCommandLineArgumentSelectBananaCell() {
        
        // given
        app.launchArguments.append("--programmatically-select-banana")
        
        // when
        app.launch()
        
        // then
        XCTAssertTrue(cell(.banana).isSelected)
    }

    func testDeselectionOfProgrammaticallySelectedRow() {
        
        app.launchArguments.append("--programmatically-select-banana")
        app.launch()
        
        // given
        let bananaCell = cell(.banana)
        
        // when
        bananaCell.tap()
        
        // then
        XCTAssertFalse(bananaCell.isSelected)
    }
    
    private func wait(for delay: Double) {
        let second: Double = 1000000
        usleep(useconds_t(delay * second))
    }
    
    private func cell(_ cell: Cell) -> XCUIElement {
        app.tables.cells[cell.rawValue]
    }
    
    private func header(_ header: Header) -> XCUIElement {
        app.tables.children(matching: .other)[header.rawValue]
    }
    
    private enum Cell: String {
        case asaparagus = "Asparagus"
        case lamb = "Lamb"
        case cabbage = "Cabbage"
        case banana = "Banana"
    }
    
    private enum Header: String {
        case vegetables = "Vegetables"
    }
}
