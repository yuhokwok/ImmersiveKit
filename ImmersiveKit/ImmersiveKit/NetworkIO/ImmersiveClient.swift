//
//  ImmersiveClient.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 11/12/2019.
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
        ImmersiveCore.print(msg: "client started discovering server")
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
    
    public override func write(data: Data) {
        guard connected else {
            isWritingData = false
            return
        }
        super.write(data : data)
    }
}

//MARK: - GCDAsyncSocketDelegate
extension ImmersiveClient {
    override public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        ImmersiveCore.print(msg: "socket did connect to host \(host) : \(port)")
        connected = true
        super.socket(sock, didConnectToHost: host, port: port)
    }
    
    override public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if !connected {
            self.connectToNextAddress()
        }
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        //ImmersiveCore.print(msg: "did read data")
        super.socket(sock, didRead: data, withTag: tag)
//        if let str = String(data: data, encoding: .utf8) {
//            ImmersiveCore.print(msg: "echo: \(str.quickTrim())")
//        }
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        ImmersiveCore.print(msg: "did write data")
        super.socket(sock, didWriteDataWithTag: tag)
    }
    
    private func connectToNextAddress(){
        if serverAddresses == nil || serverAddresses?.count == 0 {
            ImmersiveCore.print(msg: "no server address")
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
                ImmersiveCore.print(msg: "cannot connect")
            }
        }

        if (!done){
            ImmersiveCore.print(msg: "unable to connect any resolved address")
        }
    }
}

//MARK: - NetServiceDelegate
extension ImmersiveClient {
    override public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        ImmersiveCore.print(msg: "did not resolve")
    }

    override public func netServiceDidResolveAddress(_ sender: NetService) {
        ImmersiveCore.print(msg: "did resolve \(String(describing: sender.addresses))")
        if serverAddresses == nil {
            ImmersiveCore.print(msg: "got addresses")
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
        ImmersiveCore.print(msg: "will search for service")
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        ImmersiveCore.print(msg: "did stop search for service")
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        ImmersiveCore.print(msg: "did find service \(service.name)")
        if netService == nil {
            ImmersiveCore.print(msg: "resolving...")
            netService = service
            netService?.delegate = self
            netService?.resolve(withTimeout: 5.0)
        }
    }
    
    override public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        ImmersiveCore.print(msg: "did remove service \(service.name)")
    }
    
    override public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        ImmersiveCore.print(msg: "did stop search for service")
    }
}
