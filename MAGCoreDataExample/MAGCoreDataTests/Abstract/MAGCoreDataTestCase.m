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
    
    [Expecta setAsynchronousTestTimeout:2.0f];
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

+ (BOOL)createEmptyStorageWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error {
    [MAGCoreData deleteStorageWithName:storageName];
    return [MAGCoreData prepareCoreDataWithModelName:modelName andStorageName:storageName error:error];
}

+ (BOOL)createEmptyStorageWithName:(NSString *)storageName {
    [MAGCoreData deleteStorageWithName:storageName];
    return [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:storageName error:nil];
}

+ (BOOL)setupStorageWithName:(NSString *)storageName {
    return [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:storageName error:nil];
}

+ (BOOL)dropStorage:(NSString *)storageName {
    return [MAGCoreData deleteStorageWithName:storageName];
}

@end
