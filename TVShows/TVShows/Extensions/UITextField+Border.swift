//
//  UITextField+Border.swift
//  TVShows
//
//  Created by Ivana Mrsic on 19/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 0.0
    }
}
