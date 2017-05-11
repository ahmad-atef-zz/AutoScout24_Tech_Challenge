//
//  AutoScout24IntegrationTests.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/11/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import XCTest

@testable import AutoScout24_Tech_Challenge

class AutoScout24IntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testLoadCarsFromCloudFails() {
        // given
        let expectation = self.expectation(description: "Expected load Cars from cloud to fail")
        
        // when
        DBIntercotr.shared.simulateFailInLoadingCar { (result) in
            expectation.fulfill()
            XCTAssertFalse(result)
        }
        // then
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testGivenMockCloudNetworkServiceLoadCarsFromCloudSucceeds() {
        
        // given
        let expecation = expectation(description: "Expected load Cars from cloud to succeed")
        
        
        // when
        DBIntercotr.shared.simulateSuccessInLoadingCar { (result) in
            expecation.fulfill()
            XCTAssertTrue(result)
        }
        // then
        waitForExpectations(timeout: 3, handler: nil)
        
    }
}
