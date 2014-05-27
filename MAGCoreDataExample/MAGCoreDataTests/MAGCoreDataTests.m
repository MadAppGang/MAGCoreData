//
//  MAGCoreDataTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataTests : MAGCoreDataTestCase

@end

@implementation MAGCoreDataTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUnicornMagic {
    expect(@"unicorn and magic").toNot.beNil;
}

@end
