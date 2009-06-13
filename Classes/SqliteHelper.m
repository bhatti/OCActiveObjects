//
//  SqliteHelper.m
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SqliteHelper.h"
#import "IntrospectHelper.h"

@implementation SqliteHelper


+ (NSString *) getDatabaseFilePath:(NSString *)dbName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:dbName];	
}


+ (void) bindVariables:(sqlite3_stmt *)stmt withNames:(NSArray *)names withTypes:(NSDictionary *)propertyNamesAndTypes withObject:(NSObject *)object {
	for (int i=0; i<[names count]; i++) {
		NSString *fieldName = [names objectAtIndex:i];
		NSString *type = [propertyNamesAndTypes objectForKey:fieldName];
		id value = [object valueForKey:fieldName];
		
		if ([IntrospectHelper isCIntegerType:type] || [IntrospectHelper isBooleanType:type] || [IntrospectHelper isCharType:type]) {
			long ivalue = [value longValue];
			sqlite3_bind_int64(stmt, i+1, ivalue);
		} else if ([IntrospectHelper isNumberType:type] || [IntrospectHelper isDoubleType:type]) {
			double dvalue = [value doubleValue];
			sqlite3_bind_double(stmt, i+1, dvalue);
		} else if ([IntrospectHelper isStringType:type]) {
			const char *svalue = [value UTF8String];
			sqlite3_bind_text(stmt, i+1, svalue, -1, SQLITE_TRANSIENT);
		} else if ([IntrospectHelper isCStringType:type]) {
			sqlite3_bind_text(stmt, i+1, (char*) value, -1, SQLITE_TRANSIENT);
		} else if ([IntrospectHelper isDateType:type]) {
			double dvalue = [value timeIntervalSince1970];
			sqlite3_bind_double(stmt, i+1, dvalue);
		} else {
			[NSException raise:@"Invalid type for " format:@"%@ - %@", fieldName, type];
		}       
	} /* for all keys */
}

+ (void) bindVariables:(sqlite3_stmt *)stmt withNames:(NSArray *)names withTypes:(NSDictionary *)propertyNamesAndTypes withValues:(NSDictionary *)values {	
	for (int i=0; i<[names count]; i++) { 
		NSString *fieldName = [names objectAtIndex:i];
		NSString *type = [propertyNamesAndTypes objectForKey:fieldName];
		id value = [values objectForKey:fieldName];
		
		if ([IntrospectHelper isCIntegerType:type] || [IntrospectHelper isBooleanType:type] || [IntrospectHelper isCharType:type]) {
			long ivalue = [value longValue];
			sqlite3_bind_int64(stmt, i+1, ivalue);
		} else if ([IntrospectHelper isNumberType:type] || [IntrospectHelper isDoubleType:type]) {
			double dvalue = [value doubleValue];
			sqlite3_bind_double(stmt, i+1, dvalue);
		} else if ([IntrospectHelper isStringType:type]) {
			const char *svalue = [value UTF8String];
			sqlite3_bind_text(stmt, i+1, svalue, -1, SQLITE_TRANSIENT);
		} else if ([IntrospectHelper isCStringType:type]) {
			sqlite3_bind_text(stmt, i+1, (char*) value, -1, SQLITE_TRANSIENT);
		} else if ([IntrospectHelper isDateType:type]) {
			double dvalue = [value timeIntervalSince1970];
			sqlite3_bind_double(stmt, i+1, dvalue);
		} else {
			[NSException raise:@"Invalid type for " format:@"%@ - %@", fieldName, type];
		}       
	} /* for all keys */
}


@end
