//
//  MusicSection.swift
//  YoutubeMusicApp
//
//  Created by Do Kiyong on 2023/08/17.
//

import UIKit
import SnapKit
import Then

enum MusicSection {
    
    struct Concept {
        let image: UIImage
        let title: String
        let desc: String
    }
    
    struct Music {
        let image: UIImage
        let title: String
        let desc: String
    }
    
    case concept([Concept])
    case music([Music])
}
