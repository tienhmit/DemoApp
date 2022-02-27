//
//  WeatherRepositoryTest.swift
//  DemoAppTests
//
//  Created by Hoang Manh Tien on 2/28/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import XCTest
@testable import DemoApp

class WeatherRepositoryTest: XCTestCase {
    
    var baseFetcher: BaseFetcher!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
        super.setUp()
        baseFetcher = BaseFetcher()
    }
    
    override func tearDown() {
        super.tearDown()
        baseFetcher = nil
    }
    
    func testGetWeatherOfLocation() {
        guard let baseFetcher = baseFetcher else {
            XCTAssertTrue(false)
            return
        }
        
        let lat = 21.0245 // of Ha Noi, Viet nam
        let long = 105.841171 // of Ha Noi, Viet Nam
        let promise = expectation(description: "Completion handler invoked")
        let requestCondition = WeatherRequestConditionsType.currentlocation("\(lat)", "\(long)")
        baseFetcher.fetchRequest(requestConditions: requestCondition,
                                 complete: { json in
                                    promise.fulfill()
                                    XCTAssertTrue(true)
        },
                                 failure: { (err: Error) in
                                    promise.fulfill()
                                    XCTFail("Error: \(err.localizedDescription)")
        })
        wait(for: [promise], timeout: 30.0)
    }
    
    func testGetForecastWeatherOfLocation () throws {
        let lat = 21.0245 // of Ha Noi, Viet nam
        let long = 105.841171 // of Ha Noi, Viet Nam
        let promise = expectation(description: "Completion handler invoked")
        let requestCondition = WeatherRequestConditionsType.anyLocation("\(lat)", "\(long)")
        baseFetcher.fetchRequest(requestConditions: requestCondition,
                                 complete: { json in
                                    promise.fulfill()
                                    XCTAssertTrue(true)
        },
                                 failure: { (err: Error) in
                                    promise.fulfill()
                                    XCTFail("Error: \(err.localizedDescription)")
        })
        
        wait(for: [promise], timeout: 30.0)
    }
    
}
