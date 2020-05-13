//
//  RestaurantsTests.swift
//  Mobile TestTests
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Mobile_Test

class RestaurantsTests: XCTestCase {
    
    private var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetRestaurants() throws {
        let sendsResult = expectation(description: "getRestaurants - Success")
        
        stub(condition: isScheme("https") && isHost("mobile-test.getsandbox.com") && isPath("/restaurants"), response: { _ in
            let mockDataString = """
                          [{
                            "_id": "5983a9e2951cf747207bed45",
                            "slug": "pizza-spanos",
                            "eid": "8bb64496-3e68-4b4d-902e-1ac3ec494f21",
                            "title": "Pizza Spanos",
                            "description": "<p>Powering Devs Everywhere</p>",
                            "category_eid": "ac5bd194-11de-48f6-94db-fd16cfccb570",
                            "__v": 2,
                            "photo": "https://s3.amazonaws.com/qsapi-files/files/49851e71-5114-4d94-9d9a-7f3cacb1764e/a372062a-9a75-4a94-ba1b-2e6a3df21b54.jpeg",
                            "_active": true,
                            "updated_at": "2017-08-04T14:37:01.290Z",
                            "created_at": "2017-08-03T22:55:30.469Z",
                            "addresses": [
                              {
                                "address1": "1360 Sunnybrooke",
                                "label": "Pizza Spanos",
                                "zipCode": "H9B 2W5",
                                "city": "DDO",
                                "state": "QC",
                                "country": "Canada",
                                "gps": {
                                  "latitude": "45.490834",
                                  "longitude": "-73.777091"
                                }
                              }
                            ],
                            "contactInfo": {
                              "website": [
                                "https://www.google.com"
                              ],
                              "email": [
                                "email@domain.com"
                              ],
                              "phoneNumber": [
                                "15147028287"
                              ]
                            }
                          },
                          {
                            "_id": "5983ab85951cf747207bed48",
                            "slug": "quickseries",
                            "eid": "dc0b0a4c-a9dc-4070-a56d-dca62ff4d849",
                            "title": "QuickSeries",
                            "description": "<p>QuickSeries delivers content</p>",
                            "category_eid": "ac5bd194-11de-48f6-94db-fd16cfccb570",
                            "__v": 0,
                            "photo": "https://s3.amazonaws.com/qsapi-files/files/49851e71-5114-4d94-9d9a-7f3cacb1764e/33c22133-1c17-43b8-bf71-b24692c49e5b.jpeg",
                            "_active": true,
                            "updated_at": "2017-08-04T14:39:45.585Z",
                            "created_at": "2017-08-03T23:02:29.705Z",
                            "socialMedia": {
                                "youtubeChannel": [
                                    "https://www.youtube.com/channel/UCT0hbLDa-unWsnZ6Rjzkfug"
                                ],
                                "twitter": [
                                    "https://twitter.com/quickseriespub"
                                ],
                                "facebook": [
                                    "https://www.facebook.com/pages/Quickseries-Publishing-Inc/946403368763231"
                                ]
                            },
                            "contactInfo": {
                                "website": [
                                    "http://www.quickseries.com"
                                ],
                                "email": [
                                    "justin.ledoux@quickseries.com"
                                ],
                                "faxNumber": [
                                    "8773293291"
                                ],
                            "tollFree": [
                                    "19003614653"
                            ],
                            "phoneNumber": [
                                    "9545841606"
                            ]}
                          }]
                          """
            guard let mockedData = mockDataString.data(using: .utf8) else {
                XCTAssert(false, "Could not convert strings to data.")
                return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
            }
            
            return HTTPStubsResponse(data: mockedData, statusCode: 200, headers: nil)
        })
        
        var resultOrNil: Result<[Mobile_Test.Restaurant], Error>? = nil
        let restaurantService = RestaurantService()
        restaurantService.getRestaurants { result in
            resultOrNil = result
            sendsResult.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        
        guard let result = resultOrNil else {
            XCTAssertNotNil(resultOrNil)
            return
        }
        
        let restaurants = try result.get()
        XCTAssertEqual(restaurants.count, 2)
        
        let firstRestaurantOrNil = restaurants.first
        
        guard let firstRestaurant = firstRestaurantOrNil else {
            XCTAssertNotNil(firstRestaurantOrNil)
            return
        }
        
        XCTAssertEqual(firstRestaurant.id, "5983a9e2951cf747207bed45")
        let creationDate = dateFormatter.date(from: "2017-08-03T22:55:30.469Z")
        XCTAssertNotNil(firstRestaurant.creationDate)
        XCTAssertEqual(firstRestaurant.creationDate, creationDate)
        XCTAssertEqual(firstRestaurant.restaurantType, "pizza-spanos")
        XCTAssertEqual(firstRestaurant.categoryEID, UUID(uuidString: "ac5bd194-11de-48f6-94db-fd16cfccb570"))
        XCTAssertEqual(firstRestaurant.endPointId, UUID(uuidString: "8bb64496-3e68-4b4d-902e-1ac3ec494f21"))
        XCTAssertEqual(firstRestaurant.title, "Pizza Spanos")
        XCTAssertNotNil(firstRestaurant.description)
        XCTAssertEqual(firstRestaurant.description, "<p>Powering Devs Everywhere</p>")
        XCTAssertTrue(firstRestaurant.isActive)
        let updatedDate = dateFormatter.date(from: "2017-08-04T14:37:01.290Z")
        XCTAssertNotNil(firstRestaurant.lastUpdatedDate)
        XCTAssertEqual(firstRestaurant.lastUpdatedDate, updatedDate)
        XCTAssertNil(firstRestaurant.socialMedia)
        
        let secondRestaurantOrNil = restaurants.last
        guard let secondRestaurant = secondRestaurantOrNil else {
            XCTAssertNotNil(secondRestaurantOrNil)
            return
        }
        
        XCTAssertEqual(secondRestaurant.id, "5983ab85951cf747207bed48")
        let creationDate2 = dateFormatter.date(from: "2017-08-03T23:02:29.705Z")
        XCTAssertNotNil(secondRestaurant.creationDate)
        XCTAssertEqual(secondRestaurant.creationDate, creationDate2)
        XCTAssertEqual(secondRestaurant.restaurantType, "quickseries")
        XCTAssertEqual(secondRestaurant.categoryEID, UUID(uuidString: "ac5bd194-11de-48f6-94db-fd16cfccb570"))
        XCTAssertEqual(secondRestaurant.endPointId, UUID(uuidString: "dc0b0a4c-a9dc-4070-a56d-dca62ff4d849"))
        XCTAssertEqual(secondRestaurant.title, "QuickSeries")
        XCTAssertNotNil(secondRestaurant.description)
        XCTAssertEqual(secondRestaurant.description, "<p>QuickSeries delivers content</p>")
        XCTAssertTrue(secondRestaurant.isActive)
        let updatedDate2 = dateFormatter.date(from: "2017-08-04T14:39:45.585Z")
        XCTAssertNotNil(secondRestaurant.lastUpdatedDate)
        XCTAssertEqual(secondRestaurant.lastUpdatedDate, updatedDate2)
        
        XCTAssertNotNil(secondRestaurant.socialMedia)
        XCTAssertEqual(secondRestaurant.socialMedia?.facebookUrls?.count, 1)
        XCTAssertEqual(secondRestaurant.socialMedia?.facebookUrls?.first, URL(string: "https://www.facebook.com/pages/Quickseries-Publishing-Inc/946403368763231"))
        XCTAssertEqual(secondRestaurant.socialMedia?.twitterUrls?.count, 1)
        XCTAssertEqual(secondRestaurant.socialMedia?.twitterUrls?.first, URL(string: "https://twitter.com/quickseriespub"))
        XCTAssertEqual(secondRestaurant.socialMedia?.twitterUrls?.first, URL(string: "https://twitter.com/quickseriespub"))
        XCTAssertEqual(secondRestaurant.socialMedia?.youtubeUrls?.count, 1)
        XCTAssertEqual(secondRestaurant.socialMedia?.youtubeUrls?.first, URL(string: "https://www.youtube.com/channel/UCT0hbLDa-unWsnZ6Rjzkfug"))
        
        XCTAssertNotNil(secondRestaurant.contactInfo.emails)
        XCTAssertNotNil(secondRestaurant.contactInfo.faxes)
        XCTAssertNotNil(secondRestaurant.contactInfo.phones)
        XCTAssertNotNil(secondRestaurant.contactInfo.websites)
        XCTAssertNotNil(secondRestaurant.contactInfo.tollFree)
        XCTAssertEqual(secondRestaurant.contactInfo.emails?.count, 1)
        XCTAssertEqual(secondRestaurant.contactInfo.emails?.first, "justin.ledoux@quickseries.com")
        XCTAssertEqual(secondRestaurant.contactInfo.websites?.count, 1)
        XCTAssertEqual(secondRestaurant.contactInfo.websites?.first!, URL(string: "http://www.quickseries.com")!)
        XCTAssertEqual(secondRestaurant.contactInfo.faxes?.count, 1)
        XCTAssertEqual(secondRestaurant.contactInfo.faxes?.first, "8773293291")
        XCTAssertEqual(secondRestaurant.contactInfo.phones?.count, 1)
        XCTAssertEqual(secondRestaurant.contactInfo.phones?.first, "9545841606")
        XCTAssertEqual(secondRestaurant.contactInfo.tollFree?.count, 1)
        XCTAssertEqual(secondRestaurant.contactInfo.tollFree?.first, "19003614653")
    }
    
    func testGeRestaurants_whenReceivingHttp500() throws {
        let xpectation = expectation(description: "getRestaurants - failure - 500")
        stub(condition: isScheme("https") && isHost("mobile-test.getsandbox.com") && isPath("/restaurants"), response: { _ in
            return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
        })
        
        var resultOrNil: Result<[Mobile_Test.Restaurant], Error>? = nil
        let restaurantService = RestaurantService()
        restaurantService.getRestaurants { result in
            resultOrNil = result
            xpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        
        guard let result = resultOrNil else {
            XCTAssertNotNil(resultOrNil)
            return
        }
        
        switch result {
        case .success(_):
            XCTAssert(false, "An error should have been raised")
            
        case .failure(let error as NetworkServiceError):
            
            switch error {
            case .server(let status):
                XCTAssertEqual(status, 500)
                
            default:
                XCTAssert(false, "The error raised should be a client error.")
            }
            
        case .failure(_):
            XCTAssert(false, "Error received should be of type NetworkServiceError.client")
        }
    }
}
