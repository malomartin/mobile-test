//
//  CategoryServices.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-11.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

final class CategoryServices {
    
    private let networkService = NetworkService<[Category]>()
    
    /// Retrieves the categories from the remote location.
    ///
    /// - Parameter completionHandler: Closure called at the end of the process. `Result` will contain an `Error` if the process was a failure.
    ///                                It will contain an array of `Category` if the retrieval was successful.
    func getCategories(completionHandler: @escaping (Result<[Category], Error>) -> Void) {
        let url = Configuration.servicseBaseUrl.appendingPathComponent("categories")
        let request = URLRequest(url: url)
        networkService.getResourcesOfType([Category].self, request: request) { result in
            completionHandler(result)
        }
    }
}
