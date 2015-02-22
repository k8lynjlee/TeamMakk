//
//  WorkoutViewController.h
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothShieldHelper.h"



@interface WorkoutViewController : UIViewController <BluetoothListenerDelegate>

- (void)buttonPressedMessage:(id)sender;

@end
