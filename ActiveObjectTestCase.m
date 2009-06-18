//
//  ActiveObjectTestCase.m
//  OCActiveObjects
//
//  Created by Bhatti, Shahzad on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActiveObjectTestCase.h"


@implementation ActiveObjectTestCase

- (void)setup {
	[Person openDatabase];
}

- (void)teardown {
	[Person closeDatabase];
}


- (Person *)newPerson {
	Person *person = [[[Person alloc] init] autorelease];
	person.birthdate = [[NSDate alloc]init];
	int random = [person.birthdate timeIntervalSince1970];
	person.age =  random % 30;
	person.rank = random % 20;
	person.votes = random % 10;
	person.sex = 'M';
	person.name = [NSString stringWithFormat:@"Joe #%d", random % 1000];
	person.income = random % 3000;
	person.active = TRUE;
	person.flags = random % 30 + 0.5;
	person.rating = [NSNumber numberWithInt:20.5];	
	return person;
}

- (void)assertPerson:(Person *)person1 equalsToPerson:(Person *)person2 {
	STAssertEquals(person1.age, person2.age, @"age didn't match");	
	STAssertEquals([person1.birthdate timeIntervalSince1970], [person2.birthdate timeIntervalSince1970], @"birthdate didn't match");
	STAssertEquals(person1.rank, person2.rank, @"rank didn't match");	
	STAssertEquals(person1.votes, person2.votes, @"votes didn't match");	
	STAssertEquals(person1.sex, person2.sex, @"sex didn't match");	
	STAssertEqualObjects(person1.name, person2.name, @"name didn't match");	
	STAssertEquals(person1.income, person2.income, @"income didn't match");	
	STAssertEquals(person1.active, person2.active, @"active didn't match");	
	STAssertEquals(person1.flags, person2.flags, @"flags didn't match");	
	STAssertEqualObjects(person1.rating, person2.rating, @"rating didn't match");
}


- (void)testSaveAndFind {
	//[Person removeAll];

	Person *person1 = [self newPerson];
	[person1 save];
/*	
	Person *person2 = (Person *) [Person findByPrimaryKey:person1.objectId];
	[self comparePerson:person1 withPerson:person2];
	 */
}


- (void)testUpdateAndFind {
	/*
	[Person removeAll];
	
	Person *person = [self newPerson];
	[person save];
	
	int count = [Person countAll];
	if (count != 1) {
		NSLog(@"unexpected count %d", count);
	}
	
	NSNumber *oldId = person.objectId;
	
	[person save];
	if (person.objectId != oldId) {
		NSLog(@"unexpected object id %@", person.objectId);
	}
	count = [Person countAll];
	if (count != 1) {
		NSLog(@"unexpected count %d", count);
	}
	*/
}



- (void)testSaveAndFindAll {
	/*
	[Person removeAll];
	
	Person *person1 = [self newPerson];
	[person1 save];
	
	Person *person2 = [self newPerson];
	[person2 save];
	
	Person *person3 = [self newPerson];
	[person3 save];
	
	NSArray* persons = [Person findAll];
	if ([persons count] != 3) {
		NSLog(@"count not 3 %d", [persons count]);
	}
	
	if (![persons containsObject:person1]) {
		NSLog(@"count not 3 %d", [persons count]);
	}
	
	if (![persons containsObject:person2]) {
		NSLog(@"count not 3 %d", [persons count]);
	}
	
	if (![persons containsObject:person3]) {
		NSLog(@"count not 3 %d", [persons count]);
	}
	*/
}


- (void)testCount {
	/*
	[Person removeAll];
	
	Person *person1 = [self newPerson];
	[person1 save];
	
	Person *person2 = [self newPerson];
	[person2 save];
	
	NSDictionary *criteria = [NSDictionary dictionaryWithObjectsAndKeys:person1.objectId, @"objectId", nil];	
	int count = [Person countWithCriteria:criteria];
	if (count != 1) {
		NSLog(@"unexpected count %d", count);
	}
	count = [Person countAll];
	if (count != 2) {
		NSLog(@"unexpected count %d", count);
	}
	 */
}


- (void)testRemove {
	/*
	[Person removeAll];
	
	Person *person1 = [self newPerson];
	[person1 save];
	
	int count = [Person countAll];
	if (count != 1) {
		NSLog(@"unexpected count %d", count);
	}
	
	
	NSLog(@"find all %@\n\n", [Person findAll]);
	
	Person *person2 = (Person *) [Person findByPrimaryKey:person1.objectId];
	
	count = [Person removeWithCriteria: [[[NSDictionary alloc] initWithObjectsAndKeys:person1.objectId, @"objectId", nil] autorelease]];
	if (count != 1) {
		NSLog(@"unexpected count %d", count);
	}
	
	@try {
		person2 = (Person *) [Person findByPrimaryKey:person1.objectId];
		if (person2 != nil) {
			NSLog(@"unexpected person %@", person2);
		}		
	} 
	@catch (NSException *e) {
	} 
	@finally {
	}
	 */
}


@end
