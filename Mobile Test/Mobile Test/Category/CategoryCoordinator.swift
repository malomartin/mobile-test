//
//  CategoryCoordinator.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class CategoryCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoryViewController = CategoryViewController.instanciate()
        navigationController.pushViewController(categoryViewController, animated: true)
    }
    
    func end() {
        
    }
}
