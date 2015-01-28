//
//  MAGCoreData.m
//  MAGCoreDataExample
//
//  Created by Ievgen Rudenko on 8/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MAGCoreData.h"


static NSString *const MAGGoreDataICloudStoreWillAddedNotification = @"MAGGoreDataICloudStoreWillAddedNotification";
static NSString *const MAGGoreDataICloudStoreDidAddNotification = @"MAGGoreDataICloudStoreDidAddNotification";
static NSString *const MAGGoreDataICloudStoreAddFailedNotification = @"MAGGoreDataICloudStoreAddFailedNotification";

static NSString *const MAGGoreDataICloudStoreWillRemovedNotification = @"MAGGoreDataICloudStoreWillRemovedNotification";
static NSString *const MAGGoreDataICloudStoreDidRemovedNotification = @"MAGGoreDataICloudStoreDidRemovedNotification";
static NSString *const MAGGoreDataICloudStoreRemoveFailedNotification = @"MAGGoreDataICloudStoreRemoveFailedNotification";

static NSString *const MAGGoreDataICloudStoreWillCleanedNotification = @"MAGGoreDataICloudStoreWillCleanedNotification";
static NSString *const MAGGoreDataICloudStoreDidCleanNotification = @"MAGGoreDataICloudStoreDidCleanNotification";


static NSString *const MAGCoreDataErrorDomain = @"MAGCoreDataErrorDomain";
static NSString *const MAGCoreDataDefaultStoreName = @"MAGStore";
static NSString *const MAGCoreDataDefaultICloudStoreName = @"iCloudMAGStore";

static NSString *const MAGCoreDataStoreLocalConfName = @"Local";
static NSString *const MAGCoreDataStoreICloudConfName = @"iCloud";


typedef NS_ENUM(NSInteger, MAGCoreDataStoreType) {
    MAGCoreDataStoreTypeUnknown = 0,
    MAGCoreDataStoreTypeLocal,
    MAGCoreDataStoreTypeICloud
};



@interface MAGCoreData ()

@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@property (nonatomic, strong) id autoMergeFromChildsObserver;

@property (nonatomic, strong) id iCloudStoresWillChangeObserver;
@property (nonatomic, strong) id iCloudStoresDidChangeObserver;
@property (nonatomic, strong) id iCloudContentChangeObserver;

@property (nonatomic, assign) MAGCoreDataStoreType currentStoreType;
@property (nonatomic, strong) NSURL *currentStoreUrl;
@property (nonatomic, copy) NSString *currentStoreName;
@property (nonatomic, strong) NSOperationQueue *cloudMigrationsQueue;

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
        _currentStoreType = MAGCoreDataStoreTypeUnknown;
        _currentStoreName = nil;
        _autoMergeFromChildContexts = NO;
        _cloudMigrationsQueue = [NSOperationQueue new];
        _cloudMigrationsQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)setAutoMergeFromChildContexts:(BOOL)autoMergeFromChildContexts {
    if (_autoMergeFromChildContexts == autoMergeFromChildContexts) {
        return;
    }
    _autoMergeFromChildContexts = autoMergeFromChildContexts;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (_autoMergeFromChildContexts) {
        if (!self.autoMergeFromChildsObserver) {
            self.autoMergeFromChildsObserver = [nc addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                
                NSManagedObjectContext *context = note.object;
                if (context == self.mainContext || context.persistentStoreCoordinator != self.coordinator) {
                    return;
                }
                [self.mainContext performBlock:^{
                    [self.mainContext mergeChangesFromContextDidSaveNotification:note];
                }];
                
            }];
        }
    } else {
        if (self.autoMergeFromChildsObserver) {
            [nc removeObserver:self.autoMergeFromChildsObserver];
            self.autoMergeFromChildsObserver = nil;
        }
    }
}

+ (NSURL *)defaultStorageURLWithName:(NSString *)storageName {
    NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    if (!storageName) {
        storageName = [self defaultStoreName];
    }
    NSURL *storeURL = [docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storageName]];
    return storeURL;
}


+ (NSString *)defaultStoreName {
    return MAGCoreDataDefaultStoreName;
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
    return [self prepareCoreDataWithModelName:modelName andStorageName:storageName error:error withICloudSupport:NO];
}


