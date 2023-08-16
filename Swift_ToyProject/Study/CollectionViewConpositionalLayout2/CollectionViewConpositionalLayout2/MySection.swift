//
//  MySection.swift
//  CollectionViewConpositionalLayout2
//
//  Created by Do Kiyong on 2023/08/16.
//

import Foundation

enum MySection {
    
    struct MainItem {
        let text: String
    }
    
    struct SubItem {
        let text: String
    }
    
    case main([MainItem])
    case sub([SubItem])
    
}
