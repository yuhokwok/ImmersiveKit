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
class ClientViewController: UIViewController, ImmersiveKitDebugging {
    func bodyDidUpdate(bodyAnchor: ARBodyAnchor) {
        
    }
    
    
    
    
    var immersiveClient : ImmersiveClient?
    var immersiveBodyTracker : ImmersiveBodyTracker?
    
    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!
    
    
    // ar kit - body tracking code //
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var messageLabel: MessageLabel!
    
    // A tracked raycast which is used to place the character accurately
    // in the scene wherever the user taps.
    //var placementRaycast: ARTrackedRaycast?
    //var tapPlacementAnchor: AnchorEntity?    

    // ar kit - body tracking code //
    @IBAction func sendData(_ sender: Any) {
        self.sendData()
    }
    
    func sendData() {
        guard let msg = self.messageTextField.text else { return }
        self.immersiveClient?.write(str: msg)
    }
    

    @IBAction func screenTapped(_ sender: Any) {
        self.messageTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.immersiveClient = ImmersiveClient(type: SERV_TYPE, domain: SERV_DOMAIN)
        self.immersiveClient?.debugDelegate = self
        self.immersiveClient?.canWriteWithDropFrame = true
        self.immersiveBodyTracker = ImmersiveBodyTracker(arView: self.arView, delegate: self.immersiveClient)
        //self.immersiveBodyTracker?.delegate = self.immersiveClient
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        
        logTextView = self.tv
        
        
        try? self.immersiveClient?.start()
        
        self.immersiveBodyTracker?.run()
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        
        #if !targetEnvironment(simulator)
        cancellable = Entity.loadBodyTrackedAsync(named: "robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.immersiveBodyTracker?.body = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        #endif
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.immersiveBodyTracker?.stop()
        self.immersiveClient?.stop()
        super.viewDidAppear(animated)
    }

    
}


//MARK: -- Immersive Network Debug
extension ClientViewController {
    func report(msg : String) {
        printLog(msg)
    }
    

    
    func trackerDidUpdate(str: String) {
        self.tv?.text = "\(str)"
        //messageLabel.text = "leftHandJoint.columns3.x = \(str))"
        //print("leftHandJoint.columns3.x = \(str)")
        //messageTextField.text = "leftHandJoint.columns3.x = \(str))"
        printLog(str)
        self.sendData()
    }
}
