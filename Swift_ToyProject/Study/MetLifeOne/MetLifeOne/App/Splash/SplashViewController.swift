//
//  SplashViewController.swift
//  MetLifeOne
//
//  Created by Do Kiyong on 11/24/23.
//

import UIKit
import SnapKit

protocol SplashViewControllerDelegate {
    func moveMain()
}

class SplashViewController: UIViewController {
    
    var delegate: SplashViewControllerDelegate?
    
    let myBtn = UIButton()
    let myLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello splash view controller")
        
        self.view.backgroundColor = .systemBackground
        self.setViews()

    }
    
    func setViews() {
        self.setViewStyle()
        
        [myBtn, myLabel].forEach({ view.addSubview($0) })
        
        self.myBtn.snp.makeConstraints({
            $0.height.width.equalTo(100)
            $0.trailing.bottom.equalToSuperview().inset(30)
        })
        
        self.myLabel.snp.makeConstraints({
            $0.centerX.centerY.equalToSuperview()
        })
        
    }
    
    func setViewStyle() {
        self.myLabel.font = .systemFont(ofSize: 30.0, weight: .bold)
        
        self.myBtn.backgroundColor = .systemBlue
        self.myBtn.layer.cornerRadius = 10
        
        self.myBtn.addTarget(self, action: #selector(myBtnTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func myBtnTapped(_ sender: UIButton) {
//        self.delegate?.moveMain()
        
        let viewController = MainViewController()
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
