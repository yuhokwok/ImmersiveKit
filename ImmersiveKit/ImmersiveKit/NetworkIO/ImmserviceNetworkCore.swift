//
//  ImmserviceNetworkCore.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
//import CocoaAsyncSocket
import ARKit


/// Foundation Class for ImmersiveClient & ImmersiveServver
public class ImmersiveNetworkCore : NSObject, GCDAsyncSocketDelegate, NetServiceDelegate, NetServiceBrowserDelegate, ImmersiveBodyTrackerDelegate {
    
    public static let TIMEOUT : TimeInterval = -1
    
    /// Set this ture, the server will be an echo server
    public var isEcho : Bool = false
    
    public var receiverDelegate : ImmersiveDataReceiverDelegate?
    public var debugDelegate : ImmersiveKitDebugging?
    
    /// A socket for connection to server / client
    public var asyncSocket : GCDAsyncSocket?
    
    /// NetService Object for bonjour connection
    public var netService : NetService?
  
    //monitor the writing state of data
    public var isWritingData = false
    
    /// indicate the client write the latest frame only or not
    public var canWriteWithDropFrame : Bool = false
    
    //pending for future use
//    public var useACK : Bool = true
//    public var waitingForACK: Bool = false
//    public static var ack : Data {
//        return "ack".data(using: .utf8)!
//    }
    
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
    
    
    /// Write Data with String
    /// - Parameter str: string to be sent
    public func write(str : String) {
        if let data = str.data(using: .utf8) {
            write(data: data)
        }
        //printLog("send - \(msg)")
    }
    
    /// Write Data with Data
    /// - Parameter data: data to be sent
    public func write(data : Data) {
        
        if canWriteWithDropFrame == true {
            if isWritingData == false {
                isWritingData = true
                self.asyncSocket?.write(data, withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
                self.asyncSocket?.write(GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
                self.asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
            } else {
                printLog("skip")
            }
        } else {
            self.asyncSocket?.write(data, withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
            self.asyncSocket?.write(GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
            self.asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
        }
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
            
            if let msg = bodyJSONData.stringify() {
                //ImmersiveCore.print(msg: "\(msg)")
            }
            
            self.transmit(body : body)
            //transformCount = 1
        //}
        
    }
}

//MARK: - GCDAsyncSocketDelegate
extension ImmersiveNetworkCore {
    //server
    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        ImmersiveCore.print(msg: "did connect to host")
        sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        //pending for future use
//        if let string = data.stringify() {
//            if !string.hasPrefix("ack") && useACK == false {
//                self.write(data: ImmersiveNetworkCore.ack)
//            } else if string.hasPrefix("ack") && useACK == true && waitingForACK == true {
//                waitingForACK = false
//            }
//        }

        //ImmersiveCore.print(msg: "received data")
        //try converting received data to body type
        let decoder : JSONDecoder = JSONDecoder();
        if let body = try? decoder.decode(Body.self, from: data) {
            self.receiverDelegate?.bodyReceived(body: body)
        }
        
        if let setting = try? decoder.decode(VRCameraSetting.self, from: data) {
            self.receiverDelegate?.cameraSettingReceived(setting: setting)
        }
        
        if let str = data.stringify()  {
            // received string from client server
            printLog("received: \(str.quickTrim())")
            if isEcho {
                sock.write(data, withTimeout: -1, tag: -1)
            }
        }
        
        sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: ImmersiveNetworkCore.TIMEOUT, tag: -1)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        isWritingData = false
    }
    
    
    
//    public func socket(_ sock: GCDAsyncSocket, shouldTimeoutWriteWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
//        isWritingData = false
//        return -1
//    }
    
    
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
