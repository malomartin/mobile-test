//
//  RestaurantModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant: Decodable {
    
    /// The unique identifier.
    let id: String
    
    /// Human readable ttle of the category. i.e. "Title".
    let title: String
    
    /// Human readable description of the category.
    let description: String?

    /// Type of the restaurant.
    let restaurantType: String
    
    /// Link to the photo on Amazon.
    let photoUrl: URL?
    
    /// Information regarding the address of the restaurant.
    let address: Address
    
    /// Contact information.
    let contactInfo: ContactInfo
    
    // Unused. Parsed anyways.
    let categoryEID: UUID
    let endPointId: UUID
    let isActive: Bool
    let lastUpdatedDate: Date?
    let creationDate: Date?
}

// MARK: - Address

struct Address: Decodable {
    let address1: String
    let label: String
    let zipCode: String
    let city: String
    let state: String
    let country: String
    let coordinates: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case address1
        case label
        case zipCode
        case city
        case state
        case country
        case gps
    }
    
    enum GPSCodingKey: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let gpsValues = try values.nestedContainer(keyedBy: GPSCodingKey.self, forKey: .gps)
        
        self.address1 = try values.decode(String.self, forKey: .address1)
        self.label = try values.decode(String.self, forKey: .label)
        self.zipCode = try values.decode(String.self, forKey: .zipCode)
        self.city = try values.decode(String.self, forKey: .city)
        self.state = try values.decode(String.self, forKey: .state)
        self.country = try values.decode(String.self, forKey: .country)
        
        // Convert gps coordinate to core location coordinate.
        let latitude = try gpsValues.decode(String.self, forKey: .latitude)
        let longitude = try gpsValues.decode(String.self, forKey: .longitude)
        
        guard let lat = Double(latitude), let long = Double(longitude) else { throw NetworkServiceError.decoding }
        self.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
    }
}

// MARK: - ContactInfo

struct ContactInfo: Decodable {
    let websites: [URL]
    let emails: [String]
    let phones: [String]
}
