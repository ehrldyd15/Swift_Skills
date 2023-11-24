//
//  SubCoordinator.swift
//  MetLifeOne
//
//  Created by Do Kiyong on 11/24/23.
//

import Foundation
import UIKit

class SubCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SubViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
