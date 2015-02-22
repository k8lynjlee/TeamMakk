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

-(BOOL)saveExercise: (int) exerciseNum numberOfReps: (int) numReps date:(NSDate *)date
{
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
      [insertSQL appendString: @","];
    
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat = @"MM/dd/yy, hh:mm a:ss";
      NSString *resultString = [dateFormatter stringFromDate: date];
      
      [insertSQL appendString:resultString];
      [insertSQL appendString:@")"];
    
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
        int exercise = (int)sqlite3_column_text(statement, 0);
        int number = (int)sqlite3_column_text(statement, 1);
        NSString *dataTime = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 2)];
        
        [resultArray addObject:[[WorkoutPointObject alloc] initWithExercise:exerciseNum
                                                                    number:number
                                                                     date: dataTime]];
      }
      return resultArray;
      sqlite3_reset(statement);
    }
  }
  return nil;
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

@end
