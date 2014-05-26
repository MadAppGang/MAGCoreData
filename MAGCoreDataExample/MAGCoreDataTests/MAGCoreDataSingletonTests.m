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
    expect([MAGCoreData new]).toNot.beNil();
}

- (void)testSingletonReturnsSameSharedInstance{
    expect([MAGCoreData instance]).to.equal([MAGCoreData instance]);
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    expect([MAGCoreData instance]).toNot.equal([MAGCoreData new]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    expect([MAGCoreData new]).toNot.equal([MAGCoreData new]);
}


@end
