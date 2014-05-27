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
}

+ (void)tearDown {
    [super tearDown];
}

- (void)setUp {
    [super setUp];
    
    [[self class] createEmptyStorageWithName:NSStringFromClass([self class])];
}

- (void)tearDown {
    [super tearDown];
    
    [[self class] dropStorage:NSStringFromClass([self class])];
}

- (void)testFetchingObjects {
    [Weather create];
    [Weather create];
    [Weather create];
    NSArray *arr = [Weather all];
    expect(arr.count == 3).to.beTruthy();
}

@end
