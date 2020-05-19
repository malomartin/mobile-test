//
//  RestaurantModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant: Resource, Describable, Locatable, Media, Joinable, Picturable {
    
    /// Type of the restaurant.
    let restaurantType: String
    
    /// Unused. Parsed anyways.
    let categoryEID: UUID
    
    /// Open hours.
    let businessHours: BusinessHours?
    
    // MARK: Resource
    
    let id: String
    let eid: UUID
    let lastUpdatedDate: Date?
    let creationDate: Date?
    let isActive: Bool
    
    // MARK: Describable
    
    /// Human readable ttle of the category. i.e. "Title".
    let title: String
    
    /// Human readable description of the category.
    let description: String?

    // MARK: Locatable
    
    /// Information regarding the address of the restaurant.
    let addresses: [Address]?
    
    // MARK: Media
    /// Infos about all social media plateform.
    let socialMedia: SocialMedia?
    
    // MARK: Joinable
    
    /// Contact information.
    let contactInfo: ContactInfo
    
    // MARK: Picturable
    
    /// Link to the photo on Amazon.
    let photoUrl: URL?
    
    private var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case restaurantType = "slug"
        case photoUrl = "photo"
        case isActive = "_active"
        case categoryEID = "category_eid"
        case endPointId = "eid"
        case lastUpdatedDate = "updated_at"
        case creationDate = "created_at"
        case addresses
        case contactInfo
        case socialMedia
        case businessHours = "bizHours"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.restaurantType = try values.decode(String.self, forKey: .restaurantType)
        let photoString = try values.decodeIfPresent(String.self, forKey: .photoUrl) ?? ""
        self.photoUrl = URL(string: photoString)
        self.addresses = try values.decodeIfPresent([Address].self, forKey: .addresses)
        self.contactInfo = try values.decode(ContactInfo.self, forKey: .contactInfo)
        self.categoryEID = try values.decode(UUID.self, forKey: .categoryEID)
        self.eid = try values.decode(UUID.self, forKey: .endPointId)
        self.isActive = try values.decode(Bool.self, forKey: .isActive)
        self.socialMedia = try values.decodeIfPresent(SocialMedia.self, forKey: .socialMedia)
        
        // Perticular management of date parsing.
        let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdatedDate)
        lastUpdatedDate = dateFormatter.date(from: lastUpdatedString)
        
        let creationDateString = try values.decode(String.self, forKey: .creationDate)
        creationDate = dateFormatter.date(from: creationDateString)
        
        self.businessHours = try values.decodeIfPresent(BusinessHours.self, forKey: .businessHours)
    }
}

// MARK: - Address

struct Address: Decodable {
    let address1: String
    let label: String
    let zipCode: String
    let city: String
    let state: String
    let country: String
    let coordinates: CLLocationCoordinate2D?
    
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
        let gpsValuesOrNil = try? values.nestedContainer(keyedBy: GPSCodingKey.self, forKey: .gps)
        
        self.address1 = try values.decode(String.self, forKey: .address1)
        self.label = try values.decode(String.self, forKey: .label)
        self.zipCode = try values.decode(String.self, forKey: .zipCode)
        self.city = try values.decode(String.self, forKey: .city)
        self.state = try values.decode(String.self, forKey: .state)
        self.country = try values.decode(String.self, forKey: .country)
        
        // Convert gps coordinate to core location coordinate.
        if let gpsValues = gpsValuesOrNil {
            let latitude = try gpsValues.decode(String.self, forKey: .latitude)
            let longitude = try gpsValues.decode(String.self, forKey: .longitude)
            
            guard let lat = Double(latitude), let long = Double(longitude) else { throw NetworkServiceError.decoding }
            self.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        } else {
            self.coordinates = nil
        }
    }
}

// MARK: - ContactInfo

struct ContactInfo: Decodable {
    let websites: [URL]?
    let emails: [String]?
    let phones: [String]?
    let tollFree: [String]?
    let faxes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case websites = "website"
        case emails = "email"
        case phones = "phoneNumber"
        case tollFree
        case faxes = "faxNumber"
    }
    
    /// We need to implement the Decodable constructor in order to void all empty strings
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.websites = try values.decodeIfPresent([URL].self, forKey: .websites)
        
        if let emails = try values.decodeIfPresent([String].self, forKey: .emails) {
            self.emails = emails.filter({ !$0.isEmpty })
        } else {
            self.emails = nil
        }
        
        if let phones = try values.decodeIfPresent([String].self, forKey: .phones) {
            self.phones = phones.filter({ !$0.isEmpty })
        } else {
            self.phones = nil
        }
        
        if let tollFree = try values.decodeIfPresent([String].self, forKey: .tollFree) {
            self.tollFree = tollFree.filter({ !$0.isEmpty })
        } else {
            self.tollFree = nil
        }
        
        if let faxes = try values.decodeIfPresent([String].self, forKey: .faxes) {
            self.faxes = faxes.filter({ !$0.isEmpty })
        } else {
            self.faxes = nil
        }
    }
}

