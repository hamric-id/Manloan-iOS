//
//  DocumentViewerUITests.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 20/08/26.
//

import XCTest

final class DocumentViewerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testDocumentCellTappable() {
        let cell = app.tables.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.tap()
    }
}
