//
//  MAGCoreData.h
//  MAGCoreDataExample
//
//  Created by Ievgen Rudenko on 8/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


#ifdef MAGCOREDATA_LOGGING_ENABLED
#define MAGCoreDataLog(frmt, ...) NSLog(frmt, ##__VA_ARGS__)
#else
#define MAGCoreDataLog(frmt, ...) ((void)0)
#endif

@interface MAGCoreData : NSObject

+ (instancetype)instance;

@property (nonatomic, assign) BOOL autoMergeFromChildContexts; //default is NO

#pragma mark - Initialisation
+ (NSError *)prepareCoreData;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;

#pragma mark - Management Object Context
+ (NSManagedObjectContext *)context; // Main Context
+ (NSManagedObjectContext *)createPrivateContext;

#pragma mark - Saving
+ (BOOL)save; // Save main context
+ (BOOL)saveContext:(NSManagedObjectContext *)context;

#pragma mark -
- (void)close;
+ (BOOL)deleteAll; // Delete all data from first persistent store in persistent store coordinator
+ (BOOL)deleteAllInStorageWithName:(NSString *)string;


#pragma mark - iCloud
/**
 Prepared default MAG Core Data stack with iCloud container.
 */
+ (NSError *)prepareICloudCoreData;
/**
 Migrates from iCloud store to local store.
 
 Use this method if user decided to disable iCloud in app. Call it if store is now
 managed as iCloud store. Otherwise it returns an error. Save any changes in current
 managed object context, before this call. Don't do any changes while migration is in progress.
 */
- (void)migrateFromICloudToLocalStoreWithCompletion:(void (^)(BOOL succeeded, NSError *error))completion;
/**
 Migrates from local store at specified url to iCloud store.
 
 User this method to seed existed local store data to iCloud container. Call it if store
 is now managed as local store. Otherwise it returns an error.
 Save any changes in current managed object context, before this call.
 Don't do any changes while migration is in progress.
 */
- (void)migrateFromLocalStoreAtUrl:(NSURL *)url toICloud:(void (^)(BOOL succeeded, NSError *error))completion;
/**
 Migrates from current local store to iCloud store. 
 
 Use this method if user decided to start using iCloud in the app.
 Call it if store is now managed as local store. Otherwise it returns an error.
 Save any changes in current managed object context, before this call.
 Don't do any changes while migration is in progress.
 */
- (void)migrateFromCurrentLocalStoreToICloud:(void (^)(BOOL succeeded, NSError *error))completion;
@end
