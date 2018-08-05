//
//  GalleryCollectionView.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class GalleryCollectionView: UICollectionView {
    func rotateAnimation() {
        let rotation = CATransition()
        
        rotation.type = kCATransitionMoveIn
        
            rotation.subtype = kCATransitionMoveIn
        
        rotation.duration = 0.3
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotation.fillMode = kCAFillModeRemoved
        
        
        self.layer.add(rotation, forKey: "rotation") 
    }
}
