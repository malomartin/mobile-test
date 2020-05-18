//
//  VacationSpotService.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

final class VacationSpotService {
    
    private let networkService = NetworkService<[VacationSpot]>()
    
    /// Retrieves the restaurants from the remote location.
    ///
    /// - Parameter completionHandler: Closure called at the end of the process. `Result` will contain an `Error` if the process was a failure.
    ///                                It will contain an array of `Category` if the retrieval was successful.
    func getVacationSpots(completionHandler: @escaping (Result<[VacationSpot], Error>) -> Void) {
        let url = Configuration.servicseBaseUrl.appendingPathComponent("vacation-spots")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        networkService.getResourcesOfType([VacationSpot].self, request: request) { result in
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
