//
//  ViewController.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 22/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GCDAsyncSocketDelegate, NetServiceDelegate {
    
    @IBOutlet var tv : UITextView?
    var asyncSocket : GCDAsyncSocket?
    var connectedSockets = [GCDAsyncSocket]()
    var netService : NetService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logTextView = self.tv
        
        guard let asyncSocket = self.asyncSocket else {
            return
        }
        
        do {
            try asyncSocket.accept(onPort: UInt16(SERV_PORT))
            netService = NetService(domain: SERV_DOMAIN, type: SERV_TYPE, name: "", port: SERV_PORT)
            print("port: \(SERV_PORT)")
            netService?.delegate = self
            netService?.publish()
            
            netService?.setTXTRecord(NetService.data(fromTXTRecord: ["hi" : "bye".data(using: .utf8)!]))
            printLog("try publish service") // 1
        } catch _ {
            printLog("can listen port")
        }
            
    }
      // disapper ＝ 消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for socket in connectedSockets {
            socket.disconnect()
        }
        connectedSockets.removeAll()
        asyncSocket?.disconnect()
        
        netService?.stop()
        netService?.delegate = nil
    }

    //MARK:-- CocoaAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        connectedSockets.append(newSocket)
        newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
        printLog("connected")
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let index = connectedSockets.firstIndex(of: sock) {
            connectedSockets.remove(at: index)
        }
        // if close this server page , it will show this string
        printLog("disconnected")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let str = String(data: data, encoding: .utf8) {
            // received string from client server
            printLog("received: \(str)")
            sock.write(data, withTimeout: -1, tag: -1)
            sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
    
    //MARK:-- NetServiceDelegate
    func netServiceDidPublish(_ sender: NetService) {
        printLog("netservice published") //2
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        printLog("netservice not publish")
    }

}

