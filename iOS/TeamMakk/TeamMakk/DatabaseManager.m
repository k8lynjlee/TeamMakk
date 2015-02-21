  //
//  DatabaseManager.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-21.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "DatabaseManager.h"
#import "WorkoutPointObject.h"

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

static NSString* kDataPointDatabaseName = @"DataPoints";
static NSString* kDataTypeName = @"DataTypes";

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
  
  NSArray *dataPointFields = @[ @"Exercise int", @"Number int", @"Date text" ];
 // _dataPointFieldNames = @[ @"Exercise", @"Number", @"Date"];
  [self createTable:kDataPointDatabaseName withFields:dataPointFields];
  
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
      [insertSQL appendString: kDataPointDatabaseName];
      [insertSQL appendString: tableValues[kDataPointDatabaseName]];
      [insertSQL appendString: @" VALUES("];
      [insertSQL appendFormat: @"%i", exerciseNum];
      [insertSQL appendString: @","];
      [insertSQL appendFormat: @"%i", numReps];
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

-(NSMutableArray *) fetchExercisesWithExerciseNum: (int) exerciseNum
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Exercise = '%i'", kDataPointDatabaseName, exerciseNum];
    
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

@end
