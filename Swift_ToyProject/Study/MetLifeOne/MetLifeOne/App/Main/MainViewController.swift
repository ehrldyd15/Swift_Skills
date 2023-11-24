//
//  MainViewController.swift
//  MetLifeOne
//
//  Created by Do Kiyong on 11/24/23.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate {
    func moveSubView()
}

class MainViewController: UIViewController {
    
    var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello main view controller")
        
        view.backgroundColor = .yellow
    }
    
}
