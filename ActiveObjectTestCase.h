//
//  ActiveObjectTestCase.h
//  OCActiveObjects
//
//  Created by Bhatti, Shahzad on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Person.h"


@interface ActiveObjectTestCase : SenTestCase {

}


- (void)setup;
- (void)teardown;
- (Person *)newPerson;
- (void)comparePerson:(Person *)person1 withPerson:(Person *)person2;
- (void)testSaveAndFind;
- (void)testCount;
- (void)testRemove;


@end
