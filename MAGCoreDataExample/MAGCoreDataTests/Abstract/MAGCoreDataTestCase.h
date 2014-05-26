//
//  MAGCoreDataTestCase.h
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "MAGCoreData.h"
#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"

#define kStorageName NSStringFromSelector(_cmd)

@interface MAGCoreDataTestCase : XCTestCase

+ (BOOL)createEmptyStorageWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;
+ (BOOL)createEmptyStorageWithName:(NSString *)storageName;
+ (BOOL)setupStorageWithName:(NSString *)storageName;
+ (BOOL)dropStorage:(NSString *)storageName;

@end
