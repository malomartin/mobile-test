//
//  VacationSpotModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

struct VacationSpot: Resource, Describable, Media, Joinable, Picturable {

    let vacationSpotType: String
    let categoryEID: UUID
    
    // MARK: Resource
    let id: String
    let eid: UUID
    let isActive: Bool
    let lastUpdatedDate: Date?
    let creationDate: Date?
    
    // MARK: Describable
    
    let title: String
    let description: String?
  
    // MARK: Media
    let socialMedia: SocialMedia?
    
    // MARK: Joinable
    
    let contactInfo: ContactInfo
    
    // MARK: Picturable
    let photoUrl: URL?
    
    private var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vacationSpotType = "slug"
        case endPointId = "eid"
        case photoUrl = "photo"
        case title
        case description
        case categoryEID = "category_eid"
        case isActive = "_active"
        case lastUpdatedDate = "updated_at"
        case creationDate = "created_at"
        case socialMedia
        case contactInfo
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let photoString = try values.decodeIfPresent(String.self, forKey: .photoUrl)
        self.photoUrl = URL(string: photoString ?? "")
        
        self.id = try values.decode(String.self, forKey: .id)
        self.categoryEID = try values.decode(UUID.self, forKey: .categoryEID)
        self.vacationSpotType = try values.decode(String.self, forKey: .vacationSpotType)
        self.eid = try values.decode(UUID.self, forKey: .endPointId)
        self.isActive = try values.decode(Bool.self, forKey: .isActive)
        
        
        let updateDateString = try values.decodeIfPresent(String.self, forKey: .lastUpdatedDate)
        self.lastUpdatedDate = dateFormatter.date(from: updateDateString ?? "")
        
        let creationDateString = try values.decodeIfPresent(String.self, forKey: .creationDate)
        self.creationDate = dateFormatter.date(from: creationDateString ?? "")
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.socialMedia = try values.decodeIfPresent(SocialMedia.self, forKey: .socialMedia)
        self.contactInfo = try values.decode(ContactInfo.self, forKey: .contactInfo)
    }
}
