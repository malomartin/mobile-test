//
//  WebServices.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

final class NetworkService {
    
    typealias CompletionHandler = (Result<[Resource], Error>) -> Void
    
    private let session: URLSession = URLSession(configuration: .ephemeral)
    
    // MARK: - Thread safety properties.
    
    // Dedicated `DispatchQueue`
    private let queue = DispatchQueue(label: "ServiceQueue")
    
    // Enqueued `CompletionHandler`.
    private var pendingHandlers = [CompletionHandler]()
    
    /// Retrieves the categories from the remote location.
    ///
    /// - Parameter completionHandler: Closure called at the end of the process. `Result` will contain an `Error` if the process was a failure.
    ///                                It will contain an array of `Category` if the retrieval was successful.
    func getCategories(completionHandler: @escaping CompletionHandler) throws {
        
        let url = Configuration.servicseBaseUrl.appendingPathComponent("categories")
        let request = URLRequest(url: url)
        
        pendingHandlers.append(completionHandler)
        
        // pendingHandler.count > 1 means that the resource is already being fetched.
        guard pendingHandlers.count == 1 else { return }
        
        queue.async { [weak self] in
            self?.session.dataTask(with: request) { (dataOrNil, responseOrNil, errorOrNil) in
                
                // Something went wrong. Early exit.
                if let error = errorOrNil {
                    self?.handleResult(.failure(error))
                    return
                }
                
                guard let data = dataOrNil else {
                    self?.handleResult(.failure(NetworkServiceError.dataWasExpected))
                    return
                }
                
                guard let response = responseOrNil as? HTTPURLResponse else {
                    self?.handleResult(.failure(NetworkServiceError.httpUrlResponseWasExpected))
                    return
                }
                
                guard 200 ..< 400 ~= response.statusCode else {
                    
                    switch response.statusCode {
                    case 400 ..< 500:
                        self?.handleResult(.failure(ServiceError.callFailed(httpStatus: response.statusCode)))
                    
                    case 500 ..< 600:
                        self?.handleResult(.failure(ServiceError.serverFailed(httpStatus: response.statusCode)))
                    default:
                        self?.handleResult(.failure(ServiceError.other(httpStatus: response.statusCode)))
                    }
                    return
                }
                
                // Parse data into resource object.
                let result = Result { try JSONDecoder().decode([Category].self, from: data) }
                self?.handleResult(result.map { $0 as [Resource] })
            }
        }
    }

    private func handleResult(_ result: Result<[Resource], Error>) {
        
        let backupHandlers = pendingHandlers
        pendingHandlers.removeAll()
        
        backupHandlers.forEach({ $0(result) })
    }
}

// MARK: - NetworkService Error
   
enum NetworkServiceError: Error {
    
    case dataWasExpected
    case httpUrlResponseWasExpected
}
