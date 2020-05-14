//
//  ClientViewController.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 23/11/2019.
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
 class TrackerViewController: ImmersiveBodyTrackerNetworkViewController{
    
    
   

    
    
    
    
    
    
     
    
    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!

    //MARK: - ImmersiveNetworkAgentProvider
    override var networkAgentShouldAutoRun: Bool {
        return true
    }
    
    public override func networkAgentForTracking() -> ImmersiveNetworkCore? {
        //it can be a client or a server now!
        //return ImmersiveClient(type: SERV_TYPE, domain: SERV_DOMAIN)
        return ImmersiveServer(type: SERV_TYPE, domain: SERV_DOMAIN, port: SERV_PORT)
    }
    
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
        self.networkAgent?.write(str: msg)
    }
    

    @IBAction func screenTapped(_ sender: Any) {
        self.messageTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //specifically ignore writing request when it is writing some data
        self.networkAgent?.canWriteWithDropFrame = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true

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
                self.bodyTracker?.body = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        #endif
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        super.viewWillDisappear(animated)
    }

    
    //MARK: -- Immersive Network Debug
    public override func report(msg : String) {
        printLog(msg)
    }
}
