//
//  ImmersiveCore.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

public protocol ImmersiveDebugPrintDelegate {
    func debugPrint(msg : String)
}

/// For developer to forward console log messsage to app project
public protocol ImmersiveKitDebugging {
    
    /// Call delegate with reporting message
    /// - Parameter msg: message for console log
    func report(msg : String)
}


/// Core struct type for fundamental tasks
public struct ImmersiveCore {
    public static var version = 1.0
    
    public static var printer : ImmersiveDebugPrintDelegate?
    
    public static func print(msg : String) {
        printer?.debugPrint(msg: msg)
    }
}
