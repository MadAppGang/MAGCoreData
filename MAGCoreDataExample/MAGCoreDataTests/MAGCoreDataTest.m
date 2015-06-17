//
//  MAGCoreDataTest.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/29/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataTest : MAGCoreDataTestCase

@end

@implementation MAGCoreDataTest

- (void)setUp {
    [super setUp];
    
    [MAGCoreData deleteAllInStorageWithName:kStorageName];
    [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:kStorageName error:nil];
}

- (void)tearDown {
    [super tearDown];
    
    [MAGCoreData deleteAll];
}

- (void)testAsynchronousSavingInBackgroundThread {
    NSNumber *objId = @1;
    
    __block NSManagedObjectContext *privateContext;
    __block BOOL privateContextHasChanges;
    __block Weather *object;
    __block BOOL objectExistInMainContext;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        privateContext = [MAGCoreData createPrivateContext];
        object = [Weather createFromDictionary:@{@"id": objId} inContext:privateContext];
        privateContextHasChanges = privateContext.hasChanges;
        [privateContext save:nil];
        
        objectExistInMainContext = [Weather objectForPrimaryKey:objId inContext:[MAGCoreData context]] ? YES : NO;
    });
    expect(privateContext).willNot.beNil();
    expect(privateContextHasChanges).will.beTruthy();
    expect(object).willNot.beNil();
    expect(objectExistInMainContext).will.beTruthy();
}

- (void)testAccessToObjectFromBackgroundThread {
    NSNumber *objId = @1;
    
    __block NSManagedObjectContext *privateContext;
    __block BOOL objectExistInPrivateContext;

    Weather *object = [Weather createFromDictionary:@{@"id": objId}];
    expect(object).toNot.beNil();
    [MAGCoreData save];
    expect([MAGCoreData context].hasChanges).to.beFalsy();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        privateContext = [MAGCoreData createPrivateContext];
        objectExistInPrivateContext = [Weather objectForPrimaryKey:objId inContext:[MAGCoreData context]] ? YES : NO;
    });
    
    expect(privateContext).willNot.beNil();
    expect(objectExistInPrivateContext).will.beTruthy();
}

//- (void)testAutoMergeFromChildContexts {
//    [MAGCoreData deleteAllInStorageWithName:kStorageName];
//    [MAGCoreData prepareCoreDataWithModelName:@"Model" andStorageName:kStorageName error:nil];
//    
//    [MAGCoreData instance].autoMergeFromChildContexts = YES;
//    
//    __block BOOL saveSuccess = NO;
//    __block NSManagedObjectContext *context;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
//        context = [MAGCoreData createPrivateContext];
//        [Weather createInContext:context];
//        saveSuccess = [context save:nil];
//    });
//    
////    [MAGCoreData save];
//    
//    
//    expect(saveSuccess).will.beTruthy();
//    
//    NSLog(@"Weather in main:%d", [Weather all].count);
//    NSLog(@"Weather in cntx:%d", [Weather allInContext:context].count);
//    
//    [MAGCoreData deleteAllInStorageWithName:kStorageName];
//}

@end
