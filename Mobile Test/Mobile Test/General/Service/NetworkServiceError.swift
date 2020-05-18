//
//  NetworkServiceError.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

/// Error that might be raised when using a web service.
enum NetworkServiceError: Error {
    
    /// 400 to 499.
    case client(httpStatus: Int)
    
    /// 500 to 599.
    case server(httpStatus: Int)

    /// Other http status <> 200.
    case other(httpStatus: Int)
    
    /// No data given when expecting some.
    case dataWasExpected
    
    /// Decoding error.
    case decoding
    
    /// Should never hapen. In case, and `URLResponse` could not be cast to `HTTPURLResponse`.
    case invalidResponseType
}

// MARK: - Service Error - User Message.

extension NetworkServiceError {
    
    /// A `String` representing a human readable error message.
    var userMessage: String {
        
        var status: Int
        
        switch self {
        case .client(let httpStatusCode):
            status = httpStatusCode
        case .server(let serverHttpStatusCode):
            status = serverHttpStatusCode
            
        case .other(let code):
            status = code
            
        case .dataWasExpected:
            status = -9000
            
        case .decoding:
            status = -9001
            
        case .invalidResponseType:
            status = -9002
        }
        
        return "An error occured. Please try again later. (\(status))"
    }
}
