//
//  ImmersiveServer.swift
//  ImmersiveTracker
//
//  Created by ImmersiveKit Team on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
//import CocoaAsyncSocket


/// Class for sending Tracking Data to Immersive Client
public class ImmersiveServer : ImmersiveNetworkCore {
    
    
    /// Set this ture, the server will be an echo server
    public var isEcho : Bool = false
    
    private var serviceType : String
    private var serviceDomain : String
    private var servicePort : Int32
    
    private var connectedSockets = [GCDAsyncSocket]()
    
    /// init an instance of immersiveServer
    /// - Parameters:
    ///   - type: zeroconf service type
    ///   - domain: zeroconf domain
    ///   - port: port
    ///   - runQueue: runQueue, if the input is nil, the runQueue would be the main queue
    public init(type : String, domain : String, port : Int32, runQueue: DispatchQueue? = nil) {
        
        self.serviceType = type;
        self.serviceDomain = domain;
        self.servicePort = port
        
        super.init(runQueue: runQueue)
    }
    
    
    /// Accept connection from clients and publish the service
    public override func start() throws {
        guard let asyncSocket = self.asyncSocket else {
            return 
        }
        
        try asyncSocket.accept(onPort: UInt16(self.servicePort))
        
        netService = NetService(domain: self.serviceDomain, type: self.serviceType, name: "", port: self.servicePort)
        netService?.delegate = self
        netService?.publish()
        
        //netService?.setTXTRecord(NetService.data(fromTXTRecord: ["hi" : "bye".data(using: .utf8)!]))
    }
    
    
    /// Disconnect all exisitng connection and stop publishing the service
    public override func stop() {
        for socket in connectedSockets {
            socket.disconnect()
        }
        connectedSockets.removeAll()
        asyncSocket?.disconnect()
        
        netService?.stop()
        netService?.delegate = nil
    }
    
}

//MARK: - CocoaAsyncSocketDelegate
extension ImmersiveServer {
    override public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        self.connectedSockets.append(newSocket)
        //newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: -1)
        super.socket(sock, didAcceptNewSocket: newSocket)
        printLog("connected")
    }
    
    override public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let index = connectedSockets.firstIndex(of: sock) {
            connectedSockets.remove(at: index)
        }
        printLog("disconnected")
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        super.socket(sock, didWriteDataWithTag: tag)
    }
    
    override public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        //try converting received data to body type
        let decoder : JSONDecoder = JSONDecoder();
        if let body = try? decoder.decode(Body.self, from: data) {
            self.receiverDelegate?.bodyReceived(body: body)
        }
        
        if let str = data.stringify()  {
            // received string from client server
            printLog("received: \(str.quickTrim())")
            if isEcho {
                sock.write(data, withTimeout: -1, tag: -1)
            }
        }
        super.socket(sock, didRead: data, withTag: tag)
    }
}

//MARK:-- NetServiceDelegate
extension ImmersiveServer {

    
    override public func netServiceDidPublish(_ sender: NetService) {
        printLog("netservice published") //2
    }

    override public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        printLog("netservice not publish")
    }
}
