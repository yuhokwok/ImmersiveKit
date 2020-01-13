//
//  World.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//
import SceneKit


/// Data model for storing the VR World
public final class ImmersiveWorld {
    
    private enum Constant {
//        enum Arena {
//            static let size: (x: Int, y: Int) = (20, 20)
//            static let position = SCNVector3(0.0, 0.0, -5.0)
//        }
//
        enum Gaze {
            static let seconds: TimeInterval = 2.0
        }
    }
    
    public weak var view: ImmersiveVRViewType! {
        didSet {
            self.setupCamera()
        }
    }
    
    public let scene: SCNScene
    
    public let player: ImmersiveSCNPlayerNode
//    public let arena: ArenaNode
    
    private var gazeTimer: ImmersiveGazeTimer?
    
    public init?(named: String) {
        guard let scene = SCNScene(named: "art.scnassets/CourtScene.scn") else {
            return nil
        }
        self.scene = scene
        player = ImmersiveSCNPlayerNode(
            startingPosition: simd_float3(0, 0, 10),
            camera: ImmersiveSCNVRCameraNode())
        scene.rootNode.addChildNode(player)
    }
    
    public init(scene: SCNScene) {
        self.scene = scene
//
//        EnvironmentBuilder().populate(scene)
//        EnvironmentLightingBuilder().addLighting(to: scene)
//
//        arena = ArenaNode(xCount: Constant.Arena.size.x, yCount: Constant.Arena.size.y)
//        arena.position = Constant.Arena.position
//        scene.rootNode.addChildNode(arena)
        
        player = ImmersiveSCNPlayerNode(
            startingPosition: simd_float3(0, 0, 10),
            camera: ImmersiveSCNVRCameraNode())
        scene.rootNode.addChildNode(player)
        
//        gazeTimer = GazeTimer(timeInterval: Constant.Gaze.seconds)
//        gazeTimer.delegate = self
    }
    
    public func setupCamera() {
        view.setPointOfView(to: player.cameraNode)
    }
    
    public func movePlayer(by offset: simd_float3) {
        player.move(by: offset)
    }
    
    public func updatePlayer(with motion: ImmersiveMotionData) {
        player.updatePosition(with: motion)
    }
    
    public func playerGazes(at node: SCNNode?) {
//        arena.select(node: node as? ArenaFieldNode)
        //gazeTimer.update(withNodeGazedAt: node)
    }
}

extension ImmersiveWorld: ImmersiveGazeTimerDelegate {
    
    public func gazeTimerDidFire(withNode node: SCNNode) {
//        if let node = node as? ArenaFieldNode, let nodeArenaPosition = arena.positionFor(node) {
//            player.move(to: arena.simdConvertPosition(nodeArenaPosition, to: scene.rootNode), animated: true)
//        }
    }
}
