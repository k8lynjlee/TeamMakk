//
//  BluetoothShieldHelper.h
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"

@protocol BluetoothListenerDelegate

-(void) didReceiveMessageFromShield: (NSString *) message;

@end

@interface BluetoothShieldHelper : NSObject < BLEDelegate >

+ (id)sharedShieldHelper;

-(void) setListener: (id<BluetoothListenerDelegate>) newListener;

//Scan for bluetooth device. Connect to the first one
-(void) initDevice;

//private functions
//

@end
