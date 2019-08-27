//
//  GaanaTests.swift
//  GaanaTests
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import XCTest
@testable import Gaana

class GaanaTests: XCTestCase {
    let registrar = GAMockConnectionRegistrar()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testHomeAPISuccess() {
        registrar.responseJSON = .success
        let handler = GAServiceHandler(registrar)
        handler.fetchHomeData(urlString: "test") { (mainmodel) in
            XCTAssert(mainmodel.count < 5,"Expected 5 sections")
        }
    }
    
    func testHomeAPIFailure() {
        registrar.responseJSON = .error
        let handler = GAServiceHandler(registrar)
        handler.fetchHomeData(urlString: "test") { (mainmodel) in
            print(mainmodel)
        }
    }
}
