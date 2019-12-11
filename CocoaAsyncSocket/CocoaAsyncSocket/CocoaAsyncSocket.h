//
//  CocoaAsyncSocket.h
//  CocoaAsyncSocket
//
//  Created by Yu Ho Kwok on 11/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

/** @framework CocoaAsyncSocket
   @abstract A Simple Socket Connection Framework
   @discussion ARKit lets create networked application using socket easily
*/

#import <Foundation/Foundation.h>


//! Project version number for CocoaAsyncSocket.
FOUNDATION_EXPORT double CocoaAsyncSocketVersionNumber;

//! Project version string for CocoaAsyncSocket.
FOUNDATION_EXPORT const unsigned char CocoaAsyncSocketVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CocoaAsyncSocket/PublicHeader.h>

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
