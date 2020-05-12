//
//  CategoriesTests.swift
//  Mobile TestTests
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit
import OHHTTPStubs
import XCTest

@testable import Mobile_Test

class CategoriesTests: XCTestCase {

    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetCategories() throws {
        let sendsResult = expectation(description: "getCategories - Success")
        
        stub(condition: isScheme("https") && isHost("mobile-test.getsandbox.com") && isPath("/categories"), response: { _ in
            let mockDataString = """
                   [{
                       "_id": "59839fd7951cf747207bed3e",
                       "updated_at": "2017-08-03T22:12:39.544Z",
                       "slug": "restaurants",
                       "custom_module_eid": "aad16857-166d-43d4-8f16-d097902838cf",
                       "eid": "ac5bd194-11de-48f6-94db-fd16cfccb570",
                       "title": "Restaurants",
                       "description": "Find local restaurants",
                       "__v": 0,
                       "_active": true,
                       "created_at": "2017-08-03T22:12:39.537Z"
                   }, {
                       "_id": "5983a2b7951cf747207bed41",
                       "updated_at": "2017-08-03T22:24:55.668Z",
                       "slug": "vacation-spots",
                       "custom_module_eid": "aad16857-166d-43d4-8f16-d097902838cf",
                       "eid": "83a5bc0d-bae7-4b3f-b8d9-01c969785783",
                       "title": "Vacation Spots",
                       "__v": 0,
                       "_active": true,
                       "created_at": "2017-08-03T22:24:55.662Z"
                   }]
                   """
            guard let mockedData = mockDataString.data(using: .utf8) else {
                XCTAssert(false, "Could not convert strings to data.")
                return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
            }
            
            return HTTPStubsResponse(data: mockedData, statusCode: 200, headers: nil)
        })
        
        var resultOrNil: Result<[Mobile_Test.Category], Error>? = nil
        let categoryService = CategoryServices()
        categoryService.getCategories { result in
            resultOrNil = result
            sendsResult.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        
        guard let result = resultOrNil else {
            XCTAssert(false, "Result must not be nil")
            return
        }
        
        let categories = try result.get()
        XCTAssertEqual(categories.count, 2)
    }
}
