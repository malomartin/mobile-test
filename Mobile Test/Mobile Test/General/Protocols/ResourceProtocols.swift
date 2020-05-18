//
//  ResourceProtocols.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-16.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// Conform to this protocol if the object is a resource fetched from the internet.
protocol Resource: Decodable {
    var id: String { get }
    var lastUpdatedDate: Date? { get }
    var creationDate: Date? { get }
    var eid: UUID { get }
    var isActive: Bool { get }
}

// MARK: - Describable

/// Conform to this protocol whether the object needs a title and a description.
protocol Describable: Decodable {
    var title: String { get }
    var description: String? { get }
}

// MARK: - Locatable

/// Addresses associated to an object.
protocol Locatable: Decodable {
    var addresses: [Address]? { get }
}

// MARK: - Joinable

/// Information about phone, fax, etc.
protocol Joinable: Decodable {
    var contactInfo: ContactInfo { get }
}

// MARK: - Business

/// Properties a business must implement.
protocol Business {
    var businessHours: BusinessHours? { get }
}

// MARK: - Media

protocol Media {
    var socialMedia: SocialMedia? { get }
}

// MARK: - Picturable

protocol Picturable {
    var photoUrl: URL? { get }
}
