//
//  ActiveObject.h
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveObject : NSObject {
	NSNumber *objectId;                                     /* unique database id */

}

@property (nonatomic, retain) NSNumber *objectId;


- (void) save;

- (BOOL)isEqualToActiveObject:(ActiveObject *)object;

+ (void) openDatabase;

+ (void) closeDatabase;

+ (ActiveObject *) findByPrimaryKey:(NSNumber *)objId;

+ (NSArray *) findWithCriteria:(NSDictionary *)criteria;

+ (NSArray *) findAll;

+ (int) removeAll;

+ (int) removeWithCriteria:(NSDictionary *)criteria;

+ (int) countWithCriteria:(NSDictionary *)criteria;

+ (int) countAll;

+ (NSString *) getTableName;

+ (NSString *) getDatabaseName;


/* following are protected methods */


- (void) _insert;

- (void) _update;

+ (NSDictionary *) _getPropertyNamesAndTypes;

+ (NSArray *) _getPropertyNames;

+ (NSArray *) _getPropertyNamesWithoutObjectId;

+ (NSMutableString *) _getFieldNamesAsStringWithObjectId:(BOOL) useObjectId;

+ (NSString *) _getCreateSQL;

+ (NSMutableString *) _getInsertSQL;

+ (NSMutableString *) _getUpdateSQL;

+ (NSMutableString *) _getSelectSQL;

+ (void) _createTable;

+ (NSString *) _toWhere:(NSArray *)names;


@end
