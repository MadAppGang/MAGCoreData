//
//  MAGCoreDataFetchingObjectsTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataFetchingObjectsTests : MAGCoreDataTestCase

@end

@implementation MAGCoreDataFetchingObjectsTests

+ (void)setUp {
    [super setUp];
    [self createEmptyStorageWithName:NSStringFromClass([self class])];
}

+ (void)tearDown {
    [super tearDown];
    [self dropStorage:NSStringFromClass([self class])];
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFetchingObjects {

    [Weather create];
    [Weather create];
    [Weather create];
    XCTAssertTrue([Weather all].count == 3);
    
}

@end
