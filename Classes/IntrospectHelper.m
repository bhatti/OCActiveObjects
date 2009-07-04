//
//  IntrospectHelper.m
//  ActiveObjects
//
//  Created by shahzad bhatti on 6/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IntrospectHelper.h"
#import <objc/runtime.h>

/* copied from http://developer.apple.com/SampleCode/DynamicProperties/listing1.html */
static const char* getPropertyType(objc_property_t property) {
	// parse the property attribues. this is a comma delimited string. the type of the attribute starts with the
	// character 'T' should really just use strsep for this, using a C99 variable sized array.
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
		if (attribute[0] == 'T') {
			// return a pointer scoped to the autorelease pool. Under GC, this will be a separate block.
			int length = strlen(attribute);
			if (length > 2 && attribute[1] == '@') {
				return (const char *)[[NSData dataWithBytes:(attribute + 3) length:length-4] bytes];
			} else {
				return (const char *)[[NSData dataWithBytes:(attribute + 1) length:length] bytes];
			}
		}
	}
	return NULL;
}


@implementation IntrospectHelper

+ (NSDictionary *) getPropertyNamesAndTypesForClassAndSuperClasses:(Class)klass withPredicate:(TYPE_PREDICATE_FUNC) predicate {
	NSMutableDictionary *propertyNamesAndTypes = [[[NSMutableDictionary alloc] init] autorelease];
	while (klass != [NSObject class]) {
		[self loadPropertyNamesAndTypesForClass:klass withPredicate:predicate intoProperties:propertyNamesAndTypes];
		klass = [klass superclass];
	}
	return propertyNamesAndTypes;
}


+ (void) loadPropertyNamesAndTypesForClass:(Class)klass withPredicate:(TYPE_PREDICATE_FUNC)predicate intoProperties:(NSMutableDictionary *) propertyNamesAndTypes {
	unsigned int outCount;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);
	for(int i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if (propName) {
			const char *propType = getPropertyType(property);
			NSString *propertyName = [NSString stringWithUTF8String:propName];
			NSString *propertyType = [NSString stringWithUTF8String:propType];
			if (predicate(propertyType)) {
				[propertyNamesAndTypes setObject:propertyType forKey:propertyName];
			}
		}
	}
	free(properties);
}



+ (BOOL) isNumberType:(NSString *) type {
	return [type isEqualToString:kNUMBER_TYPE];
}

+ (BOOL) isCIntegerType:(NSString *) type {
	return ([type isEqualToString:kSINT_TYPE] ||
			[type isEqualToString:kLONG_LONG_TYPE] ||
			[type isEqualToString:kULONG_LONG_TYPE] ||
			[type isEqualToString:kLONG_INT_TYPE] ||
			[type isEqualToString:kULONG_INT_TYPE] ||
			[type isEqualToString:kINT_TYPE] ||
			[type isEqualToString:kUINT_TYPE] ||
			[type isEqualToString:kSHORT_TYPE] ||
			[type isEqualToString:kUSHORT_TYPE]);
}


+ (BOOL) isDoubleType:(NSString *) type {
	return ([type isEqualToString:kDOUBLE_TYPE]);
}


+ (BOOL) isStringType:(NSString *) type {
	return ([type isEqualToString:kSTRING_TYPE]);
}


+ (BOOL) isCStringType:(NSString *) type {
	return ([type isEqualToString:kCSTRING_TYPE]);
}

+ (BOOL) isDateType:(NSString *) type {
	return ([type isEqualToString:kDATE_TYPE]);
}

+ (BOOL) isCharType:(NSString *) type {
	return ([type isEqualToString:kCHAR_TYPE]);
}

+ (BOOL) isBooleanType:(NSString *) type {
	return ([type isEqualToString:kBOOL_TYPE]);
}


@end
