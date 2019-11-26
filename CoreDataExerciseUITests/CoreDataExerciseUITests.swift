//
//  CoreDataExerciseUITests.swift
//  CoreDataExerciseUITests
//
//  Created by Ratul Chhibber on 10/27/19.
//  Copyright © 2019 Ratul Chhibber. All rights reserved.
//

import XCTest

class CoreDataExerciseUITests: XCTestCase {

    private lazy var app = XCUIApplication()
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testNavigationToContentScreen() {
        app.launch()
        let firstPost = app.tables.cells.element(boundBy: 0)
        XCTAssert(firstPost.waitForExistence(timeout: 5),
                  "First post could not be found")
        firstPost.tap()
        let title = app.navigationBars["Selected Post Content"]
        
        XCTAssert(title.waitForExistence(timeout: 5), "Content screen title not showing")
    }
}
