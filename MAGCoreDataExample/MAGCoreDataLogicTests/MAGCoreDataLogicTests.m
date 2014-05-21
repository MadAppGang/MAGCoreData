//
//  MAGCoreDataLogicTests.m
//  MAGCoreDataLogicTests
//
//  Created by Sergii Kostanian on 5/21/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAGCoreData.h"

@interface MAGCoreDataLogicTests : XCTestCase

@end

@implementation MAGCoreDataLogicTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreatingSingletonInstance {
    XCTAssertNotNil([MAGCoreData instance]);
}

- (void)testCreatingSingletonInstanceOnce {
    XCTAssertEqual([MAGCoreData instance], [MAGCoreData instance]);
}


@end
