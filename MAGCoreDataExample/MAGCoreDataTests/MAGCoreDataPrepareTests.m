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
    expect([MAGCoreData prepareCoreData]).toNot.beNil();
    expect([MAGCoreData deleteStorage]).to.beTruthy();
    
    expect([MAGCoreData prepareCoreDataWithModelName:@"Model" error:nil]).to.beTruthy();
    expect([MAGCoreData deleteStorage]).to.beTruthy();
    
    expect([[self class] createEmptyStorageWithModelName:@"Model" andStorageName:kStorageName error:nil]).to.beTruthy();
    expect([[self class] dropStorage:kStorageName]).to.beTruthy();
}

- (void)testContextCreatedSuccessfuly {
    [[self class] createEmptyStorageWithName:kStorageName];
    expect([MAGCoreData context]).toNot.beNil();
    expect([[self class] dropStorage:kStorageName]).to.beTruthy();
}

- (void)testPrivateContextCreatedSuccessfuly {
    [[self class] createEmptyStorageWithName:kStorageName];
    expect([MAGCoreData createPrivateContext]).toNot.beNil();
    expect([[self class] dropStorage:kStorageName]).to.beTruthy();
}

@end
