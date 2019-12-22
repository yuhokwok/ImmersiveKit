//
//  ImmersiveNetworkAgencyProvider.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 22/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation

public protocol ImmersiveNetworkAgentProvider {
    /// To return a network core upon request
    var networkAgentShouldAutoRun : Bool { get }
    func networkAgentForTracking() -> ImmersiveNetworkCore?
}

public protocol ImmersiveWorldProvider {
    /// To provide an immersive world for VR with full body tracking
    func worldToImmersive() -> ImmersiveWorld?
}
