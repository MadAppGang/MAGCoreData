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
                                                      usingBlock:^(NSNotification *notification){
                                                          if (notification.object == self.mainContext) return;
                                                          [self.mainContext performBlock:^{
                                                              [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
                                                          }];
                                                      }];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


+ (NSError *)prepareCoreData {
    NSError *error = nil;
    [self prepareCoreDataWithModelName:nil andStorageName:nil error:&error];
    return error;
}

+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error {
    return [self prepareCoreDataWithModelName:modelName andStorageName:nil error:error];
}

+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error {
    if ([[MAGCoreData instance] mainContext]) return YES;

    MAGCoreData *mag = [MAGCoreData instance];
    if (modelName) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:storageName withExtension:@"momd"];
        mag.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }   else {
        mag.model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }

    mag.persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mag.model];
    NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = storageName?[docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",storageName]]:
                                  [docDir URLByAppendingPathComponent:@"MAGStore.sqlite"];
    NSDictionary *options = @{  NSMigratePersistentStoresAutomaticallyOption:@(YES),
                                NSInferMappingModelAutomaticallyOption:@(YES)};
    if (![mag.persistentStore addPersistentStoreWithType:NSSQLiteStoreType
                                           configuration:nil
                                                     URL:storeURL
                                                 options:options
                                                   error:error]) {
        NSLog(@"!!!MAGCoreData: Error creating persistent store:%@",*error);
        return NO;
    }
    mag.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mag.mainContext.persistentStoreCoordinator = mag.persistentStore;
    return YES;
}

- (void)close {
    self.mainContext = nil;
    self.model = nil;
    self.persistentStore = nil;
}

+ (NSManagedObjectContext *)context {
    return [[MAGCoreData instance] mainContext];
}

+ (NSManagedObjectContext *)createPrivateContext {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    moc.persistentStoreCoordinator = [[MAGCoreData instance] persistentStore];
    return moc;
}

+ (void)save {
    [MAGCoreData saveContext:[MAGCoreData context]];
}

+ (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSArray* detailedErrors = [error userInfo][NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NSLog(@"MAGCoreData  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"MAGCoreData %@", [error userInfo]);
        }
    }

}

+ (void)deleteAll {
    //assume we use only one persistent store
    NSURL *storeURL = [[[[MAGCoreData instance] persistentStore] persistentStores][0] URL];
    [[MAGCoreData instance] close];
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
    } @catch (NSException *exception) {
        // ignore, totally normal
    }
}


@end
