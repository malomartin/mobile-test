//
//  ServiceError.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// Error that might be raised when using a web service.
enum ServiceError: Error {
    
    /// 400 to 499.
    case callFailed(httpStatus: Int)
    
    /// 500 to 599.
    case serverFailed(httpStatus: Int)
    
    ///
    case other(httpStatus: Int)
}

// MARK: - Service Error - User Message.

extension ServiceError {
    
    /// A `String` representing a human readable error message.
    var userMessage: String {
        
        var status: Int
        
        switch self {
        case .callFailed(let httpStatusCode):
            status = httpStatusCode
        case .serverFailed(let serverHttpStatusCode):
            status = serverHttpStatusCode
            
        case .other(let code):
            status = code 
        }
        
        return "An error occured. Please try again later. (\(status))"
    }
}
