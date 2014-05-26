//
//  MAGCoreDataPrepareTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/25/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAGCoreData.h"

@interface MAGCoreDataPrepareTests : XCTestCase

@end

@implementation MAGCoreDataPrepareTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrepareDefaultCoreData {
    NSError *error = [MAGCoreData prepareCoreData];
    XCTAssertNil(error);
}

- (void)testInitializationAndDeletionWithModelName {
    NSString *modelName = @"Model";
    NSError *error;
    XCTAssertTrue([MAGCoreData prepareCoreDataWithModelName:modelName error:&error]);
    XCTAssertTrue([MAGCoreData deleteStorage]);
}

- (void)testInitializationAndDeletionWithModelNameAndStorageName {
    NSString *storageName = [NSString stringWithFormat:@"TestStorage%f", [NSDate date].timeIntervalSince1970];
    NSString *modelName = @"Model";
    NSError *error;
    XCTAssertTrue([MAGCoreData prepareCoreDataWithModelName:modelName andStorageName:storageName error:&error]);
    XCTAssertTrue([MAGCoreData deleteStorageWithName:storageName]);
}

- (void)testContextCreatedSuccessfuly {
    [MAGCoreData prepareCoreData];
    XCTAssertNotNil([MAGCoreData context]);
}

- (void)testPrivateContextCreatedSuccessfuly {
    [MAGCoreData prepareCoreData];
    XCTAssertNotNil([MAGCoreData createPrivateContext]);
}

@end
