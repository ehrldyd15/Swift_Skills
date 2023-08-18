//
//  FooterView.swift
//  YoutubeMusicApp
//
//  Created by Do Kiyong on 2023/08/17.
//

import UIKit
import SnapKit
import Then

final class FooterView: UICollectionReusableView {
    
    private let lineView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        self.addSubview(self.lineView)
        
        self.lineView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
            $0.height.equalTo(1).priority(999)
        }
        
    }
    
}
