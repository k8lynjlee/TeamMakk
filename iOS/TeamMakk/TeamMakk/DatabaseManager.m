//
//  DatabaseManager.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "DatabaseManager.h"
#import "WorkoutPointObject.h"
#import "WorkoutGoalObject.h"

#import <HealthKit/HealthKit.h>

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

static NSString* kProgressDatabaseName = @"Progress";
static NSString* kGoalsDatabaseName = @"Goals";

@implementation DatabaseManager
{
  NSMutableDictionary* tableValues;
  DatabaseManager *sharedManager;
  NSString *databasePath;
}

+(DatabaseManager *)getSharedInstance
{
  static DatabaseManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  return sharedManager;
}

-(id) init
{
  self = [super init];
  
  NSArray *progressFields = @[ @"Exercise text", @"Number text", @"Date text" ];
  NSArray *goalsFields = @[ @"Exercise text", @"Number text"];
 // _dataPointFieldNames = @[ @"Exercise", @"Number", @"Date"];
    tableValues = [NSMutableDictionary dictionary];
  
  [self createTable:kProgressDatabaseName withFields:progressFields];
  [self createTable:kGoalsDatabaseName withFields:goalsFields];
  
  
  
  if ([HKHealthStore isHealthDataAvailable]) {
    self.healthStore = [[HKHealthStore alloc] init];
    
    NSSet *writeDataTypes = [self dataTypesToWrite];
    NSSet *readDataTypes = [self dataTypesToRead];
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"You didn't allow healthkit to access these read/write data types");
        return;
      }
      dispatch_async(dispatch_get_main_queue(), ^{
//        [self saveleftPlankTime:60 rightPlankTime:18];
        //        [self savePushupTime:30];
        //        [self saveCrunchesTime:40];
        // self update info from healthkit.
      });
    }];
    
  }
  
  
  return self;
}

-(BOOL)createTable:(NSString *)tableName withFields: (NSArray *)fields
{
  NSString *docsDir;
  NSArray *dirPaths;
  // Get the documents directory
  dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  docsDir = dirPaths[0];
  
  // Build the path to the database file
  databasePath = [[NSString alloc] initWithString:
                  [docsDir stringByAppendingPathComponent: @"smartMat.db"]];
  
  BOOL isSuccess = YES;
  //NSFileManager *filemgr = [NSFileManager defaultManager];
  
  //if ([filemgr fileExistsAtPath: databasePath ] == NO)
  {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      char *errMsg;
      //const char *sql_stmt =
      //"create table if not exists studentsDetail (regno integer, primary key, name text, department text, year text)";
      
      NSMutableString *sql_stmt = [NSMutableString string];
      [sql_stmt appendString:@"CREATE TABLE IF NOT EXISTS "];
      
      [sql_stmt appendString:tableName];
      
      NSMutableString *values = [NSMutableString string];
      NSMutableString *valueNames = [NSMutableString string];
      
      [values appendString:@"("];
      [valueNames appendString:@"("];
      
      int numFields = [fields count];
      
      for (int i = 0; i < numFields; i++)
      {
        [values appendString:fields[i]];
        
        NSRange currRange = [fields[i] rangeOfString:@" "];
        currRange.length = currRange.location;
        currRange.location = 0;
        
        [valueNames appendString:[fields[i] substringWithRange:currRange]];
        
        if (i != numFields - 1) {
          [values appendString:@","];
          [valueNames appendString:@","];
        }
      }
      
      [values appendString:@")"];
      [valueNames appendString:@")"];
      
      [sql_stmt appendString:values];
      
      [tableValues setValue:valueNames forKey:tableName];
      
      if (sqlite3_exec(database, [sql_stmt UTF8String], NULL, NULL, &errMsg)
          != SQLITE_OK)
      {
        isSuccess = NO;
      }
      sqlite3_close(database);
      return  isSuccess;
    }
    else {
      isSuccess = NO;
    }
  }
  return isSuccess;
}

