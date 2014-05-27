//
//  MAGCoreDataSingletonTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/25/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataSingletonTests : MAGCoreDataTestCase

@end

@implementation MAGCoreDataSingletonTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSingletonSharedInstanceCreated {
    expect([MAGCoreData instance]).toNot.beNil();
}

- (void)testSingletonUniqueInstanceCreated {
    expect([MAGCoreData instance]).to.beIdenticalTo([MAGCoreData instance]);
}


@end
