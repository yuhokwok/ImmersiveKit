//
//  ImmersiveBody.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation


/// Protocol for any immersive body receiver
public protocol ImmersiveBodyReceiverDelegate {
    func bodyReceived(body : ImmersiveBody)
}

/// Serializable Data Structure for Client/Service Data Interchange
public struct ImmersiveBody : Codable {
    
}
