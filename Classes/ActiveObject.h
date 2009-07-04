//
//  ActiveObject.h
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ActiveObjectProtocol
- (void) save;
@end


#define DECL_BELONGS(TYPE, NAME) \
TYPE *NAME; \
NSNumber *NAME ## Id;

#define DECL_PROTO_BELONGS(TYPE, NAME, SETTER) \
-(TYPE*)NAME;	\
-(void)SETTER:(TYPE *) the ## NAME; \
-(NSNumber *)NAME ## Id; \
-(void)SETTER ## Id:(NSNumber *)the ## NAME ## Id; \
@property (nonatomic, retain) NSNumber *NAME ## Id;


#define DEFINE_BELONGS(TYPE, NAME, SETTER) \
-(TYPE*)NAME {	\
return (TYPE *) [TYPE findByPrimaryKey:[self NAME ## Id]]; \
} \
-(void)SETTER:(TYPE *) the ## NAME { \
[the ## NAME save]; \
[self SETTER ## Id:the ## NAME.objectId]; \
} \
-(NSNumber *)NAME ## Id { \
return NAME ## Id; \
} \
-(void)SETTER ## Id:(NSNumber *)the ## NAME ## Id{ \
if (NAME ## Id != the ## NAME ## Id) { \
[NAME ## Id release]; \
NAME ## Id = [the ## NAME ## Id retain]; \
} \
} 



@interface ActiveObject : NSObject<ActiveObjectProtocol> {
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

- (void) _saveBelongsTo;

+ (NSDictionary *) _getPropertyNamesAndTypes;

+ (NSDictionary *) _getBelongsToPropertyNamesAndTypes;


+ (NSArray *) _getPropertyNames;

+ (NSArray *) _getPropertyNamesWithoutObjectId;

+ (NSMutableString *) _getFieldNamesAsStringWithObjectId:(BOOL) useObjectId;

+ (NSString *) _getCreateSQL;

+ (NSArray *) _getAddColumnsSQL;

+ (NSMutableString *) _getInsertSQL;

+ (NSMutableString *) _getUpdateSQL;

+ (NSMutableString *) _getSelectSQL;

+ (void) _createTable;

+ (void) _addNewColumns;

+ (NSString *) _toWhere:(NSArray *)names;


@end
