//
//  WorkoutPointObject.h
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutPointObject : NSObject

-(instancetype) initWithExercise:(NSString *)exerciseNum
                  number:(NSString *)number
                    date:(NSString *)dateTime;

@end
