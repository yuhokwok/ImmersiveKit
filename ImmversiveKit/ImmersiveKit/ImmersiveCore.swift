//
//  ImmersiveCore.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation


/// For developer to forward console log messsage to app project
public protocol ImmersiveKitDebugging {
    
    /// Call delegate with reporting message
    /// - Parameter msg: message for console log
    func report(msg : String)
}

public struct ImmersiveCore {
    public static var version = 1.0
}
