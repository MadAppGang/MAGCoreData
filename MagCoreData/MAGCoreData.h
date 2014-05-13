//
//  MAGCoreData.h
//  MAGCoreDataExample
//
//  Created by Ievgen Rudenko on 8/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGCoreData : NSObject

+ (instancetype)instance;

@property (nonatomic) BOOL autoMergeFromChildContexts;

+ (NSError *)prepareCoreData;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;

+ (NSManagedObjectContext *)context;
+ (NSManagedObjectContext *)createPrivateContext;

+ (void)save;
+ (void)saveContext:(NSManagedObjectContext*)context;

- (void)close;
+ (void)deleteStorage;
+ (void)deleteStorageWithName:(NSString *)storageName;


#pragma mark - Delete all data from first persistent store in persistent store coordinator
+ (void)deleteAll __attribute__((deprecated));

#pragma mark - Fetching managed objects

@end
