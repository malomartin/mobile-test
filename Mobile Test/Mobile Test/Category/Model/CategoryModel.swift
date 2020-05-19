//
//  CategoryModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// A category as received from web services.
struct Category: Resource, Describable {
    
    // MARK: Resource
    
    /// The unique identifier.
    let id: String
    
    /// Last time the category has been updated.
    let lastUpdatedDate: Date?
    let creationDate: Date?
    let eid: UUID
    
    /// Not used.
    let moduleEID: UUID
        
    /// Type of the category.
    let type: CategoryType
    
    /// Unused.
    let isActive: Bool
    
    // MARK: Describable
    
    /// Human readable ttle of the category. i.e. "Title".
    let title: String
    
    /// Human readable description of the category.
    let description: String?
    
    // MARK: Decodable
    
    /// We need to implement the init since there is no automatic parsing available from `String` to `Date`.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.type = try values.decode(CategoryType.self, forKey: .categoryType)
        self.moduleEID = try values.decode(UUID.self, forKey: .moduleEID)
        self.eid = try values.decode(UUID.self, forKey: .endPointId)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.isActive = try values.decode(Bool.self, forKey: .isActive)
        
        // Perticular management of date parsing.
        let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdatedDate)
        self.lastUpdatedDate = ISO8601DateFormatter.internetDateTimeFormatter.date(from: lastUpdatedString)
        
        let creationDateString = try values.decode(String.self, forKey: .creationDate)
        self.creationDate = ISO8601DateFormatter.internetDateTimeFormatter.date(from: creationDateString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lastUpdatedDate = "updated_at"
        case categoryType = "slug"
        case moduleEID = "custom_module_eid"
        case endPointId = "eid"
        case title
        case description
        case isActive = "_active"
        case creationDate = "created_at"
    }
}


// MARK: - CategoryType

/// Represents a category that can be selected.
enum CategoryType: String, Decodable {
    case restaurants = "restaurants"
    case vacationSpots = "vacation-spots"
}

