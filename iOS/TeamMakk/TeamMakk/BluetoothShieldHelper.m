//
//  BluetoothShieldHelper.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "BluetoothShieldHelper.h"

@implementation BluetoothShieldHelper
{
  id<BluetoothListenerDelegate> _listener;
  BLE *bleShield;
  
  int currentWorkoutNumber;
  
  BOOL isInWorkout;
  
  NSTimer *workoutTimer;
  
  int currBufferIndex;
}

+ (id)sharedShieldHelper
{
  static BluetoothShieldHelper *sharedShieldHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedShieldHelper = [[self alloc] init];
  });
  return sharedShieldHelper;
}

-(void) setListener: (id<BluetoothListenerDelegate>) newListener
{
  _listener = newListener;
}

-(instancetype) init
{
  self = [super init];
  
  if (self)
  {
    //Setup shieeeezzzz
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    isInWorkout = false;
  }
  return self;
}

-(void) initDevice
{
  //Connect to the device
  [self BLEShieldScan:nil];
  
  //
}

-(void) connectionTimer:(NSTimer *)timer
{
  if(bleShield.peripherals.count > 0)
  {
    [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
  }
  else
  {
    
  }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
  NSData *d = [NSData dataWithBytes:data length:length];
  
  //NSString *string = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
  
  int value = (int)(((char *)[d bytes])[0]);
  
  if (value < 0) {
    value += 256;
  }
  
  currBufferIndex++;
  
  /*string = [@"0x" stringByAppendingString:string];
  
  unsigned short value;
  sscanf([string UTF8String], "%hx", &value);*/
  
  NSLog(@"Value received from arduino: %d", value);
  
  //NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
  //NSLog(@"%@", s);
  
  //NSNumber *form = [NSNumber numberWithBool:YES];
  
  /*NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:s, TEXT_STR, form, FORM, nil];
  [tableData addObject:dict];
  
  [_tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
  [_tableView reloadData];*/
  //NSLog
  
  
  if (isInWorkout)
  {
    //If they are working out, the value is the "value" of the workout they are currently doing
    if (value == 254)
    {
      //0xFE aka end command
      
      //Stop timer when end command
      [_listener didEndWorkout:currentWorkoutNumber];
      
      isInWorkout = NO;
    } else {
      [_listener didReceiveWorkoutNumberUpdate:value];
    }
  }
  //Check for a 1 - 4 coming from Arduino to indicate that we are starting a workout
  else {
    if (value == 1)
    {
      //Pushup
      currentWorkoutNumber = 1;
      
      //Send goal to the arduino
      [self sendNumberToArduino:10];
      
    } else if (value == 2)
    {
      //R Plank
      currentWorkoutNumber = 2;
      
      //Send goal to the arduino
      [self sendNumberToArduino:10];
    } else if (value == 3)
    {
      //L Plank
      currentWorkoutNumber = 3;
      
      //Send goal to the arduino
      [self sendNumberToArduino:10];
    } else if (value == 4){
      //Situp
      currentWorkoutNumber = 4;
      
      //Send goal to the arduino
      [self sendNumberToArduino:10];
    } else if (value == 253) {
      //0xFD aka start command
      
      //Start a timer to keep track of how long stuff has been going on for
      [_listener didStartWorkout:currentWorkoutNumber];
      
      isInWorkout = YES;
      currBufferIndex = 0;
    } else {
      NSLog(@"Unrecognized workout");
      assert(0);
    }
    currBufferIndex = 0;
  }
  
  //Send goal to Adam.
  //For exercises 1 - 4 these will be numbers.
  //For exercises 2 and 3 send back goal in Seconds (no more than 255 aka 4 min)
  
  //After initial handshake will receive current # of workout.
  //Send # of pushups
  //Start timer when I get a Start, and stop timer when I get a stop.
  
  //Send me 0xFE to indicate that workout is stopped
}

- (void)BLEShieldScan:(id)sender
{
  if (bleShield.activePeripheral)
  {
    if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
    {
      [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
      return;
    }
  }
  
  if (bleShield.peripherals)
    bleShield.peripherals = nil;
  
  [bleShield findBLEPeripherals:3];
  
  [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

-(void) readRSSITimer:(NSTimer *)timer
{
  [bleShield readRSSI];
}

- (void) bleDidDisconnect
{
  NSLog(@"bleDidDisconnect");
  
  //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void) sendControlMessage
{
  [self sendNumberToArduino:1];
}

-(void) sendNumberToArduino: (int) number
{
  if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
    
    UInt8 j= number;
    NSData *data = [[NSData alloc] initWithBytes:&j length:sizeof(j)];
    
    [bleShield write:data];
  } else {
    NSLog(@"Trying to send message without connected BLE Shield");
    
  }
}

-(void) bleDidConnect
{
  NSLog(@"bleDidConnect");
  
  //Send a 1 to indicate that we are connected
  //Send a message to the arduino
  
  //if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
    /* NSString *text = @"1";
     NSNumber *form = [NSNumber numberWithBool:NO];
     
     NSString *s;
     NSData *d;
     
     if (text.length > 16)
     s = [text substringToIndex:16];
     else
     s = text;*/
    
    //UInt8 j= 0x01;
    //NSData *data = [[NSData alloc] initWithBytes:&j length:sizeof(j)];
    
    //d = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    //[bleShield write:data];
  //}
}

@end
