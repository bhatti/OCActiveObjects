//
//  ActiveObject.m
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActiveObject.h"
#import "IntrospectHelper.h"
#import "SqliteHelper.h"


@implementation ActiveObject
@synthesize objectId;
static sqlite3 *database = NULL;
static sqlite3_stmt *insertStmt = NULL;
static sqlite3_stmt *updateStmt = NULL;


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToActiveObject:other];
}

- (BOOL)isEqualToActiveObject:(ActiveObject *)object {
    if (self == object)
        return YES;
    if (![(id)[self objectId] isEqual:[object objectId]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = 0;
	hash += [[self objectId] hash];
	return hash;
}


- (void) save {
	if (self.objectId == nil) {
		[self _insert];
	} else {
		[self _update];
	}
}

- (void) _insert {
	NSString *sql = [[self class] _getInsertSQL];
	if(insertStmt == nil) { 
		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &insertStmt, NULL) != SQLITE_OK) {
			const char *errorMsg = sqlite3_errmsg(database);
			[NSException raise:@"Failed to create insert statement " format:@"%s", errorMsg];
		}       
	}
	NSArray *fieldNames = [[self class] _getPropertyNamesWithoutObjectId];
	

	[SqliteHelper bindVariables:insertStmt withNames:fieldNames withTypes:[[self class] _getPropertyNamesAndTypes] withObject:self];
	
	if(SQLITE_DONE != sqlite3_step(insertStmt)) {
		const char *errorMsg = sqlite3_errmsg(database);
		[NSException raise:@"Insert failed with " format:@"%s", errorMsg];
	}
	objectId = [NSNumber numberWithInt: sqlite3_last_insert_rowid(database)];
	NSLog(@"Inserted with id %@ --  %@\n", self, sql);
	
	sqlite3_reset(insertStmt);
}


- (void) _update {
	NSString *sql = [[self class] _getUpdateSQL];
	if(updateStmt == nil) { 
		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &updateStmt, NULL) != SQLITE_OK) {
			const char *errorMsg = sqlite3_errmsg(database);
			[NSException raise:@"Failed to update statement " format:@"%s", errorMsg];
		}       
	}

	NSMutableArray *fieldNames = [[[NSMutableArray alloc] init] autorelease];
	[fieldNames addObjectsFromArray:[[self class] _getPropertyNamesWithoutObjectId]];
	[fieldNames addObject:@"objectId"];
	
	[SqliteHelper bindVariables:updateStmt withNames:fieldNames withTypes:[[self class] _getPropertyNamesAndTypes] withObject:self];
	
	if(SQLITE_DONE != sqlite3_step(updateStmt)) {
		const char *errorMsg = sqlite3_errmsg(database);
		[NSException raise:@"Update failed with " format:@"%s", errorMsg];
	}
	NSLog(@"Updated with id %@ --  %@\n", self, sql);
	
	sqlite3_reset(updateStmt);
}



- (void) dealloc {
	[super dealloc];
}


/*
 * Class-level methods
 */


+ (NSString	*) getTableName {
	[NSException raise:@"override getTableName for your model" format:@"", @""];
	return nil;
}

+ (NSString	*) getDatabaseName {
	[NSException raise:@"override getDatabaseName (without fullpath)" format:@"", @""];
	return nil;
}


+ (void) openDatabase {
	const char* dbPath = [[SqliteHelper getDatabaseFilePath:[self getTableName]] UTF8String];
	NSLog(@"\n\n\nopening database %s\n\n\n", dbPath);
	if(sqlite3_open(dbPath, &database) != SQLITE_OK) {
		[self closeDatabase];
	} else {
		[self _createTable];
	}
}



+ (void) closeDatabase {
	if(database) {
		sqlite3_close(database);
		database = NULL;
	}
	if(insertStmt) {
		sqlite3_finalize(insertStmt);
		insertStmt = NULL;
	}
	if(updateStmt) {
		sqlite3_finalize(updateStmt);
		updateStmt = NULL;
	}
}



+ (ActiveObject *) findByPrimaryKey:(NSNumber *)objId {
	NSDictionary *criteria = [NSDictionary dictionaryWithObjectsAndKeys:objId, @"objectId", nil];	

	
	NSArray *matched = [self findWithCriteria:criteria];
	if ([matched count] == 0) {
		return nil;
	} else {
		return [matched objectAtIndex:0];
	}
}

