//
//  GiphyExplorerTests.swift
//  GiphyExplorerTests
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import XCTest
@testable import GiphyExplorer

class GiphyExplorerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGiphyResponseInitialiser() {
        guard let filePath = Bundle.main.url(forResource: "GiphyResponse", withExtension: ".json"),
            let testdata = try? Data.init(contentsOf: filePath) else {
                XCTFail("Test response file not found!")
                return
        }
        
        let decoder = JSONDecoder.init()
        do {
            let response = try decoder.decode(GiphyResponse.self, from: testdata)
            XCTAssert(response.data.count == 20, "Failed to parse response data")
            XCTAssert(response.pagination.count == 20, "Failed to get pagination info")
            XCTAssert(response.meta.status == 200, "Request status is invalid")
        } catch {
            XCTFail("Failed to parse response: \(error.localizedDescription)")
        }
    }
    
}
