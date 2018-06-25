//
//  ImageDetailView.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class ImageDetailView: UIView {
    
    func slideInImage(fromDirection: String, duration: CFTimeInterval, completionDelegate: AnyObject? = nil) {
        let slideInTransition = CATransition()
        
        slideInTransition.type = kCATransitionPush
        if fromDirection == "right" {
            slideInTransition.subtype = kCATransitionFromRight
        } else if fromDirection == "left" {
            slideInTransition.subtype = kCATransitionFromLeft
        }
        slideInTransition.duration = duration
        slideInTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        slideInTransition.fillMode = kCAFillModeForwards
        
        
        self.layer.add(slideInTransition, forKey: "slideInTransition")
        
        
    }
}
