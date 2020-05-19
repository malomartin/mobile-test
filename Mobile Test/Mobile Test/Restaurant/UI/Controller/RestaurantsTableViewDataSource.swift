//
//  RestaurantsTableViewDataSource.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class RestaurantDetailTableViewDataSource: NSObject, UITableViewDataSource {
    
    var sectionViewModels = [SectionViewModel]()

    private func makeSectionViewModels(from restaurants: [Restaurant]) {
        
        for restaurant in restaurants {
            var rows = [ReusableCellViewModel]()

            // Contact information
            if !restaurant.contactInfo.isEmpty {
                
                if let phones = restaurant.contactInfo.phones, !phones.isEmpty {
                    rows.append(contentsOf: phones.map({ ContactInfoTableViewCellViewModel(title: "PHONE NUMBER" , info: $0) }))
                }
                
                if let tollFreeNumbers = restaurant.contactInfo.tollFree, !tollFreeNumbers.isEmpty {
                    rows.append(contentsOf: tollFreeNumbers.map({ ContactInfoTableViewCellViewModel(title: "TOLL-FREE NUMBER" , info: $0) }))
                }
            }
            
            if let faxes = restaurant.contactInfo.faxes, !faxes.isEmpty {
                rows.append(contentsOf: faxes.map({ ContactInfoTableViewCellViewModel(title: "FAX NUMBER" , info: $0) }))
            }
            
            if let emails = restaurant.contactInfo.emails, !emails.isEmpty {
                rows.append(contentsOf: emails.map({ ContactInfoTableViewCellViewModel(title: "EMAIL ADDRESS" , info: $0) }))
            }
            
            if let websites = restaurant.contactInfo.websites, !websites.isEmpty {
                rows.append(contentsOf: websites.map({ ContactInfoTableViewCellViewModel(title: "WEBSITE" , info: $0.absoluteString) }))
            }
            
            // Addresses
            if let adresses = restaurant.addresses, !adresses.isEmpty {
                
            }
            
            let sectionViewModel = SectionViewModel(title: restaurant.title, rows: rows)
            sectionViewModels.append(sectionViewModel)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionViewModels[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = sectionViewModels[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
        return cell
    }
}
