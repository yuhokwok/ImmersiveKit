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


let SERV_TYPE = "_immersivetracker._tcp."
let SERV_DOMAIN  = "local."
let SERV_PORT : Int32 = 55699
class ClientViewController: UIViewController, GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSessionDelegate {
    
    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!
    
    var connected = false
    var serverAddresses : [Data]?
    var asyncSocket : GCDAsyncSocket?
    var serverService : NetService?
    var netServiceBrowser : NetServiceBrowser?
    
    
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
        if let data = msg.data(using: .utf8) {
            self.asyncSocket?.write(data, withTimeout: -1, tag: -1)
            self.asyncSocket?.write(GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
            self.asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
            printLog("send - \(msg)")
            
            
            
            
        }
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
        //self.asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logTextView = self.tv
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self
        //netServiceBrowser?.searchForServices(ofType: "_thevrar._tcp.", inDomain: "local.")
        printLog("try browse for service")
        netServiceBrowser?.searchForServices(ofType: SERV_TYPE, inDomain: SERV_DOMAIN)
        
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
        super.viewDidAppear(animated)
        asyncSocket?.disconnect()
        serverService?.stop()
        serverService?.delegate = nil
        netServiceBrowser?.delegate = nil
        netServiceBrowser?.stop()
    }
    
    //MARK:-- NetServiceBrowserDelegate
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        printLog("will search for service")
    }

    
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        printLog("did not search \(errorDict)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        printLog("did find service \(service.name)")
        if serverService == nil {
            printLog("resolving...")
            serverService = service
            serverService?.delegate = self
            serverService?.resolve(withTimeout: 5.0)
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        printLog("did remove service \(service.name)")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        printLog("did stop search for service")
    }
    


    //MARK:-- CocoaAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        printLog("socket did connect to host \(host) : \(port)")
        connected = true
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        printLog("disconnected")
        if !connected {
            self.connectToNextAddress()
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let str = String(data: data, encoding: .utf8) {
            printLog("echo: \(str)")
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
    
    //MARK:-- NetServiceDelegate
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        printLog("did not resolve")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        printLog("did resolve \(String(describing: sender.addresses))")
        if serverAddresses == nil {
            printLog("got addresses")
            serverAddresses = sender.addresses
        }
        
        if(asyncSocket == nil){
            asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        }
        
        self.connectToNextAddress()
    }
    
    func connectToNextAddress(){
        if serverAddresses == nil || serverAddresses?.count == 0 {
            printLog("no server address")
            return
        }
        var done = false
        while(!done && serverAddresses!.count > 0){
            var addr : Data
            addr = serverAddresses!.removeFirst()
            
            do {
                try asyncSocket?.connect(toAddress: addr)
                done = true
            } catch _ {
                printLog("cannot connect")
            }
        }

        if (!done){
            printLog("unable to connect any resolved address")
        }
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
