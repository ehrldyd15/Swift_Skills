//
//  AppCoordinator.swift
//  MetLifeOne
//
//  Created by Do Kiyong on 11/24/23.
//

import Foundation
import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator, SplashCoordinatorDelegate, MainCoordinatorDelegate {

    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showSplashViewController()
    }
    
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    private func showSplashViewController() {
        let coordinator = SplashCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    private func showSubViewController() {
        let coordinator = SubCoordinator(navigationController: self.navigationController)
        
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func moveMain(_ coordinator: SplashCoordinator) {
        // AppCoordinator가 가지고있는 childeCoordinators에서 LoginCoordinator를 지워줘야하기 때문
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
    
    func moveSubView(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showSubViewController()
    }
    
}

