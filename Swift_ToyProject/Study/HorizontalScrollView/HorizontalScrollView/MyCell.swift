//
//  MyCell.swift
//  HorizontalScrollView
//
//  Created by Do Kiyong on 2023/08/10.
//

import UIKit

// 셀의 CGSize 크기는 collectionView를 사용하는쪽에서 정해질 것을 인지하고 cell에서는 autolayout 작성 시 크기를 생각하지 않고 레이아웃만 집중
final class MyCell: UICollectionViewCell {
    
    static let id = "MyCell"
    
    // MARK: UI
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
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
        
        self.contentView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(image: nil)
    }
    
    func prepare(image: UIImage?) {
        self.imageView.image = image
    }
    
}
