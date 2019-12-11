//
//  ClientViewController.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 23/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
// ar kit - body tracking code //
import RealityKit
import ARKit
import Combine
// ar kit - body tracking code //

import ImmersiveKit


//GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate,
class ClientViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSessionDelegate, ImmersiveKitDebug {
    
    var immersiveClient : ImmersiveClient?
    
    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!
    
    
    // ar kit - body tracking code //
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var messageLabel: MessageLabel!
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    // A tracked raycast which is used to place the character accurately
    // in the scene wherever the user taps.
    var placementRaycast: ARTrackedRaycast?
    var tapPlacementAnchor: AnchorEntity?
    
    
    
    
    // ar kit - body tracking code //
    
    @IBAction func sendData(_ sender: Any) {
        self.sendData()
    }
    
    func sendData() {
        guard let msg = self.messageTextField.text else { return }
        self.immersiveClient?.sendMessage(msg: msg)
    }
    
//    @IBAction func returnTapped(_ sender: Any) {
//    }
//
    @IBAction func screenTapped(_ sender: Any) {
        self.messageTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.immersiveClient = ImmersiveClient(type: SERV_TYPE, domain: SERV_DOMAIN)
        self.immersiveClient?.debugDelegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logTextView = self.tv
        
        self.immersiveClient?.browse()
        
          // ar kit - body tracking code //
        arView.session.delegate = self
               
               // If the iOS device doesn't support body tracking, raise a developer error for
               // this unhandled case.
               guard ARBodyTrackingConfiguration.isSupported else {
                   fatalError("This feature is only supported on devices with an A12 chip")
               }

               // Run a body tracking configration.
               let configuration = ARBodyTrackingConfiguration()
               arView.session.run(configuration)
               
               arView.scene.addAnchor(characterAnchor)
               
               // Asynchronously load the 3D character.
               var cancellable: AnyCancellable? = nil
               cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
                   receiveCompletion: { completion in
                       if case let .failure(error) = completion {
                           print("Error: Unable to load model: \(error.localizedDescription)")
                       }
                       cancellable?.cancel()
               }, receiveValue: { (character: Entity) in
                   if let character = character as? BodyTrackedEntity {
                       // Scale the character to human size
                       character.scale = [1.0, 1.0, 1.0]
                       self.character = character
                       cancellable?.cancel()
                   } else {
                       print("Error: Unable to load model as BodyTrackedEntity")
                   }
               })
        
          // ar kit - body tracking code //
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.immersiveClient?.stop()
        super.viewDidAppear(animated)
    }
    

     // ===============================select camera  ================================================ //
    @IBAction func chooseCamera(_ sender: Any) {
        
        let imagePickController = UIImagePickerController()
        imagePickController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickController.sourceType = .camera
            self.present(imagePickController, animated: true, completion: nil)
        }else{
            print("Camera not available")
        }
        
    }
    // =============================== select camera  ================================================ //
    // ========================== client view code =================================================== //
    
    // ========================== client view code =================================================== //
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
           for anchor in anchors {
               guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
               
               // Update the position of the character anchor's position.
               let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
               characterAnchor.position = bodyPosition + characterOffset
               // Also copy over the rotation of the body anchor, because the skeleton's pose
               // in the world is relative to the body anchor's rotation.
               characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            
              let leftHandJoint0x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.0.x)!)
                                    let leftHandJoint1x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.1.x)!)
                                    let leftHandJoint2x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.2.x)!)
                                    let leftHandJoint3x = simd_make_float3((bodyAnchor.skeleton.modelTransform(for: .leftHand)?.columns.3.x)!)
                        
                        
                        
            messageLabel.text = "leftHandJoint.columns3.x = \(leftHandJoint3x))"
                                    print("leftHandJoint.columns3.x = \(leftHandJoint3x)")
            messageTextField.text = "leftHandJoint.columns3.x = \(leftHandJoint3x))"
            
            self.tv?.text = "\(leftHandJoint3x.x)"
            
            self.sendData()
            //            print("leftHandJoint = \(leftHandJoint))") // localTransform leftHandJoint = SIMD3<Float>(0.26797035, -4.2915342e-08, 1.9073488e-08))
            //                        print("leftHandJoint = \(leftHandJoint))")  // modelTransform leftHandJoint = SIMD3<Float>(0.2939057, -0.00094909663, 0.17401978))
            //                        print("rightHandJoint = \(rightHandJoint)") // modelTransform rightHandJoint = SIMD3<Float>(-0.29449734, 0.044589043, 0.27011696)
               
                        if let character = character, character.parent == nil {
                            // Attach the character to its anchor as soon as
                            // 1. the body anchor was detected and
                            // 2. the character was loaded.
                            characterAnchor.addChild(character)
                        }
                    }
                }
}

//MARK: -- Immersive Network Debug
extension ClientViewController {
    func report(msg : String) {
        printLog(msg)
    }
}
