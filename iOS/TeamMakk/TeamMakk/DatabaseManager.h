//
//  DatabaseManager.h
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class HKHealthStore;
@interface DatabaseManager : NSObject

@property (nonatomic) HKHealthStore *healthStore;

+(DatabaseManager *)getSharedInstance;

-(BOOL)createTable;

-(BOOL)saveExercise: (int) exerciseNum numberOfReps: (int) numReps date:(NSDate *)date;

-(NSMutableArray *) fetchExercisesWithExerciseNum: (int) exerciseNum;

-(BOOL) updateGoals:(int) exerciseNum withNewGoal:(int)newGoal;

-(NSMutableArray *) fetchAllGoals;

-(BOOL) addDefaultGoals;

-(int) getCurrentActivityWithWorkoutIndex:(int)currActivity;

@end
