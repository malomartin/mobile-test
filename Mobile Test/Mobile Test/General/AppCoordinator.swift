//
//  AppCoordinator.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-18.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // We start the execution by starting the category coordinator.
        let categoryCoordinator = CategoryCoordinator(navigationController: navigationController)
        childCoordinators.append(categoryCoordinator)
        categoryCoordinator.start()
    }
    
    func end() {
        // Do nothing.
    }
}
