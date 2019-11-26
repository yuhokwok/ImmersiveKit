//
//  ClientViewController.swift
//  ClientServerEx
//
//  Created by Yu Ho Kwok on 14/11/2019.
//  Copyright © 2019 Invivo Interactive Limited. All rights reserved.
//

import UIKit

let SERV_TYPE = "_thevrarios._tcp."
let SERV_DOMAIN  = "local."
let SERV_PORT : Int32 = 55699
class ClientViewController: UIViewController, GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate {
    
    @IBOutlet var tv : UITextView?
    @IBOutlet weak var messageTextField: UITextField!
    
    var connected = false
    var serverAddresses : [Data]?
    var asyncSocket : GCDAsyncSocket?
    var serverService : NetService?
    var netServiceBrowser : NetServiceBrowser?
    
    @IBAction func returnTapped(_ sender: Any) {
        guard let msg = self.messageTextField.text else { return }
        if var data = msg.data(using: .utf8) {
            self.asyncSocket?.write(data, withTimeout: -1, tag: -1)
            self.asyncSocket?.write(GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
            self.asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
            printLog("send - \(msg)")
        }
    }
    
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
            printLog("received: \(str)")
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
    
    //MARK:-- NetServiceDelegate
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        printLog("did not resolve")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        printLog("did resolve \(sender.addresses)")
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

}
