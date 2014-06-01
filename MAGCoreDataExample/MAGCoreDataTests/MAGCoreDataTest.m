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

- (void)testAsynchronousActions1 {
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

- (void)testAsynchronousActions2 {
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

- (void)testTest1 {
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    __block NSObject *obj;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
            expect(YES).to.beFalsy();
            obj = nil;
            XCTFail();
        }];
        
        [operationQueue addOperationWithBlock:^(){
//            expect(YES).to.beFalsy();
        }];
        
//        [operationQueue start];
    });
    
//    NSLog(@"234");
//    expect(obj).willNot.beFalsy();
}

- (void)testTest3 {
    [[NSOperationQueue new] addOperationWithBlock:^{
//        expect(YES).to.beFalsy();
        XCTFail();
    }];
}

- (void)testTest4 {
    dispatch_queue_t queue = dispatch_queue_create("IDDQD", 0);
    dispatch_async(queue, ^{
        expect(YES).to.beFalsy();
    });
}



@end
