//
//  SCNVector+Extension.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//


import Foundation
import CoreGraphics

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
}

extension Float {
    var degreesToRadians: Float { return self * .pi / 180 }
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
}