+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error withICloudSupport:(BOOL)withICloudSupport {
    
    MAGCoreData *mag = [MAGCoreData instance];
    if (mag.mainContext)  {
        return NO;
    }
    
    if ([storageName length] == 0) {
        storageName = [self defaultStoreName];
    }
    mag.currentStoreName = storageName;
    mag.currentStoreUrl = [self defaultStorageURLWithName:mag.currentStoreName];
    
    if (modelName) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        mag.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }   else {
        mag.model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    [mag unsubscribeFromICloudNotifications];
    mag.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mag.model];
    
    NSMutableDictionary *options = [[self defaultStoreOptions] mutableCopy];
    if (withICloudSupport) {
        mag.currentStoreType = MAGCoreDataStoreTypeICloud;
        [options setObject:MAGCoreDataDefaultICloudStoreName forKey:NSPersistentStoreUbiquitousContentNameKey];
        [mag subscribeForICloudNotifications];
    } else {
        mag.currentStoreType = MAGCoreDataStoreTypeLocal;
    }
    
    NSString *configuration = withICloudSupport ? MAGCoreDataStoreICloudConfName : MAGCoreDataStoreLocalConfName;
    if ([mag.coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:mag.currentStoreUrl options:options error:error]) {
        
        mag.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        mag.mainContext.persistentStoreCoordinator = mag.coordinator;
        
        return YES;
    } else  {
        return NO;
    }
}


+ (NSManagedObjectContext *)context {
    return [[MAGCoreData instance] mainContext];
}

+ (NSManagedObjectContext *)createPrivateContext {
    if (![MAGCoreData instance].mainContext) return nil;
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    moc.persistentStoreCoordinator = [[MAGCoreData instance] coordinator];
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
    [self unsubscribeFromICloudNotifications];
    self.mainContext = nil;
    self.model = nil;
    self.coordinator = nil;
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
    NSURL *storeURL = [[[[MAGCoreData instance] coordinator] persistentStores][0] URL];
    [[MAGCoreData instance] close];
    return [MAGCoreData removeStoreAtPath:storeURL];
}

+ (BOOL)deleteAllInStorageWithName:(NSString *)storageName {
    [[MAGCoreData instance] close];
    return [MAGCoreData removeStoreAtPath:[self defaultStorageURLWithName:storageName]];
}


#pragma mark - Private

+ (NSDictionary *)defaultStoreOptions {
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:@YES forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:@YES forKey:NSInferMappingModelAutomaticallyOption];
    return options;
}


#pragma mark - iCloud

// TODO: Check if reall
// need use #import <CloudKit/CloudKit.h>
//+ (void)checkICloudDriveEnabledCompletion:(void (^)(BOOL enabled))completion {
//    if (NSClassFromString(@"CKContainer") != nil) { // iOS 8 required
//        CKContainer *container = [CKContainer defaultContainer];
//        [container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
//            BOOL isICloudDriveEnabled = NO;
//            switch (accountStatus) {
//                case CKAccountStatusCouldNotDetermine:
//                    isICloudDriveEnabled = NO;
//                    break;
//                case CKAccountStatusAvailable:
//                    isICloudDriveEnabled = YES;
//                    break;
//                case CKAccountStatusRestricted:
//                    isICloudDriveEnabled = NO;
//                    break;
//                case CKAccountStatusNoAccount:
//                    isICloudDriveEnabled = NO;
//                    break;
//                default:
//                    break;
//            }
//            if (completion) {
//                completion(isICloudDriveEnabled);
//            }
//        }];
//    } else {
//        if (completion) {
//            completion(NO);
//        }
//    }
//}

+ (NSError *)prepareICloudCoreData {
    NSError *error = nil;
    [self prepareCoreDataWithModelName:nil andStorageName:nil error:&error withICloudSupport:YES];
    return error;
}


