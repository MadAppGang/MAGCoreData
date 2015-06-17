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
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGettingObject {
    id mock = [OCMockObject mockForClass:[NSManagedObjectContext class]];    

    [[mock expect] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [Weather allInContext:mock];
    
    [[mock expect] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [Weather allForPredicate:nil orderBy:nil ascending:YES inContext:mock];

    [[mock expect] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [Weather allOrderedBy:nil ascending:YES inContext:mock];
    
    [[mock expect] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [Weather firstForPredicate:nil orderBy:nil ascending:NO inContext:mock];
    
    [[mock expect] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [Weather firstInContext:mock];
    
    [mock verify];
}

@end
