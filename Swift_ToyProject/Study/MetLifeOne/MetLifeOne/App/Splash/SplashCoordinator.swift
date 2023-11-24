//
//  SplashCoordinator.swift
//  MetLifeOne
//
//  Created by Do Kiyong on 11/24/23.
//

import Foundation
import UIKit

protocol SplashCoordinatorDelegate {
    func moveMain(_ coordinator: SplashCoordinator)
}

class SplashCoordinator: Coordinator, SplashViewControllerDelegate {

    var childCoordinators: [Coordinator] = []
    var delegate: SplashCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        // 프리젠트 코드
//        let viewController = UINavigationController(rootViewController: ViewB())
//        
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true)
        
        let viewController = SplashViewController()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func moveMain() {
        self.delegate?.moveMain(self)
    }
    
}

