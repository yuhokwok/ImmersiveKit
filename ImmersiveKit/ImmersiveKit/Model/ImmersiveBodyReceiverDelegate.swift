//
//  ImmersiveBodyReceiverDelegate.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 13/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

/// Protocol for any immersive body receiver
public protocol ImmersiveBodyReceiverDelegate {
    func bodyReceived(body : Body)
}
