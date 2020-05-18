//
//  VacationSpotTests.swift
//  Mobile TestTests
//
//  Created by Martin Malo on 2020-05-13.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Mobile_Test

class VacationSpotTests: XCTestCase {
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    private var dateFormatter: ISO8601DateFormatter = {
           let formatter = ISO8601DateFormatter()
           formatter.timeZone = .current
           formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
           return formatter
       }()
    
    func testGetVacationSpots() throws {
        let sendsResult = expectation(description: "getVacationSpots - Success")
        
        stub(condition: isScheme("https") && isHost("mobile-test.getsandbox.com") && isPath("/vacation-spots"), response: { _ in
            let mockDataString = """
                                 [{
                                     "_id": "5983a696951cf747207bed42",
                                     "slug": "places-to-read",
                                     "eid": "91716028-4fbd-45d4-905f-92df23cacdef",
                                     "photo": "https://s3.amazonaws.com/qsapi-files/files/49851e71-5114-4d94-9d9a-7f3cacb1764e/0f625c2f-7e01-4dd9-b569-f96c1c7b35f6.jpeg",
                                     "title": "Places to Read",
                                     "description": "<p>When you want to get away and read a good eGuide</p>",
                                     "category_eid": "83a5bc0d-bae7-4b3f-b8d9-01c969785783",
                                     "__v": 0,
                                     "_active": true,
                                     "updated_at": "2017-08-03T22:41:26.558Z",
                                     "created_at": "2017-08-03T22:41:26.546Z",
                                     "socialMedia": {
                                       "youtubeChannel": [
                                         ""
                                       ],
                                       "twitter": [
                                         ""
                                       ],
                                       "facebook": [
                                         ""
                                       ]
                                     },
                                     "addresses": [
                                       {}
                                     ],
                                     "freeText": [
                                       {}
                                     ],
                                     "contactInfo": {
                                       "website": [
                                         "http://www.quickseries.com"
                                       ],
                                       "email": [
                                         ""
                                       ],
                                       "faxNumber": [
                                         ""
                                       ],
                                       "tollFree": [
                                         ""
                                       ],
                                       "phoneNumber": [
                                         ""
                                       ]
                                     }
                                   }]
                                 """
            guard let mockedData = mockDataString.data(using: .utf8) else {
                XCTAssert(false, "Could not convert strings to data.")
                return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
            }
            
            return HTTPStubsResponse(data: mockedData, statusCode: 200, headers: nil)
        })
        
        var resultOrNil: Result<[Mobile_Test.VacationSpot], Error>? = nil
        let vacationSpotService = VacationSpotService()
        vacationSpotService.getVacationSpots { result in
            resultOrNil = result
            sendsResult.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        
        guard let result = resultOrNil else {
            XCTAssertNotNil(resultOrNil)
            return
        }
        
        let vacationSpots = try result.get()
        XCTAssertEqual(vacationSpots.count, 1)
        
        let firstVacationSpotOrNil = vacationSpots.first
        
        guard let firstVacationSpot = firstVacationSpotOrNil else {
            XCTAssertNotNil(firstVacationSpotOrNil)
            return
        }
        
        XCTAssertEqual(firstVacationSpot.id, "5983a696951cf747207bed42")
        let creationDate = dateFormatter.date(from: "2017-08-03T22:41:26.546Z")
        XCTAssertNotNil(firstVacationSpot.creationDate)
        XCTAssertEqual(firstVacationSpot.creationDate, creationDate)
        XCTAssertEqual(firstVacationSpot.categoryEID, UUID(uuidString: "83a5bc0d-bae7-4b3f-b8d9-01c969785783"))
        XCTAssertEqual(firstVacationSpot.eid, UUID(uuidString: "91716028-4fbd-45d4-905f-92df23cacdef"))
        XCTAssertEqual(firstVacationSpot.title, "Places to Read")
        XCTAssertNotNil(firstVacationSpot.description)
        XCTAssertEqual(firstVacationSpot.description, "<p>When you want to get away and read a good eGuide</p>")
        XCTAssertEqual(firstVacationSpot.vacationSpotType, "places-to-read")
        XCTAssertEqual(firstVacationSpot.photoUrl, URL(string: "https://s3.amazonaws.com/qsapi-files/files/49851e71-5114-4d94-9d9a-7f3cacb1764e/0f625c2f-7e01-4dd9-b569-f96c1c7b35f6.jpeg"))
        XCTAssertNotNil(firstVacationSpot.socialMedia)
        XCTAssertEqual(firstVacationSpot.socialMedia?.facebookUrls?.count, 0)
        XCTAssertEqual(firstVacationSpot.socialMedia?.twitterUrls?.count, 0)
        XCTAssertEqual(firstVacationSpot.socialMedia?.youtubeUrls?.count, 0)
        
        XCTAssertEqual(firstVacationSpot.contactInfo.websites?.first, URL(string: "http://www.quickseries.com"))
        XCTAssertEqual(firstVacationSpot.contactInfo.emails?.count, 0)
        XCTAssertEqual(firstVacationSpot.contactInfo.faxes?.count, 0)
        XCTAssertEqual(firstVacationSpot.contactInfo.tollFree?.count, 0)
        XCTAssertEqual(firstVacationSpot.contactInfo.phones?.count, 0)
    }
}

