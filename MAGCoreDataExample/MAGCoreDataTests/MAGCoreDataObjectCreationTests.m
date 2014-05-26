//
//  MAGCoreDataObjectCreationTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "MAGCoreDataTestCase.h"

@interface MAGCoreDataObjectCreationTests : MAGCoreDataTestCase

@end

@implementation MAGCoreDataObjectCreationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testObjectCreationAndUpdatingInMainContext {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    Weather *obj1 = [Weather create];
    XCTAssertNotNil(obj1);
    
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier}];
    XCTAssertNotNil(obj2);
    XCTAssertTrue([identifier isEqualToNumber:obj2.identifier]);
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectCreationInPrivateContext {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];
    
    Weather *obj1 = [Weather createInContext:privateContext];
    XCTAssertNotNil(obj1);
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier} inContext:privateContext];
    XCTAssertNotNil(obj2);
    XCTAssertTrue([identifier isEqualToNumber:obj2.identifier]);
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectCreationAndSavingInMainContext {
    [[self class] createEmptyStorageWithName:kStorageName];
    Weather *weather = [Weather create];

    [MAGCoreData save];
    
    [[MAGCoreData instance] close];
    [[self class] setupStorageWithName:kStorageName];
    
    Weather *storedWeather = [Weather first];
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    XCTAssertTrue(same);
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectCreationAndSavingInPrivateContext {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];

    Weather *weather = [Weather createInContext:privateContext];
    
    [MAGCoreData saveContext:privateContext];
    
    [[MAGCoreData instance] close];
    [[self class] setupStorageWithName:kStorageName];
    
    Weather *storedWeather = [Weather first];
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    XCTAssertTrue(same);
    [[self class] dropStorage:kStorageName];
}

- (void)testCreateOrUpdateObject {
    [[self class] createEmptyStorageWithName:kStorageName];
    // create object
    Weather *obj1 = [Weather getOrCreateObjectForPrimaryKey:@1];
    XCTAssertNotNil(obj1);
    
    // get object
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];

    NSNumber *obj2Id = @2;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": obj2Id} inContext:privateContext];
    Weather *storedObj2InMainContext = [Weather getOrCreateObjectForPrimaryKey:obj2Id];
    XCTAssertNotNil(storedObj2InMainContext);
    Weather *storedObj2InPrivateContext = [Weather getOrCreateObjectForPrimaryKey:obj2Id];
    XCTAssertNotNil(storedObj2InPrivateContext);
    BOOL differentURI = ![storedObj2InMainContext.objectID.URIRepresentation isEqual:storedObj2InPrivateContext.objectID.URIRepresentation];
    XCTAssertTrue(differentURI);
    BOOL sameId = obj2.identifier.intValue == storedObj2InMainContext.identifier.intValue == storedObj2InPrivateContext.identifier.intValue;
    XCTAssertTrue(sameId);
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectsDeletion {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    [Weather create];
    [Weather create];
    [Weather create];
    XCTAssertTrue([Weather all].count == 3);
    
    [[Weather first] delete];
    XCTAssertTrue([Weather all].count == 2);
    
    [Weather deleteAll];
    XCTAssertTrue([Weather all].count == 0);
    [[self class] dropStorage:kStorageName];
}

@end
