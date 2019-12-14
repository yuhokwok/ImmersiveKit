//
//  ImmserviceNetworkCore.swift
//  ImmersiveKit
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
//import CocoaAsyncSocket
import ARKit



/// Foundation Class for ImmersiveClient & ImmersiveServver
public class ImmersiveNetworkCore : NSObject, GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate, ImmersiveBodyTrackerDelegate {
    
    public var receiverDelegate : ImmersiveBodyReceiverDelegate?
    public var debugDelegate : ImmersiveKitDebugging?
    
    /// A socket for connection to server / client
    public var asyncSocket : GCDAsyncSocket?
    
    /// NetService Object for bonjour connection
    public var netService : NetService?
    
    public init(runQueue: DispatchQueue?){
        super.init()
        let queue = runQueue ?? DispatchQueue.main
        self.asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }

    
    /// Transmit the detected ARBodyAnchor to receiver
    /// - Parameter body: ARBbodyAnchor detected by ARKit
    public func transmit(bodyAnchor : ARBodyAnchor) {
        
    }
    
    
    public func transmit(body : Body) {
        guard let jsonData = body.jsonfiy() else {
            return
        }
        self.write(data: jsonData)
    }
    
    public func start() throws {
        
    }
    
    public func stop() {
        
    }
    
    public func write(str : String) {
        if let data = str.data(using: .utf8) {
            write(data: data)
        }
        //printLog("send - \(msg)")
    }
    
    public func write(data : Data) {
        self.asyncSocket?.write(data, withTimeout: -1, tag: -1)
        self.asyncSocket?.write(GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
        self.asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
    }
    
    internal func printLog(_ msg : String) {
        debugDelegate?.report(msg: msg)
    }
    
    //TODO: delete it
    //var transformCount = 0
}

extension ImmersiveNetworkCore {
    public func bodyDidUpdate(bodyAnchor: ARBodyAnchor) {
        
        //if transformCount == 0 {
            let body = Body(bodyAnchor: bodyAnchor)
            guard let bodyJSONData = body.jsonfiy() else {
                
                return
            }
            
            if let msg = bodyJSONData.stringifyFromJSONData() {
                //ImmersiveCore.print(msg: "\(msg)")
            }
            
            self.transmit(body : body)
            //transformCount = 1
        //}
        
    }
}

//MARK: - GCDAsyncSocketDelegate
extension ImmersiveNetworkCore {
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
    
    //server
    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {

    }
}

//MARK: - NetServiceDelegate
extension ImmersiveNetworkCore {
    public func netServiceDidPublish(_ sender: NetService) {
        
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        
    }
    
    public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        
    }
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        
    }
}

//MARK: - NetServiceBrowserDelegate
extension ImmersiveNetworkCore {
    public func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        
    }
    
    public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        
    }
}
