//
//  TitleTableViewCell.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class TitleTableViewCell: UITableViewCell, ViewModelConfigurable {

    static let reuseIdentifier = "TitleTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? TitleTableViewCellViewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

// MARK: - ViewModel

struct TitleTableViewCellViewModel: ReusableCellViewModel {
    let reuseIdentifier = TitleTableViewCell.reuseIdentifier
    let title: String
    let description: String?
    
    init(restaurant: Restaurant) {
        self.title = restaurant.title
        self.description = restaurant.description
    }
}
