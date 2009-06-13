//
//  ActiveObjectTest.h
//  OCActiveObjects
//
//  Created by shahzad bhatti on 6/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"


@interface ActiveObjectTest : NSObject {
	
}

- (void)setup;
- (void)teardown;
- (Person *)newPerson;
- (void)comparePerson:(Person *)person1 withPerson:(Person *)person2;
- (void)testSaveAndFind;
- (void)testCount;
- (void)testRemove;

@end