- (void)migrateFromICloudToLocalStoreWithCompletion:(void (^)(BOOL succeeded, NSError *error))completion {
    
    if (self.currentStoreType != MAGCoreDataStoreTypeICloud) {
        NSError *error = [[self class] errorWithMessage:@"Current store is not iCloud managed"];
        if (completion) {
            completion(NO, error);
        }
        return;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.coordinator;
    NSPersistentStore *iCloudStore = [[coordinator persistentStores] firstObject];
    if (!iCloudStore) {
        NSError *error = [[self class] errorWithMessage:@"Can't find current store"];
        if (completion) {
            completion(NO, error);
        }
        return;
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:MAGGoreDataICloudStoreWillRemovedNotification object:nil userInfo:@{}];
    
    self.currentStoreType = MAGCoreDataStoreTypeUnknown;
    [self saveIfNeededAndResetMainContext];
    [self unsubscribeFromICloudNotifications];
    
    NSMutableDictionary *migrateOptions = [[[self class] defaultStoreOptions] mutableCopy];
    [migrateOptions setObject:@YES forKey:NSPersistentStoreRemoveUbiquitousMetadataOption];
    NSURL *localStoreUrl = [[self class] defaultStorageURLWithName:self.currentStoreName];
    
    [self.cloudMigrationsQueue addOperationWithBlock:^{
        
        NSError *migrationError = nil;
        NSPersistentStore *localStore = [coordinator migratePersistentStore:iCloudStore toURL:localStoreUrl options:migrateOptions withType:NSSQLiteStoreType error:&migrationError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL migratedSucceeded = YES;
            if (migrationError) {
                migratedSucceeded = NO;
                if (completion) {
                    completion(NO, migrationError);
                }
            }  else {
                [coordinator removePersistentStore:localStore error:nil];
                NSDictionary *localStoreOptions = [[self class] defaultStoreOptions];
                NSError *addLocalStoreError = nil;
                if ([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:MAGCoreDataStoreLocalConfName URL:localStoreUrl options:localStoreOptions error:&addLocalStoreError]) {
                    
                    self.currentStoreType = MAGCoreDataStoreTypeLocal;
                    
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    migratedSucceeded = NO;
                    if (completion) {
                        completion(NO, addLocalStoreError);
                    }
                }
            }
            NSString *notification = MAGGoreDataICloudStoreDidRemovedNotification;
            if (!migratedSucceeded) {
                notification = MAGGoreDataICloudStoreRemoveFailedNotification;
            }
            [nc postNotificationName:notification object:nil];
        });
    }];
}

- (void)migrateFromLocalStoreAtUrl:(NSURL *)url toICloud:(void (^)(BOOL succeeded, NSError *error))completion {
    if (self.currentStoreType != MAGCoreDataStoreTypeLocal) {
        NSError *error = [[self class] errorWithMessage:@"Current store is not locally managed"];
        if (completion) {
            completion(NO, error);
        }
        return;
    }
    
    NSError *seedStoreError = nil;
    NSPersistentStoreCoordinator *coordinator = self.coordinator;
    
    // Firstly check if store is already added
    NSPersistentStore *localStore = nil;
    NSArray *stores = coordinator.persistentStores;
    for (NSPersistentStore *store in stores) {
        if ([[store.URL absoluteString] isEqualToString:[url absoluteString]] &&
            [store.type isEqualToString:NSSQLiteStoreType]) {
            localStore = store;
            break;
        }
    }
    if (!localStore) {
        // Add readonly store to migrate from
        NSDictionary *localStoreOptions = @{ NSReadOnlyPersistentStoreOption: @YES };
        localStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:localStoreOptions error:&seedStoreError];
        if (!localStore) {
            NSError *error = [[self class] errorWithMessage:[NSString stringWithFormat:@"Can't create seed store at url %@ (error: %@)", url, seedStoreError]];
            if (completion) {
                completion(NO, error);
            }
            return;
        }
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:MAGGoreDataICloudStoreWillAddedNotification object:nil userInfo:@{}];
    
    self.currentStoreType = MAGCoreDataStoreTypeUnknown;
    [self saveIfNeededAndResetMainContext];
    [self subscribeForICloudNotifications];
    
    NSMutableDictionary *iCloudOptions = [[[self class] defaultStoreOptions] mutableCopy];
    [iCloudOptions setObject:MAGCoreDataDefaultICloudStoreName forKey:NSPersistentStoreUbiquitousContentNameKey];
    
    [self.cloudMigrationsQueue addOperationWithBlock:^{
        
        NSError *migrationError = nil;
        NSPersistentStore *iCloudStore = [coordinator migratePersistentStore:localStore toURL:url options:iCloudOptions withType:NSSQLiteStoreType error:&migrationError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL migratedSucceeded = YES;
            if (migrationError) {
                migratedSucceeded = NO;
                if (completion) {
                    completion(NO, migrationError);
                }
            }  else {
                [coordinator removePersistentStore:iCloudStore error:nil];
                NSError *addStoreError = nil;
                if ([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:MAGCoreDataStoreICloudConfName URL:url options:iCloudOptions error:&addStoreError]) {
                    
                    self.currentStoreType = MAGCoreDataStoreTypeICloud;
                    
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    migratedSucceeded = NO;
                    if (completion) {
                        completion(NO, addStoreError);
                    }
                }
            }
            NSString *notification = MAGGoreDataICloudStoreWillAddedNotification;
            if (!migratedSucceeded) {
                notification = MAGGoreDataICloudStoreAddFailedNotification;
            }
            [nc postNotificationName:notification object:nil];
        });
        
        
    }];
}

