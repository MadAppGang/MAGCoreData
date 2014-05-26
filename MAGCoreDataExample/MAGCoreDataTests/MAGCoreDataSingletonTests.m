//
//  MAGCoreDataSingletonTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/25/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAGCoreData.h"

@interface MAGCoreDataSingletonTests : XCTestCase

@end

@implementation MAGCoreDataSingletonTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSingletonSharedInstanceCreated {
    XCTAssertNotNil([MAGCoreData instance]);
}

- (void)testSingletonUniqueInstanceCreated {
    XCTAssertNotNil([MAGCoreData new]);
}

- (void)testSingletonReturnsSameSharedInstance{
    XCTAssertEqual([MAGCoreData instance], [MAGCoreData instance]);
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    XCTAssertNotEqual([MAGCoreData instance], [MAGCoreData new]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    XCTAssertNotEqual([MAGCoreData new], [MAGCoreData new]);
}


@end
