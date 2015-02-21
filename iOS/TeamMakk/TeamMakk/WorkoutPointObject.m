//
//  WorkoutPointObject.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "WorkoutPointObject.h"

@implementation WorkoutPointObject
{
  int _exerciseNum;
  int _number;
  NSString * _dataTime;
}

-(instancetype) initWithExercise:(int)exerciseNum
                  number:(int)number
                    date:(NSString *)dataTime
{
  _exerciseNum = exerciseNum;
  _number = number;
  _dataTime = dataTime;
  
  return self;
}

@end