- (void)migrateFromCurrentLocalStoreToICloud:(void (^)(BOOL succeeded, NSError *error))completion {
    [self migrateFromLocalStoreAtUrl:self.currentStoreUrl toICloud:completion];
}



- (void)iCloudStoresWillChange:(NSNotification *)n {
    NSNumber *transitionType = [n.userInfo objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    if (transitionType) {
        NSString *notificationName = nil;
        switch ([transitionType integerValue]) {
            case NSPersistentStoreUbiquitousTransitionTypeAccountAdded:
                notificationName = MAGGoreDataICloudStoreWillAddedNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeAccountRemoved:
                notificationName = MAGGoreDataICloudStoreWillRemovedNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeContentRemoved:
                notificationName = MAGGoreDataICloudStoreWillCleanedNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted:
                notificationName = MAGGoreDataICloudStoreWillAddedNotification;
                break;
        }
        if (notificationName) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{}];
        }
        [self saveIfNeededAndResetMainContext];
    }
}


- (void)iCloudContentChanged:(NSNotification *)n {
    NSManagedObjectContext *mainCountext = self.mainContext;
    [mainCountext performBlock:^{
        [mainCountext mergeChangesFromContextDidSaveNotification:n];
    }];
    // TODO: add iCloud data changed notification
}


- (void)iCloudStoresDidChange:(NSNotification *)n {
    NSNumber *transitionType = [n.userInfo objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    if (transitionType) {
        NSString *notificationName = nil;
        switch ([transitionType integerValue]) {
            case NSPersistentStoreUbiquitousTransitionTypeAccountAdded:
                notificationName = MAGGoreDataICloudStoreDidAddNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeAccountRemoved:
                notificationName = MAGGoreDataICloudStoreDidRemovedNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeContentRemoved:
                notificationName = MAGGoreDataICloudStoreDidCleanNotification;
                break;
            case NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted:
                notificationName = MAGGoreDataICloudStoreDidAddNotification;
                break;
        }
        if (notificationName) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{}];
        }
    }
}


- (void)subscribeForICloudNotifications {
    if (!self.coordinator) {
        return;
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    self.iCloudStoresWillChangeObserver = [nc addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification object:self.coordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self iCloudStoresWillChange:note];
    }];
    self.iCloudStoresDidChangeObserver = [nc addObserverForName:NSPersistentStoreCoordinatorStoresDidChangeNotification object:self.coordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self iCloudStoresDidChange:note];
    }];
    
    self.iCloudContentChangeObserver = [nc addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.coordinator queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self iCloudContentChanged:note];
    }];
}


- (void)unsubscribeFromICloudNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self.iCloudStoresWillChangeObserver];
    self.iCloudStoresWillChangeObserver = nil;
    [nc removeObserver:self.iCloudStoresDidChangeObserver];
    self.iCloudStoresDidChangeObserver = nil;
    [nc removeObserver:self.iCloudContentChangeObserver];
    self.iCloudContentChangeObserver = nil;
}


#pragma mark - Help

- (void)saveIfNeededAndResetMainContext {
    NSManagedObjectContext *mainContext = self.mainContext;
    [mainContext performBlockAndWait:^{
        NSError *error = nil;
        if ([mainContext hasChanges]) {
            [mainContext save:&error];
        }
        [mainContext reset];
    }];
}

+ (NSError *)errorWithMessage:(NSString *)errorMessage {
    if (!errorMessage) {
        errorMessage = @"Unknown error";
    }
    return [NSError errorWithDomain:MAGCoreDataErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
}


@end
