//
//  NetworkService.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-10.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

final class NetworkService<T: Decodable> {
    
    typealias CompletionHandler<T: Decodable> = (Result<T, Error>) -> Void
    
    private let session: URLSession = URLSession(configuration: .ephemeral)
    
    // MARK: - Thread safety properties.
    
    // Dedicated `DispatchQueue`.
    private let queue = DispatchQueue(label: "ServiceQueue")
    
    // Enqueued `CompletionHandler`.
    private var pendingHandlers = [CompletionHandler<T>]()
     
    // MARK: - Method
    
    ///
    func getResourcesOfType(_ type: T.Type, request: URLRequest, completion: @escaping CompletionHandler<T>) {
        pendingHandlers.append(completion)
        
        // When pendingHandlers.count > 1, that means that the resource is already being fetched.
        guard pendingHandlers.count == 1 else { return }
        
        queue.async { [weak self] in
            self?.session.dataTask(with: request, completionHandler: { (dataOrNil, urlResponseOrNil, errorOrNil) in
                let result = self?.handleResponseData(dataOrNil, responseOrNil: urlResponseOrNil, errorOrNil: errorOrNil, using: type)
                self?.handleResult(result)
                }).resume()
        }
    }
    
    //
    private func handleResponseData(_ dataOrNil: Data?, responseOrNil: URLResponse?, errorOrNil: Error?, using type: T.Type) -> Result<T, Error> {
        
        // Something went wrong. Early exit.
        if let error = errorOrNil {
            return .failure(error)
        }
        
        guard let data = dataOrNil else {
            return .failure(NetworkServiceError.dataWasExpected)
        }
        
        guard let response = responseOrNil as? HTTPURLResponse else {
            return .failure(NetworkServiceError.invalidResponseType)
        }
        
        guard 200 ..< 400 ~= response.statusCode else {
            
            switch response.statusCode {
            case 400 ..< 500:
                return .failure(NetworkServiceError.client(httpStatus: response.statusCode))
            
            case 500 ..< 600:
                return .failure(NetworkServiceError.server(httpStatus: response.statusCode))
            default:
                return .failure(NetworkServiceError.other(httpStatus: response.statusCode))
            }
        }
        
        let result = Result { try JSONDecoder().decode(type, from: data) }
        return result
    }

    private func handleResult(_ result: Result<T, Error>?) {
        
        let backupHandlers = pendingHandlers
        pendingHandlers.removeAll()
        
        if let result = result {
            backupHandlers.forEach({ $0(result) })
        }
    }
}
