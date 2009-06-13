//
//  Person.m
//  PlexLotto
//
//  Created by shahzad bhatti on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person
@synthesize name;
@synthesize age;
@synthesize rank;
@synthesize votes;
@synthesize sex;
@synthesize income;
@synthesize active;
@synthesize flags;
@synthesize rating;
@synthesize birthdate;


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPerson:other];
}

- (BOOL)isEqualToPerson:(Person *)aPerson {
	if (self == aPerson)
        return YES;
    if (![(id)[self name] isEqual:[aPerson name]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = 0;
	hash += [[self name] hash];
	return hash;
}



- (NSString *)description {
	return [NSString stringWithFormat:@"id %@, name %@, age %d, rank %d, votes %d, sex %c, income %f, active %d, flags %d, rating %@, birthdate %@", 
			self.objectId, self.name, self.age, self.rank, self.votes, self.sex, self.income, self.active, self.flags, self.rating, self.birthdate];
}


- (void) dealloc {
	[birthdate release];
	[super dealloc];
}


+ (NSString	*) getTableName {
	return @"persons";
}

+ (NSString	*) getDatabaseName {
	return @"personsdb";
}

@end
