//
//  GradientBackground.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/18/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import UIKit

extension CALayer {
    public func configureGradientBackground(_ colors:CGColor...) {
        let gradient = CAGradientLayer()
        let maxWidth = max(bounds.size.height,bounds.size.width)
        let squareFrame = CGRect(origin: bounds.origin, size: CGSize(width: maxWidth, height: maxWidth))
        gradient.frame = squareFrame
        gradient.colors = colors
        insertSublayer(gradient, at: 0)
    }
}
