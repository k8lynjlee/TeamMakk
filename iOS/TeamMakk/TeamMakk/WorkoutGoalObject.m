//
//  WorkoutGoalObject.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "WorkoutGoalObject.h"

@implementation WorkoutGoalObject
{
  int _exerciseNum;
  int _number;
}

-(instancetype) initWithExercise:(int)exerciseNum
                          number:(int)number
{
  _exerciseNum = exerciseNum;
  _number = number;
  
  return self;
}

-(int) exerciseNum
{
  return _exerciseNum;
}

-(int) number
{
  return _number;
}

-(void) setNumber :(int) newValue
{
  _number = newValue;
}
@end
