//
//  ImmersiveCore.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation


public protocol ImmersiveKitDebug {
    func report(msg : String)
}

public struct ImmersiveCore {
    public static var version = 1.0
}
