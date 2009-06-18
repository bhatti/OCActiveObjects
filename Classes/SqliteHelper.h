//
//  SqliteHelper.h
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface SqliteHelper : NSObject {

}

+ (NSString *) getDatabaseFilePath:(NSString *)dbName;

+ (void) bindVariables:(sqlite3_stmt *)stmt withNames:(NSArray *)names withTypes:(NSDictionary *)propertyNamesAndTypes withObject:(NSObject *)object;

+ (void) bindVariables:(sqlite3_stmt *)stmt withNames:(NSArray *)names withTypes:(NSDictionary *)propertyNamesAndTypes withValues:(NSDictionary *)values;


@end
