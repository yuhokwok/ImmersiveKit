//
//  ImmersiveClient.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//


import Foundation
import CocoaAsyncSocket

public protocol ImmersiveClientDelegate {
    
}

/// Class for receiving data from Immersive Server
public class ImmersiveClient : NSObject, NetServiceDelegate, NetServiceBrowserDelegate, GCDAsyncSocketDelegate {
    
    //Data Field
    private var serverAddresses : [Data]?
    private var asyncSocket : GCDAsyncSocket?
    private var serverService : NetService?
    private var netServiceBrowser : NetServiceBrowser?
    
}
//MARK: - GCDAsyncSocketDelegate
extension ImmersiveClient {
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
}

//MARK: - NetServiceDelegate
extension ImmersiveClient {
    public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        
    }
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        
    }
}

//MARK: - NetServiceBrowserDelegate
extension ImmersiveClient {
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

