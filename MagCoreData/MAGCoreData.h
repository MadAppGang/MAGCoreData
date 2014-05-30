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

//default is NO
@property (nonatomic) BOOL autoMergeFromChildContexts;

#pragma mark - Initialisation
+ (NSError *)prepareCoreData;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString*)storageName error:(NSError **)error;
- (void)close;

#pragma mark - Management Object Context
//Main Context
+ (NSManagedObjectContext *)context;
+ (NSManagedObjectContext *)createPrivateContext;

#pragma mark -  save main context
+ (void)save;
+ (void)saveContext:(NSManagedObjectContext*)context;

#pragma mark - Delete all data from first persistent store in persistent store coordinator
+ (void)deleteAll;

#pragma mark - Fetching managed objects

@end
