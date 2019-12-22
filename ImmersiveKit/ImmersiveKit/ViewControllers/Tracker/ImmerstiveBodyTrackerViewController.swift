//
//  ImmersiveBodyTrackerViewController.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 12/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

open class ImmersiveBodyTrackerViewController: UIViewController, ImmersiveBodyTrackerDelegate {

    @IBOutlet public var arView : ARView?
    public var bodyTracker : ImmersiveBodyTracker?
    
    
    //MARK: - Live Cycle Functions
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard let arView = self.arView else {
            ImmersiveCore.print(msg: "No AR View, please make one. otherwise, no full body tracking")
            return
        }
        
        self.bodyTracker = ImmersiveBodyTracker(arView: arView, delegate: self)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bodyTracker?.run()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        self.bodyTracker?.stop()
        super.viewWillDisappear(animated)
    }
    
    //MARK: - ImmersiveBodyTrackerDelegate
    open func bodyDidUpdate(bodyAnchor: ARBodyAnchor) {
        
    }
    
}
