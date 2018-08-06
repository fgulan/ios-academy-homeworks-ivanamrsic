//
//  UIView+Shake.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

extension UIView {

    func shake(count: Float = 4, for duration: TimeInterval = 0.3, withTranslation translation : Float = 5, fieldOffset: Float = 50) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation + fieldOffset), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation + fieldOffset), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}
