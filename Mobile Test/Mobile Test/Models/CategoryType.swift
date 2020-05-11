//
//  CategoryType.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// Represents a category that can be selected.
enum CategoryType: String, Decodable {
    case restaurants = "restaurants"
    case vacationSpots = "vacation-spots"
}
