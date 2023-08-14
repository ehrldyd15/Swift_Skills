//
//  MyCell.swift
//  CollectionViewCompositionalLayout
//
//  Created by Do Kiyong on 2023/08/11.
//

import UIKit

final class MyCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor(
            red: CGFloat(drand48()),
            green: CGFloat(drand48()),
            blue: CGFloat(drand48()),
            alpha: 1.0
        )
        
        self.contentView.addSubview(self.label)
        
        NSLayoutConstraint.activate([
            self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(text: "")
        
    }
    
    func prepare(text: String) {
        self.label.text = text
    }
    
}
