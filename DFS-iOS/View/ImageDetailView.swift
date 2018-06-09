//
//  ImageDetailView.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class ImageDetailView: UIView {
    
    func slideInFromLeft(duration: TimeInterval = 0.4, completionDelegate: AnyObject? = nil) {
        let slideInFromLeftTransition = CATransition()
        
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideInFromRight(duration: TimeInterval = 0.4, completionDelegate: AnyObject? = nil) {
        let slideInFromRightTransition = CATransition()
        
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeRemoved
        
        self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
    
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
        slideInTransition.fillMode = kCAFillModeRemoved
        
        self.layer.add(slideInTransition, forKey: "slideInTransition")
    }
}
