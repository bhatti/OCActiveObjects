//
//  IntrospectHelper.h
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



#define kDATE_TYPE              @"NSDate"
#define kNUMBER_TYPE            @"NSNumber"
#define kSINT_TYPE              @"^i"
#define kSTRING_TYPE            @"NSString"
#define kCSTRING_TYPE           @"*"
#define kBOOL_TYPE              @"c"
#define kDOUBLE_TYPE            @"d"
#define kLONG_LONG_TYPE         @"q"
#define kULONG_LONG_TYPE        @"Q"
#define kLONG_INT_TYPE          @"l"
#define kULONG_INT_TYPE         @"L"
#define kINT_TYPE               @"i"
#define kUINT_TYPE              @"I"
#define kSHORT_TYPE             @"s"
#define kUSHORT_TYPE            @"S"
#define kCHAR_TYPE              @"c"



@interface IntrospectHelper : NSObject {

}

+ (NSDictionary *) getPropertyNamesAndTypesForClassAndSuperClasses:(Class)klass;

+ (void) loadPropertyNamesAndTypesForClass:(Class)klass intoProperties:(NSMutableDictionary *) propertyNamesAndTypes;


+ (BOOL) isNumberType:(NSString *) type;
+ (BOOL) isCIntegerType:(NSString *) type;
+ (BOOL) isDoubleType:(NSString *) type;
+ (BOOL) isStringType:(NSString *) type;
+ (BOOL) isCStringType:(NSString *) type;
+ (BOOL) isDateType:(NSString *) type;
+ (BOOL) isCharType:(NSString *) type;
+ (BOOL) isBooleanType:(NSString *) type;

@end
