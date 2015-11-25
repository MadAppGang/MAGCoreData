//
//  MAGCoreData.m
//  MAGCoreDataExample
//
//  Created by Ievgen Rudenko on 8/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MAGCoreData.h"

@interface MAGCoreData ()

@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStore;

@end


@implementation MAGCoreData

+ (instancetype)instance {
    static dispatch_once_t once;
    static MAGCoreData *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        MAGCoreDataLog(@"Singleton instance created");
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoMergeFromChildContexts = NO;
    }
    return self;
}

- (void)setAutoMergeFromChildContexts:(BOOL)autoMergeFromChildContexts {
    if (self.autoMergeFromChildContexts == autoMergeFromChildContexts) return;
    _autoMergeFromChildContexts = autoMergeFromChildContexts;
    if (self.autoMergeFromChildContexts) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *notification) {
                                                          
                                                          NSManagedObjectContext *context = notification.object;
                                                          
                                                          if (context == self.mainContext || context.persistentStoreCoordinator != self.persistentStore) {
                                                                return;   
                                                          }
                                                          
                                                          [self.mainContext performBlock:^{
                                                              [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
                                                          }];
                                                      }];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

+ (NSURL *)defaultStorageURLWithName:(NSString *)storageName {
    NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = storageName ? [docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",storageName]] : [docDir URLByAppendingPathComponent:@"MAGStore.sqlite"];
    return storeURL;
}


+ (NSError *)prepareCoreData {
    NSError *error;
    [self prepareCoreDataWithModelName:nil andStorageName:nil error:&error];
    return error;
}

+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error {
    return [self prepareCoreDataWithModelName:modelName andStorageName:nil error:error];
}

+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error {
    if ([[MAGCoreData instance] mainContext]) return NO;

    MAGCoreData *mag = [MAGCoreData instance];
    if (modelName) {
        NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:modelName withExtension:@"momd"];
        mag.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }   else {
        mag.model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }

    mag.persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mag.model];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)};
    if (![mag.persistentStore addPersistentStoreWithType:NSSQLiteStoreType
                                           configuration:nil
                                                     URL:[self defaultStorageURLWithName:storageName]
                                                 options:options
                                                   error:error]) {
        NSLog(@"MAGCoreData: Error creating persistent store:%@", *error);
        return NO;
    }
    mag.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mag.mainContext.persistentStoreCoordinator = mag.persistentStore;
    
    return YES;
}

+ (NSManagedObjectContext *)context {
    return [[MAGCoreData instance] mainContext];
}

+ (NSManagedObjectContext *)createPrivateContext {
    if (![MAGCoreData instance].mainContext) return nil;
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    moc.persistentStoreCoordinator = [[MAGCoreData instance] persistentStore];
    return moc;
}

+ (BOOL)save {
    return [MAGCoreData saveContext:[MAGCoreData context]];
}

+ (BOOL)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSArray *detailedErrors = [error userInfo][NSDetailedErrorsKey];
        if (detailedErrors.count) {
            for (NSError *detailedError in detailedErrors) {
                NSLog(@"MAGCoreData DetailedError: %@", detailedError.userInfo);
            }
        } else {
            NSLog(@"MAGCoreData %@", error.userInfo);
        }
        return NO;
    } else {
        return YES;
    }

}

- (void)close {
    self.mainContext = nil;
    self.model = nil;
    self.persistentStore = nil;
}

+ (BOOL)removeStoreAtPath:(NSURL *)storeURL {
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)deleteAll {
    //assume we use only one persistent store
    NSURL *storeURL = [[[[MAGCoreData instance] persistentStore] persistentStores][0] URL];
    [[MAGCoreData instance] close];
    return [MAGCoreData removeStoreAtPath:storeURL];
}

+ (BOOL)deleteAllInStorageWithName:(NSString *)storageName {
    [[MAGCoreData instance] close];
    return [MAGCoreData removeStoreAtPath:[self defaultStorageURLWithName:storageName]];
}


@end
