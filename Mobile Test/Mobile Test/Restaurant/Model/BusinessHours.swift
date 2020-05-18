//
//  BusinessHours.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-16.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

struct BusinessHours: Decodable {
    let days: [Day]
    
    enum CodingKeys: String, CodingKey {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case from
        case to
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let sunday = try values.decodeIfPresent(Sunday.self, forKey: .sunday)
        let monday = try values.decodeIfPresent(Monday.self, forKey: .monday)
        let tuesday = try values.decodeIfPresent(Tuesday.self, forKey: .tuesday)
        let wednesday = try values.decodeIfPresent(Wednesday.self, forKey: .wednesday)
        let thursday = try values.decodeIfPresent(Thursday.self, forKey: .thursday)
        let friday = try values.decodeIfPresent(Friday.self, forKey: .friday)
        let saturday = try values.decodeIfPresent(Saturday.self, forKey: .saturday)
        
        let weekWithNil: [Day?] = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
        self.days = weekWithNil.compactMap({ $0 })
    }
}

// MARK: - Day

protocol Day: Decodable {
    var name: String { get }
    var from: String { get }
    var to: String { get }
}

// MARK: - Used only for parsing.

struct Sunday: Day {
    let name = "Sunday"
    let from: String
    let to: String
}

struct Monday: Day {
    let name = "Monday"
    let from: String
    let to: String
}

struct Tuesday: Day {
    let name = "Tuesday"
    let from: String
    let to: String
}

struct Wednesday: Day {
    let name = "Wednesday"
    let from: String
    let to: String
}

struct Thursday: Day {
    let name = "Thursday"
    let from: String
    let to: String
}

struct Friday: Day {
    let name = "Friday"
    let from: String
    let to: String
}

struct Saturday: Day {
    let name = "Saturday"
    let from: String
    let to: String
}

