//
//  MAGCoreDataPrepareTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/25/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataPrepareTests : MAGCoreDataTestCase

@end

@implementation MAGCoreDataPrepareTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCoreDataCreationAndDeletion {
    XCTAssertNil([MAGCoreData prepareCoreData]);
    XCTAssertTrue([MAGCoreData deleteStorage]);
    
    XCTAssertTrue([MAGCoreData prepareCoreDataWithModelName:@"Model" error:nil]);
    XCTAssertTrue([MAGCoreData deleteStorage]);
    
    XCTAssertTrue([[self class] createEmptyStorageWithModelName:@"Model" andStorageName:kStorageName error:nil]);
    XCTAssertTrue([[self class] dropStorage:kStorageName]);
}

- (void)testContextCreatedSuccessfuly {
    [[self class] createEmptyStorageWithName:kStorageName];
    XCTAssertNotNil([MAGCoreData context]);
    XCTAssertTrue([[self class] dropStorage:kStorageName]);
}

- (void)testPrivateContextCreatedSuccessfuly {
    [[self class] createEmptyStorageWithName:kStorageName];
    XCTAssertNotNil([MAGCoreData createPrivateContext]);
    XCTAssertTrue([[self class] dropStorage:kStorageName]);
}

@end
