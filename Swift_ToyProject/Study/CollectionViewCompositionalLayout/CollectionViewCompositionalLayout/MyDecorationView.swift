//
//  MyDecorationView.swift
//  CollectionViewCompositionalLayout
//
//  Created by Do Kiyong on 2023/08/16.
//

import UIKit

class MyDecorationView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(1)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
}

