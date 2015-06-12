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

- (void)testCoreDataCreationAndDeletion {
    NSURL *docDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *storeURL = [docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kStorageName]];
    
    [MAGCoreData deleteAllInStorageWithName:kStorageName];
    NSError *prepareError;
    BOOL prepareSuccess = [MAGCoreData prepareCoreDataWithModelName:@"Model" andStorageName:kStorageName error:&prepareError];
    expect(prepareError).to.beNil();
    expect(prepareSuccess).to.beTruthy();
    
    expect([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]).to.beTruthy();
    
    expect([MAGCoreData context]).toNot.beNil();
    expect([MAGCoreData createPrivateContext].persistentStoreCoordinator).toNot.beNil();
    
    expect([Weather create]).toNot.beNil();
    expect([Weather all].count).to.beTruthy();
    
    expect([MAGCoreData deleteAll]).to.beTruthy();
    expect([Weather all]).to.beNil();
    
    expect([MAGCoreData context]).to.beNil();
    expect([MAGCoreData createPrivateContext]).to.beNil();
    expect([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]).to.beFalsy();
}


#warning TODO::
//- (void)testStorageInitialization {
//    id classMock = [OCMockObject mockForClass:[MAGCoreData class]];
//    [[[classMock expect] classMethod] prepareCoreDataWithModelName:[OCMArg any] andStorageName:[OCMArg any] error:((NSError __autoreleasing **)[OCMArg anyPointer])];
//    [[[classMock expect] classMethod] deleteAllInStorageWithName:[OCMArg any]];
//
//    id objectMock = [OCMockObject partialMockForObject:[MAGCoreData instance]];
//    [[objectMock expect] close];
//
//    expect([[self class] createEmptyStorageWithModelName:nil andStorageName:kStorageName error:nil]).to.beTruthy();
//    expect([[self class] createEmptyStorageWithName:kStorageName]).to.beTruthy();
//    expect([[self class] setupStorageWithName:kStorageName]).to.beTruthy();
//    expect([[self class] dropStorage:kStorageName]).to.beTruthy();
//
//    [classMock verify];
//    [objectMock verify];
//}

@end
