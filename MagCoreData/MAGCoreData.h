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

@property (nonatomic) BOOL autoMergeFromChildContexts; //default is NO

#pragma mark - Initialisation
+ (NSError *)prepareCoreData;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;

#pragma mark - Management Object Context
+ (NSManagedObjectContext *)context; // Main Context
+ (NSManagedObjectContext *)createPrivateContext;

#pragma mark - Saving
+ (void)save; // Save main context
+ (void)saveContext:(NSManagedObjectContext *)context;

#pragma mark -
- (void)close;
+ (BOOL)deleteStorage;
+ (BOOL)deleteStorageWithName:(NSString *)storageName;


#pragma mark - Delete all data from first persistent store in persistent store coordinator
+ (void)deleteAll __attribute__((deprecated));

#pragma mark - Fetching managed objects

@end
