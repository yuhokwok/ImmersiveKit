//
//  ClientViewController.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 23/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit
import ImmersiveKit


//GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate,
class CamSettingClientViewController: UIViewController, ImmersiveKitDebugging {
    

    var immersiveClient : ImmersiveClient?
    
//    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet var fovTextField : UITextField!
    @IBOutlet var pupillaryTextField : UITextField!
    @IBOutlet var fovSlider : UISlider!
    @IBOutlet var pupillarySlider : UISlider!
    
    @IBAction func sliderValueChangedFOV(){
        self.fovTextField.text = "\(fovSlider.value)"
    }
    
    @IBAction func sliderValueChangedPupillary(){
        self.pupillaryTextField.text = "\(pupillarySlider.value)"
    }
    
    @IBAction func sliderTouchUpInside(){
        self.sendData(self.pupillaryTextField)
    }
    
    // ar kit - body tracking code //
    @IBOutlet weak var messageLabel: MessageLabel!
    
    // A tracked raycast which is used to place the character accurately
    // in the scene wherever the user taps.
    //var placementRaycast: ARTrackedRaycast?
    //var tapPlacementAnchor: AnchorEntity?

    // ar kit - body tracking code //
    @IBAction func sendData(_ sender: Any) {
        
        let fov : CGFloat  = CGFloat(Double(fovTextField.text!)!)
        let pupillary : CGFloat  = CGFloat(Double(pupillaryTextField.text!)!)
        let setting = VRCameraSetting(pupillary: pupillary, fieldOfView: fov)
        self.sendData(setting: setting)
    }
    
    func sendData(setting : VRCameraSetting) {
        guard let data = setting.jsonfiy() else { return }
        self.immersiveClient?.write(data: data)
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
        //self.immersiveBodyTracker?.delegate = self.immersiveClient
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        navigationController?.isNavigationBarHidden = false
//        logTextView = self.tv
        
        
        try? self.immersiveClient?.start()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.immersiveClient?.stop()
        super.viewDidAppear(animated)
    }

    
}


//MARK: -- Immersive Network Debug
extension CamSettingClientViewController {
    func report(msg : String) {
        printLog(msg)
    }
}

