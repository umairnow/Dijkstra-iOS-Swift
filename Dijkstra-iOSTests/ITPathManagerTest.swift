//
//  ITPathManagerTest.swift
//  Dijkstra-iOS
//
//  Created by Umair Aamir on 3/20/16.
//  Copyright © 2016 Umair & Co. All rights reserved.
//

import XCTest

class ITPathManagerTest: XCTestCase {
    
    let manager = ITPathManager(columns: 2, arrWords: ["This", "is", "a", "matrix", "of", "two", "dimensional", "array"])
    let expectedPath = [0, 3, 4, 6, 7]
    
    let manager1 = ITPathManager(columns: 3, arrWords: ["This", "is", "a", "matrix", "of", "two", "dimensional", "array"])
    let expectedPath1 = [0, 3, 6, 7]

    
    let manager2 = ITPathManager(columns: 6, arrWords: ["This", "is", "a", "matrix", "of", "two", "dimensional", "array"])
    let expectedPath2 = [0, 1, 2, 7]

    
    override func setUp() {
        super.setUp()
        manager.start()
        manager1.start()
        manager2.start()
    }
    
    func testShortestPathForTwoColumns() {
        XCTAssertTrue((expectedPath == self.manager.shortestPathIndices!), "Result is incorrect")
    }
    
    func testShortestPathForThreeColumns() {
        XCTAssertTrue((expectedPath1 == self.manager1.shortestPathIndices!), "Result is incorrect")
    }
    
    func testShortestPathForSixColumns() {
        XCTAssertTrue((expectedPath2 == self.manager2.shortestPathIndices!), "Result is incorrect")
    }
}