-(BOOL)saveExercise:(int) exerciseNum numberOfReps:(int) numReps date:(NSDate *)date
{
  
  switch (exerciseNum) {
    case 1: {
      [self savePushupTime:numReps];
      break;
    } case 2:{
      [self saveleftPlankTime:numReps];
      break;
    } case 3: {
      [self saveRightPlankTime:numReps];
      break;
    } case 4: {
      [self saveCrunchesTime:numReps];
      break;
    }
    default:
      break;
  }

  
  const char *dbpath = [databasePath UTF8String];
  
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
      NSMutableString *insertSQL = [NSMutableString string];
      [insertSQL appendString:@"INSERT INTO "];
      [insertSQL appendString: kProgressDatabaseName];
      [insertSQL appendString: tableValues[kProgressDatabaseName]];
      [insertSQL appendString: @" VALUES("];
      [insertSQL appendFormat: @"\"%i\"", exerciseNum];
      [insertSQL appendString: @","];
      [insertSQL appendFormat: @"\"%i\"", numReps];
      [insertSQL appendString: @",\""];
    
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat = @"MM/dd/yy, hh:mm a:ss";
      NSString *resultString = [dateFormatter stringFromDate: date];
      
      [insertSQL appendString:resultString];
      [insertSQL appendString:@"\")"];
    
      const char *insert_stmt = [insertSQL UTF8String];
      sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
      {
        return YES;
      }
      else {
        return NO;
      }
      sqlite3_reset(statement);
  }
  
  return NO;
}

-(NSMutableArray *) fetchAllGoals
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ ", kGoalsDatabaseName];
    
    const char *query_stmt = [querySQL UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
      while (sqlite3_step(statement) == SQLITE_ROW)
      {
        NSString * exercise = [[NSString alloc] initWithUTF8String:
                               (const char *) sqlite3_column_text(statement, 0)];
        NSString * number = [[NSString alloc] initWithUTF8String:
                             (const char *) sqlite3_column_text(statement, 1)];
        
        [resultArray addObject:[[WorkoutGoalObject alloc] initWithExercise:[exercise intValue]
                                                                     number:[number intValue]]];
      }
      return resultArray;
      sqlite3_reset(statement);
    }
  }
  return nil;
}

-(NSMutableArray *) fetchExercisesWithExerciseNum: (int) exerciseNum
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Exercise = '%i'", kProgressDatabaseName, exerciseNum];
    
    const char *query_stmt = [querySQL UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
      while (sqlite3_step(statement) == SQLITE_ROW)
      {
        NSString * exercise = [[NSString alloc] initWithUTF8String:
                        (const char *) sqlite3_column_text(statement, 0)];
        NSString * number = [[NSString alloc] initWithUTF8String:
                      (const char *) sqlite3_column_text(statement, 1)];
        NSString *dataTime = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 2)];
        
        [resultArray addObject:[[WorkoutPointObject alloc] initWithExercise:exercise
                                                                    number:number
                                                                     date: dataTime]];
      }
      return resultArray;
      sqlite3_reset(statement);
    }
  }
  return nil;
}

-(int) getCurrentActivityWithWorkoutIndex:(int) exerciseNum
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Exercise = '%i'", kProgressDatabaseName, exerciseNum];
    
    const char *query_stmt = [querySQL UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
      while (sqlite3_step(statement) == SQLITE_ROW)
      {
        NSString * number = [[NSString alloc] initWithUTF8String:
                             (const char *) sqlite3_column_text(statement, 1)];
        
        int count = [number intValue];
        
        return count;
      }
      return 0;
      sqlite3_reset(statement);
    }
  }
  return 0;
}

-(BOOL) addDefaultGoals
{
  const char *dbpath = [databasePath UTF8String];
  
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    for (int i = 0; i < 4; i++)
    {
      NSMutableString *insertSQL = [NSMutableString string];
      [insertSQL appendString:@"INSERT INTO "];
      [insertSQL appendString: kGoalsDatabaseName];
      [insertSQL appendString: tableValues[kGoalsDatabaseName]];
      [insertSQL appendString: @" VALUES("];
      [insertSQL appendFormat: @"\"%i\"", i];
      [insertSQL appendString: @","];
      [insertSQL appendFormat: @"\"%i\"", 10];
      [insertSQL appendString:@")"];
      
      const char *insert_stmt = [insertSQL UTF8String];
      sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
      if (sqlite3_step(statement) != SQLITE_DONE)
      {
        return NO;
      }
    }
    return YES;
    sqlite3_reset(statement);
  }
  return NO;
}

-(BOOL) updateGoals:(int) exerciseNum withNewGoal:(int)newGoal
{
  //Check to make sure the serialized object has the same number of properties
  const char *dbpath = [databasePath UTF8String];
  
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    //Serialize the object
    //NSString *objData = [dataPoint serializeData];
    
    NSMutableString *insertSQL = [NSMutableString string];
    [insertSQL appendString:@"UPDATE "];
    [insertSQL appendString: kGoalsDatabaseName];
    [insertSQL appendString: @" SET Number =\""];
    [insertSQL appendFormat: @"%i", newGoal];
    [insertSQL appendString: @"\""];
    
    [insertSQL appendString: @" WHERE Exercise=\""];
    [insertSQL appendFormat: @"%i", exerciseNum];
    [insertSQL appendString: @"\""];
    
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
    sqlite3_reset(statement);
  }
  //INSERT INTO DATABASENAME(x, x, x) VALUES(x, x, x)
  return NO;
}

