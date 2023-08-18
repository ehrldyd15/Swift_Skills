//
//  MyCollectionViewCell.swift
//  CarouselScrollView
//
//  Created by Do Kiyong on 2023/08/18.
//

import Foundation
import UIKit

final class MyCollectionViewCell: UICollectionViewCell {
    
    static let id = "MyCollectionViewCell"
    
    // MARK: UI
    private let myView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.myView)
        
        NSLayoutConstraint.activate([
            self.myView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.myView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.myView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.myView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(color: nil)
        
    }
    
    func prepare(color: UIColor?) {
        self.myView.backgroundColor = color
    }
    
}
