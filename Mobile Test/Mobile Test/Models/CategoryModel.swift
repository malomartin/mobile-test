//
//  CategoryModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// A category as received from web services.
struct Category: Decodable {
    
    /// The unique identifier.
    let id: String
    
    /// Last time the category has been updated.
    let lastUpdatedDate: Date?
    
    /// Type of the category.
    let categoryType: CategoryType
    
    /// Not used.
    let moduleEID: UUID
    
    /// Not used.
    let endPointId: UUID
    
    /// Human readable ttle of the category. i.e. "Title".
    let title: String
    
    /// Human readable description of the category.
    let description: String?
    
    /// Not used.
    let isActive: Bool
    
    /// Not used.
    let creationDate: Date?
    
    // MARK: Decodable
    
    /// We need to implement the init since there is no automatic parsing available from `String` to `Date`.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.categoryType = try values.decode(CategoryType.self, forKey: .categoryType)
        self.moduleEID = try values.decode(UUID.self, forKey: .moduleEID)
        self.endPointId = try values.decode(UUID.self, forKey: .endPointId)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.isActive = try values.decode(Bool.self, forKey: .isActive)
        
        // Perticular management of date parsing.
        let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdatedDate)
        lastUpdatedDate = ISO8601DateFormatter().date(from: lastUpdatedString)
        
        let creationDateString = try values.decode(String.self, forKey: .creationDate)
        creationDate = ISO8601DateFormatter().date(from: creationDateString)
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

// MARK: - Resource

extension Category: Resource {}