- (void)saveCrunchesTime:(double)time {
  HKUnit *cal = [HKUnit kilocalorieUnit];

  float calsPerRep = 1;
  
  HKQuantity *crunchesEnergy = [HKQuantity quantityWithUnit:cal doubleValue:time*calsPerRep];
  HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKQuantitySample *pushups = [HKQuantitySample quantitySampleWithType:type
                                                              quantity:crunchesEnergy
                                                             startDate:[NSDate date]
                                                               endDate:[NSDate date]
                                                              metadata:nil];
  
  NSMutableArray *samples = [[NSMutableArray alloc] initWithObjects:pushups, nil];
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:time
                                        totalEnergyBurned:nil
                                            totalDistance:nil
                                                 metadata:nil];
  
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the data");
      abort();
    }
    
    [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"An error occured adding sample to workout");
        NSLog(@"%@", error.description);
        abort();
      }
      NSLog(@"Added samples to workout");
    }];
    
    NSLog(@"Saved the data");
  }];
}


- (void)savePushupTime:(double)reps {
  HKUnit *cal = [HKUnit kilocalorieUnit];
  float calsPerRep = 1;
  
  HKQuantity *pushupEnergy = [HKQuantity quantityWithUnit:cal doubleValue:reps*calsPerRep];
  HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKQuantitySample *pushups = [HKQuantitySample quantitySampleWithType:type
                                                              quantity:pushupEnergy
                                                             startDate:[NSDate date]
                                                               endDate:[NSDate date]
                                                              metadata:nil];
  
  NSMutableArray *samples = [[NSMutableArray alloc] initWithObjects:pushups, nil];
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:reps
                                        totalEnergyBurned:nil
                                            totalDistance:nil
                                                 metadata:nil];
  
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the data");
      abort();
    }
    
    [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"An error occured adding sample to workout");
        NSLog(@"%@", error.description);
        abort();
      }
      NSLog(@"Added samples to workout");
    }];
    
    NSLog(@"Saved the data");
  }];
}

- (void)saveRightPlankTime:(double)rightTime {
  HKUnit *cal = [HKUnit kilocalorieUnit];
  
  float duration = rightTime;
  float calsPerHour = 200;
  float calsPerSecond = calsPerHour/360.0;
  
  HKQuantity *rightPlankEnergy = [HKQuantity quantityWithUnit:cal doubleValue:rightTime*calsPerSecond];
  
  HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  
  HKQuantitySample *rightPlank = [HKQuantitySample quantitySampleWithType:type
                                                                 quantity:rightPlankEnergy
                                                                startDate:[NSDate date]
                                                                  endDate:[NSDate date]
                                                                 metadata:nil];
  
  NSMutableArray *samples = [[NSMutableArray alloc] initWithObjects:rightPlank, nil];
  
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:duration
                                        totalEnergyBurned:nil
                                            totalDistance:nil
                                                 metadata:nil];
  
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the data");
      //      abort();
    }
    
    [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"An error occured adding sample to workout");
        NSLog(@"%@", error.description);
                abort();
      }
      NSLog(@"Added samples to workout");
    }];
    
    NSLog(@"Saved the data");
  }];
}


- (void)saveleftPlankTime:(double)leftTime {
  HKUnit *cal = [HKUnit kilocalorieUnit];
  
  float duration = leftTime;
  float calsPerHour = 200;
  float calsPerSecond = calsPerHour/360.0;
  
  HKQuantity *leftPlankEnergy = [HKQuantity quantityWithUnit:cal doubleValue:leftTime*calsPerSecond];

  HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  
  HKQuantitySample *leftPlank = [HKQuantitySample quantitySampleWithType:type
                                                                quantity:leftPlankEnergy
                                                               startDate:[NSDate date]
                                                                 endDate:[NSDate date]
                                                                metadata:nil];
  
  NSMutableArray *samples = [[NSMutableArray alloc] initWithObjects:leftPlank, nil];
  
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:duration
                                        totalEnergyBurned:nil
                                            totalDistance:nil
                                                 metadata:nil];
  
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the data");
      //      abort();
    }
    
    [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"An error occured adding sample to workout");
        NSLog(@"%@", error.description);
        //        abort();
      }
      NSLog(@"Added samples to workout");
    }];
    
    NSLog(@"Saved the data");
  }];
}



#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
  HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKWorkoutType *workoutType = [HKWorkoutType workoutType];
  
  return [NSSet setWithObjects:workoutType, activeEnergyBurnType, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
  HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
  //  HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
  
  return [NSSet setWithObjects:heightType, nil];
}




@end
