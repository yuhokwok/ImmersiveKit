//
//  CGFloat+Random.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static func random(lowerLimit: CGFloat, upperLimit: CGFloat) -> CGFloat {
        return lowerLimit + (upperLimit - lowerLimit) * (CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

