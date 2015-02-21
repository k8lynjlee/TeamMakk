//
//  DatabaseManager.h
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject

+(DatabaseManager *)getSharedInstance;

-(BOOL)createTable;

-(BOOL)saveExercise: (int) exerciseNum numberOfReps: (int) numReps date:(NSDate *)date;

-(NSMutableArray *) fetchExercisesWithExerciseNum: (int) exerciseNum;

@end
