//
//  movieAppUITests.swift
//  movieAppUITests
//
//  Created by Amit Mathur on 9/4/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import XCTest

class movieAppUITests: XCTestCase {
    
      let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
        print(app.debugDescription)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    func testExample() {
        
        let myTable = app.tables.matching(identifier: "myUniqueTableViewIdentifier")
        let cell = myTable.cells.element(matching: .cell, identifier: "myUniqueTableViewIdentifier")
        cell.tap()
        let count = myTable.cells.count
        XCTAssert(count > 0)
    
        myTable.cells.allElementsBoundByIndex.first?.tap()
         XCTAssertEqual(myTable.cells.count, 2, "found instead: \(myTable.cells.debugDescription)")
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}


