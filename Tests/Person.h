//
//  Person.h
//  PlexLotto
//
//  Created by shahzad bhatti on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveObject.h"

@interface Person : ActiveObject {
	NSString *name;
	short age;
	int rank;
	long votes;
	char sex;
	double income;
	BOOL active;
	NSInteger flags;
	NSNumber *rating;
	NSDate *birthdate;	
}


@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) short age;
@property (nonatomic, assign) int rank;
@property (nonatomic, assign) long votes;
@property (nonatomic, assign) char sex;
@property (nonatomic, assign) double income;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSInteger flags;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSDate *birthdate;


- (BOOL)isEqualToPerson:(Person *)aPerson;

@end
