//
//  VRCameraNode.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import SceneKit

public final class ImmersiveSCNVRCameraNode: SCNNode {
    public let leftNode = SCNNode()
    public let rightNode = SCNNode()
    
    private let leftCamera = SCNCamera()
    private let rightCamera = SCNCamera()
    
    public override init() {
        super.init()
        attachCameras()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attachCameras()
    }
    
    private func attachCameras() {
        leftNode.camera = leftCamera
        rightNode.camera = rightCamera
        
        addChildNode(leftNode)
        addChildNode(rightNode)
        
        setCameraSetting(VRCameraSetting.defaultSetting)
    }
    
    private func setupCamera(_ camera: SCNCamera) {
        camera.zNear = VRCameraSetting.defaultSetting.nearPlane
        camera.zFar = VRCameraSetting.defaultSetting.farPlane
        camera.fieldOfView = VRCameraSetting.defaultSetting.fieldOfView
    }
    
    public func setCameraSetting(_ setting : VRCameraSetting) {
        let leftEyePos = SCNVector3(-Float(setting.pupillary / 2.0), 0.0, 0.0)
        let rightEyePos = SCNVector3(Float(setting.pupillary / 2.0), 0.0, 0.0)
        
        leftNode.position = leftEyePos
        rightNode.position = rightEyePos

//        leftNode.pivot = SCNMatrix4MakeTranslation(Float(setting.pupillary / 2.0), 0.0, 0.0)
//        rightNode.pivot = SCNMatrix4MakeTranslation(-Float(setting.pupillary / 2.0), 0.0, 0.0)
        
        leftCamera.zNear = setting.nearPlane
        leftCamera.zFar = setting.farPlane
        leftCamera.fieldOfView = setting.fieldOfView
        
        rightCamera.zNear = setting.nearPlane
        rightCamera.zFar = setting.farPlane
        rightCamera.fieldOfView = setting.fieldOfView
    }
}


    
//    public enum Constant {
//        enum Setting {
//            static let defaultSetting = VRCameraSetting.defaultSetting
//        }
//        enum Camera {
//            static let nearPlane: Double = 0.1
//            static let farPlane: Double = 150.0
//            static let fieldOfView: CGFloat = 90 //90.0 //70.0 //125.0
//        }
//
//        enum Distance {
//            //70 vs 2.4
//            // 90 vs 3.8
//            //120 vs 4.5
//            static let pupillary: CGFloat = 1.2
//        }
//
//        enum Translation {
//            static let leftEye = SCNVector3(-Float(Constant.Setting.defaultSetting.pupillary / 2.0), 0.0, 0.0)
//            static let rightEye = SCNVector3(Float(Constant.Setting.defaultSetting.pupillary / 2.0), 0.0, 0.0)
//        }
//    }
