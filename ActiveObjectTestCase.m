//
//  ActiveObjectTestCase.m
//  OCActiveObjects
//
//  Created by Bhatti, Shahzad on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActiveObjectTestCase.h"


@implementation ActiveObjectTestCase


- (void)testTestFramework
{
    NSString *string1 = @"test";
    NSString *string2 = @"test";
    STAssertEquals(string1,
                   string2,
                   @"FAILURE");
    NSUInteger uint_1 = 4;
    NSUInteger uint_2 = 4;
    STAssertEquals(uint_1,
                   uint_2,
                   @"FAILURE");
}


@end
