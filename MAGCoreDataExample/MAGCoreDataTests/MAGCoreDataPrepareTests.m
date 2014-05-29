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
    NSError *prepareError;
    BOOL prepareSuccess = [MAGCoreData prepareCoreDataWithModelName:@"Model" andStorageName:kStorageName error:&prepareError];
    expect(prepareError).to.beNil();
    expect(prepareSuccess).to.beTruthy();
    
    expect([MAGCoreData context]).toNot.beNil();
    expect([MAGCoreData createPrivateContext].persistentStoreCoordinator).toNot.beNil();
    
    expect([MAGCoreData deleteAll]).to.beTruthy();
    
    expect([MAGCoreData context]).to.beNil();
    expect([MAGCoreData createPrivateContext]).to.beNil();
}

@end
