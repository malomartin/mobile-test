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
    let lastUpdatedDate: Date
    
    /// Type of the category.
    let categoryType: CategoryType
    
    /// Not used.
    let moduleEID: UUID
    
    /// Not used.
    let endPointId: UUID
    
    /// Human readable ttle of the category. i.e. "Title".
    let title: String
    
    /// Human readable description of the category.
    let description: String
    
    /// Not used.
    let isActive: Bool
    
    /// Not used.
    let creationDate: Date
    
    // MARK: Decodable
    
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
