//
//  ImmersiveView.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 21/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import SceneKit


public protocol ImmersiveViewDelegate{
    func renderer(_ renderer : SCNSceneRenderer, updateAtTime time: TimeInterval)
}

/// A UIView for attached the two SCNView
public class ImmersiveView: UIView, SCNSceneRendererDelegate, ImmersiveVRViewType {
    
    public var delegate : ImmersiveViewDelegate?
    
    @IBOutlet public var leftScnView : SCNView!
    @IBOutlet public var rightScnView : SCNView!
    
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    public override init(frame: CGRect) {
//        self.leftScnView = SCNView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        self.rightScnView = SCNView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        super.init(frame: frame)
//    }
    
    /// Attach this view to the parent view
    /// - Parameter parent: the parent UIView
    public func attach(to parent : UIView) {
        parent.addSubview(self)
    }
    
    public func show(world: ImmersiveWorld) {
        guard let leftScnView = self.leftScnView, let rightScnView = self.rightScnView else {
            return
        }
        world.view = self
        setup(scnView: leftScnView, world : world)
        setup(scnView: rightScnView, world : world)
        world.setupCamera()
    }
    
    public func setup(scnView : SCNView, world : ImmersiveWorld){
        scnView.scene = world.scene
        scnView.preferredFramesPerSecond = 120
        scnView.antialiasingMode = .multisampling4X
        if scnView == self.leftScnView {
            scnView.delegate = self
        }
    }
}

extension ImmersiveView {
    public func setPointOfView(to node: ImmersiveSCNVRCameraNode) {
        leftScnView.pointOfView = node.leftNode
        rightScnView.pointOfView = node.rightNode
    }
}

extension ImmersiveView  {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.delegate?.renderer(renderer, updateAtTime: time)
    }
}
