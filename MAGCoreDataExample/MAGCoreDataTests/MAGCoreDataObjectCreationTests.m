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
    expect(obj1).toNot.beNil();
    
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier}];
    expect(obj2).toNot.beNil();
    expect([identifier isEqualToNumber:obj2.identifier]).to.beTruthy();
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectCreationInPrivateContext {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];
    
    Weather *obj1 = [Weather createInContext:privateContext];
    expect(obj1).toNot.beNil();
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier} inContext:privateContext];
    expect(obj2).toNot.beNil();
    expect([identifier isEqualToNumber:obj2.identifier]).to.beTruthy();
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
    expect(same).to.beTruthy();
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
    expect(same).to.beTruthy();
    [[self class] dropStorage:kStorageName];
}

- (void)testCreateOrUpdateObject {
    [[self class] createEmptyStorageWithName:kStorageName];
    // create object
    Weather *obj1 = [Weather getOrCreateObjectForPrimaryKey:@1];
    expect(obj1).toNot.beNil();
    
    // get object
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];

    NSNumber *obj2Id = @2;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": obj2Id} inContext:privateContext];
    Weather *storedObj2InMainContext = [Weather getOrCreateObjectForPrimaryKey:obj2Id];
    expect(storedObj2InMainContext).toNot.beNil();
    Weather *storedObj2InPrivateContext = [Weather getOrCreateObjectForPrimaryKey:obj2Id];
    expect(storedObj2InPrivateContext).toNot.beNil();
    BOOL differentURI = ![storedObj2InMainContext.objectID.URIRepresentation isEqual:storedObj2InPrivateContext.objectID.URIRepresentation];
    expect(differentURI).to.beTruthy();
    BOOL sameId = obj2.identifier.intValue == storedObj2InMainContext.identifier.intValue == storedObj2InPrivateContext.identifier.intValue;
    expect(sameId).to.beTruthy();
    [[self class] dropStorage:kStorageName];
}

- (void)testObjectsDeletion {
    [[self class] createEmptyStorageWithName:kStorageName];
    
    [Weather create];
    [Weather create];
    [Weather create];
    expect([Weather all].count == 3).to.beTruthy();
    
    [[Weather first] delete];
    expect([Weather all].count == 2).to.beTruthy();
    
    [Weather deleteAll];
    expect([Weather all].count == 0).to.beTruthy();
    [[self class] dropStorage:kStorageName];
}

@end
