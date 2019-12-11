//
//  ImmersiveClient.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//


import Foundation
//import CocoaAsyncSocket

/// Class for receiving data from Immersive Server
public class ImmersiveClient : ImmersiveNetworkCore  {
    
    //Data Field
    private var serverAddresses : [Data]?
    private var netServiceBrowser : NetServiceBrowser?
    private var connected = false
    
    private var serviceType : String
    private var serviceDomain : String
 
    public var isConnected : Bool {
        return connected
    }
    
    
    public init(type : String, domain : String, runQueue: DispatchQueue? = nil) {
        self.serviceType = type
        self.serviceDomain = domain
        self.netServiceBrowser = NetServiceBrowser()
        super.init(runQueue: runQueue)
    }
    
    public override func start() throws {
        self.netServiceBrowser?.delegate = self
        self.netServiceBrowser?.searchForServices(ofType: serviceType, inDomain: serviceDomain)
    }
    
    public override func stop() {
        asyncSocket?.disconnect()
        netService?.stop()
        netService?.delegate = nil
        netServiceBrowser?.stop()
        netServiceBrowser?.delegate = nil
    }
}

//MARK: - GCDAsyncSocketDelegate
extension ImmersiveClient {
    override public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        printLog("socket did connect to host \(host) : \(port)")
        connected = true
    }
    
    override public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if !connected {
            self.connectToNextAddress()
        }
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        printLog("did read data")
        if let str = String(data: data, encoding: .utf8) {
            printLog("echo: \(str)")
        }
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
    
    private func connectToNextAddress(){
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

//MARK: - NetServiceDelegate
extension ImmersiveClient {
    override public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        printLog("did not resolve")
    }

    override public func netServiceDidResolveAddress(_ sender: NetService) {
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
}

//MARK: - NetServiceBrowserDelegate
extension ImmersiveClient {
    override public func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        printLog("will search for service")
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        printLog("did stop search for service")
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        printLog("did find service \(service.name)")
        if netService == nil {
            printLog("resolving...")
            netService = service
            netService?.delegate = self
            netService?.resolve(withTimeout: 5.0)
        }
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        printLog("did remove service \(service.name)")
    }
    
    override public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        printLog("did stop search for service")
    }
}
