//
//  ViewModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

protocol ViewModel {}

/// Used to configure `UITableViewCell` and `UICollectionViewCell`.
protocol ReusableCellViewModel: ViewModel {
    var  reuseIdentifier: String { get }
}

// MARK: - ViewModelConfigurable


/// Indicates that a `UIView` or a subclass of `UIView` can be configured using a `ViewModel`
protocol ViewModelConfigurable {
    
    /// Configures the object using the given `ViewModel`.
    /// - Parameter viewModel: The `ViewModel` to use for the configuration.
    func configure(with viewModel: ViewModel)
}

