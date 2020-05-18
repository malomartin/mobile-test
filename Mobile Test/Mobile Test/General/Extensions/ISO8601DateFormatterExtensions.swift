//
//  ISO8601DateFormatterExtensions.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-16.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    
    static var internetDateTimeFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
