//
//  MAGCoreDataTestCase.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@implementation MAGCoreDataTestCase

+ (void)setUp {
    [super setUp];
    
    [Expecta setAsynchronousTestTimeout:5.0f];
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

#pragma mark - Methods

- (void)testStorageInitialization {
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
}

+ (BOOL)createEmptyStorageWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error {
    [MAGCoreData deleteAllInStorageWithName:storageName];
    return [MAGCoreData prepareCoreDataWithModelName:modelName andStorageName:storageName error:error];
}

+ (BOOL)createEmptyStorageWithName:(NSString *)storageName {
    [MAGCoreData deleteAllInStorageWithName:storageName];
    return [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:storageName error:nil];
}

+ (BOOL)setupStorageWithName:(NSString *)storageName {
    return [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:storageName error:nil];
}

+ (BOOL)dropStorage:(NSString *)storageName {
    return [MAGCoreData deleteAllInStorageWithName:storageName];
}

@end