+ (NSArray *) findAll {
	return [self findWithCriteria:
			[NSDictionary dictionaryWithObjectsAndKeys:	 nil]];	
}

+ (NSArray *) findWithCriteria:(NSDictionary *)criteria {
	NSMutableArray *matched = [[NSMutableArray alloc] init];
	NSMutableString *sql = [self _getSelectSQL];
	if ([criteria count] > 0) {
		[sql appendString:[self _toWhere:[criteria allKeys]]];
	}
	
	NSLog(@"Querying with sql %@ with criteria %d --- %@\n\n", sql, [criteria count], criteria);
	
	sqlite3_stmt *statement = NULL;
	
	if (sqlite3_prepare_v2( database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK) {
		return matched;
	}
	if ([criteria count] > 0) {
		[SqliteHelper bindVariables:statement withNames:[criteria allKeys] withTypes:[[self class] _getPropertyNamesAndTypes] withValues:criteria];
	}
	
	
	NSDictionary *propertyNamesAndTypes = [self _getPropertyNamesAndTypes];
	NSArray *keys = [self _getPropertyNamesWithoutObjectId];
	while (sqlite3_step(statement) == SQLITE_ROW) {
		ActiveObject *object = [[[self class] alloc] init];
		long ivalue = (int)sqlite3_column_int64(statement, 0);
		object.objectId = [NSNumber numberWithLong:ivalue];
		
		for (int i=0; i<[keys count]; i++) {
			NSString *key = [keys objectAtIndex:i];
			NSString *type = [propertyNamesAndTypes objectForKey:key];
			if ([IntrospectHelper isCIntegerType:type] || [IntrospectHelper isBooleanType:type] || [IntrospectHelper isCharType:type]) {
				long ivalue = (int)sqlite3_column_int64(statement, i+1);
				NSNumber *value = [NSNumber numberWithLong:ivalue];
				[object setValue:value forKey:key];
			} else if ([IntrospectHelper isNumberType:type] || [IntrospectHelper isDoubleType:type]) {
				double dvalue = sqlite3_column_double(statement, i+1);
				NSNumber *value = [NSNumber numberWithFloat:dvalue];
				[object setValue:value forKey:key];
			} else if ([IntrospectHelper isStringType:type]) {
				char *cvalue = (char *)sqlite3_column_text(statement, i+1);
				if (cvalue == NULL) {
					[object setValue:nil forKey:key];
				} else {
					NSString *value = [NSString stringWithCString:cvalue length:strlen(cvalue)];
					[object setValue:value forKey:key];
				}
			} else if ([IntrospectHelper isCStringType:type]) {
				char *cvalue = (char *)sqlite3_column_text(statement, i+1);
				NSString *value = [NSString stringWithCString:cvalue length:strlen(cvalue)];
				[object setValue:value forKey:key];
			} else if ([IntrospectHelper isDateType:type]) {
				double value = sqlite3_column_double(statement, i+1);
				NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
				[object setValue:date forKey:key];
			} else {
				[NSException raise:@"Invalid type for " format:@"%@ - %@", key, type];
			}
		} /* for all keys */
		[matched addObject:object];
		[object release];
	} /* for all rows */
	sqlite3_finalize(statement);
	return [matched autorelease];
}


+ (int) removeWithCriteria:(NSDictionary *)criteria {
	NSMutableString *sql = [NSMutableString stringWithCapacity: 128];
	[sql appendFormat:@"DELETE FROM %@", [self getTableName]];
	if ([criteria count] > 0) {
		[sql appendString:[self _toWhere:[criteria allKeys]]];
	}
	NSLog(@"Deleting with sql %@ with criteria %@\n\n", sql, criteria);
	
	sqlite3_stmt *statement = NULL;
	

	if (sqlite3_prepare_v2( database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK) {
		const char *errorMsg = sqlite3_errmsg(database);
		[NSException raise:@"Failed to delete statement " format:@"%s", errorMsg];
	}

	if ([criteria count] > 0) {
		[SqliteHelper bindVariables:statement withNames:[criteria allKeys] withTypes:[[self class] _getPropertyNamesAndTypes] withValues:criteria];
	}
	
	if (SQLITE_DONE != sqlite3_step(statement)) {
		const char *errorMsg = sqlite3_errmsg(database);
		[NSException raise:@"Failed to delete statement " format:@"%s", errorMsg];
	}	
	int count = sqlite3_changes(database);
	sqlite3_finalize(statement);
	return count;
}


+ (int) removeAll {
	return [self removeWithCriteria:
			[NSDictionary dictionaryWithObjectsAndKeys:	 nil]];	
}


+ (int) countAll {
	return [self countWithCriteria:
			[NSDictionary dictionaryWithObjectsAndKeys:	 nil]];	
}

+ (int) countWithCriteria:(NSDictionary *)criteria {
	NSMutableString *sql = [NSMutableString stringWithCapacity: 128];
	[sql appendFormat:@"SELECT COUNT(*) FROM %@", [self getTableName]];
	
	
	if ([criteria count] > 0) {
		[sql appendString:[self _toWhere:[criteria allKeys]]];
	}
	
	
	sqlite3_stmt *statement = NULL;
	if (sqlite3_prepare_v2( database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK) {
		const char *errorMsg = sqlite3_errmsg(database);
		[NSException raise:@"Failed to count statement " format:@"%s", errorMsg];
	}
	
	
	NSLog(@"Counting with sql %@ with criteria %@\n\n", sql, criteria);
	if ([criteria count] > 0) {
		[SqliteHelper bindVariables:statement withNames:[criteria allKeys] withTypes:[[self class] _getPropertyNamesAndTypes] withValues:criteria];
	}
	
	long count = 0;
	if(sqlite3_step(statement) == SQLITE_ROW) {
		count = (int)sqlite3_column_int64(statement, 0);
	}
	sqlite3_finalize(statement);
	
	return count;
}


+ (NSArray *) _getPropertyNames {
	static NSArray *propertyNamesAndTypes = nil;
	if (propertyNamesAndTypes == nil) {
		propertyNamesAndTypes = [[self _getPropertyNamesAndTypes] allKeys];
	}
	return propertyNamesAndTypes;
}

+ (NSArray *) _getPropertyNamesWithoutObjectId {
	static NSMutableArray *propertyNamesAndTypes = nil;
	if (propertyNamesAndTypes == nil) {
		propertyNamesAndTypes = [[NSMutableArray alloc] init];
		for (NSString *fieldName in [self _getPropertyNames]) {
			if ([fieldName isEqualToString:@"objectId"]) {
				continue;
			}
			[propertyNamesAndTypes addObject:fieldName];
		}
	}
	
	return propertyNamesAndTypes;
}



+ (NSDictionary *) _getPropertyNamesAndTypes {
	static NSDictionary *propertyNamesAndTypes = nil;		/* mapping of all property names to their types */
	if (propertyNamesAndTypes == nil) {
		propertyNamesAndTypes = [IntrospectHelper getPropertyNamesAndTypesForClassAndSuperClasses:[self class]];
	}
	if ([propertyNamesAndTypes count] == 0) {
		[NSException raise:@"No properties are defined for your domain class" format:@""];
	}
	return propertyNamesAndTypes;
}



+ (NSString *) _getCreateSQL {
	static NSMutableString *sql = nil;
	if (sql == nil) {
		sql = [NSMutableString stringWithCapacity: 128];
		[sql appendFormat: @"CREATE TABLE IF NOT EXISTS %@ (objectId INTEGER PRIMARY KEY, ", [self getTableName]];
		NSDictionary *propertyNamesAndTypes = [self _getPropertyNamesAndTypes];
		if ([propertyNamesAndTypes count] == 0) {
			[NSException raise:@"No properties defined" format:@""];
		}
		BOOL first = YES;
		NSArray *keys = [self _getPropertyNamesWithoutObjectId];
		for (int i=0; i<[keys count]; i++) {
			NSString *fieldName = [keys objectAtIndex:i];
			NSString *type = [[self _getPropertyNamesAndTypes] objectForKey:fieldName];
			
			if (!first) {
				[sql appendString:@", "];
			}
			first = NO;
			if ([IntrospectHelper isCIntegerType:type] || [IntrospectHelper isBooleanType:type] || [IntrospectHelper isCharType:type]) {
				[sql appendFormat: @"%@ INTEGER", fieldName];
			} else if ([IntrospectHelper isNumberType:type] || [IntrospectHelper isDoubleType:type]) {
				[sql appendFormat: @"%@ FLOAT", fieldName];
			} else if ([IntrospectHelper isStringType:type] || [IntrospectHelper isCStringType:type]) {
				[sql appendFormat: @"%@ TEXT", fieldName];
			} else if ([IntrospectHelper isDateType:type]) {
				[sql appendFormat: @"%@ FLOAT", fieldName];
			} else {
				[NSException raise:@"Invalid type for " format:@"%@ - %@, available types %@, %@, %@", fieldName, type, kSTRING_TYPE, kCSTRING_TYPE, kNUMBER_TYPE];
			}
		}
		[sql appendString:@");"];
		char *errorMsg;
		if (sqlite3_exec (database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			[NSException raise:@"Create failed with " format:@"%s", errorMsg];
		}
	}
	return sql;
}


+ (NSString *) _toWhere:(NSArray *)names {
	NSMutableString *sql = [NSMutableString stringWithCapacity: 128];
	BOOL first = YES;
	for (NSString *name in names) {
		if (first) {
			[sql appendString:@" WHERE "];
		} else {
			[sql appendString:@" AND "];
		}
		first = NO;
		[sql appendFormat:@"%@ = ?", name];
	}
	return sql;
}


+ (NSMutableString *) _getFieldNamesAsStringWithObjectId:(BOOL) useObjectId {
	static NSMutableString *sql = nil;
	if (sql == nil) {
		sql = [NSMutableString stringWithCapacity: 128];
	    NSArray *keys = useObjectId ? [self _getPropertyNames] : [self _getPropertyNamesWithoutObjectId];
	    for (int i=0; i<[keys count]; i++) {
			if (i > 0) {
				[sql appendString:@", "];
			}
			[sql appendFormat: @"%@", [keys objectAtIndex:i]];
	    }
	}
	return sql;
}

+ (NSMutableString *) _getInsertSQL {
	static NSMutableString *sql = nil;
	if (sql == nil) {
		sql = [NSMutableString stringWithCapacity: 128];
	    [sql appendFormat: @"INSERT INTO %@ (", [self getTableName]];
	    [sql appendString:[self _getFieldNamesAsStringWithObjectId:NO]];
		
	    [sql appendString:@") VALUES ("];
	    NSArray *fieldNames = [self _getPropertyNamesWithoutObjectId];
	    for (int i=0; i<[fieldNames count]; i++) {
			if (i > 0) {
				[sql appendString:@", "];
			}
			[sql appendString:@"?"];
	    }
	    [sql appendString:@")"];
	}
	return sql;
}

+ (NSMutableString *) _getUpdateSQL {
	static NSMutableString *sql = nil;
	if (sql == nil) {
		sql = [NSMutableString stringWithCapacity: 128];
	    [sql appendFormat: @"UPDATE %@ SET ", [self getTableName]];
	    NSArray *fieldNames = [self _getPropertyNamesWithoutObjectId];
	    for (int i=0; i<[fieldNames count]; i++) {
			if (i > 0) {
				[sql appendString:@", "];
			}
			[sql appendFormat:@"%@ = ?", [fieldNames objectAtIndex:i]];
	    }
	    [sql appendString:@" WHERE objectId = ?"];
	}
	return sql;
}


+ (NSMutableString *) _getSelectSQL {
	NSMutableString *sql = [NSMutableString stringWithCapacity: 128];
	[sql appendString: @"SELECT objectId, "];
	[sql appendString:[self _getFieldNamesAsStringWithObjectId:YES]];
	[sql appendFormat:@" FROM %@", [self getTableName]];
    return sql;
}



+ (void) _createTable {
	static BOOL created = NO;
	if (created) return;
	
	char * errorMsg;
	NSString *sql = [self _getCreateSQL];
	NSLog(@"Creating table with %@\n\n", sql);
	if (sqlite3_exec (database, [sql  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
		[self closeDatabase];
		[NSException raise:@"Failed to create table with " format:@"%s for table %@ due to %@", sql, [self getTableName], errorMsg];
		return;
	}
	created = YES;
}




@end

