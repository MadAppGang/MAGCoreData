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
    
    [MAGCoreData deleteAllInStorageWithName:NSStringFromClass([self class])];
    [MAGCoreData prepareCoreDataWithModelName:@"Model" andStorageName:NSStringFromClass([self class]) error:nil];
}

- (void)tearDown {
    [super tearDown];
    
    [MAGCoreData deleteAllInStorageWithName:NSStringFromClass([self class])];
}

- (void)testObjectCreationInContext {
    NSManagedObjectContext *context = [NSManagedObjectContext new];
    id mock = [OCMockObject mockForClass:[NSEntityDescription class]];
    [[[mock expect] classMethod] insertNewObjectForEntityForName:NSStringFromClass([Weather class]) inManagedObjectContext:context];
    [Weather createInContext:context];
    [mock verify];
}

- (void)testObjectCreationAndUpdatingInMainContext {
    Weather *obj1 = [Weather create];
    expect(obj1).toNot.beNil();
    
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier}];
    expect(obj2).toNot.beNil();
    expect([identifier isEqualToNumber:obj2.identifier]).to.beTruthy();
}

- (void)testObjectCreationInPrivateContext {
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];
    
    Weather *obj1 = [Weather createInContext:privateContext];
    expect(obj1).toNot.beNil();
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier} inContext:privateContext];
    expect(obj2).toNot.beNil();
    expect([identifier isEqualToNumber:obj2.identifier]).to.beTruthy();
}

- (void)testObjectCreationAndSavingInPrivateContext {
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];

    Weather *weather = [Weather createInContext:privateContext];
    expect(weather).toNot.beNil();
    expect([MAGCoreData saveContext:privateContext]).to.beTruthy();
    
    MAGCoreDataLog(@"hasChanges");
    MAGCoreDataLog(@"array %d", [Weather all].count);
    
    [[MAGCoreData instance] close];
    expect([MAGCoreData prepareCoreDataWithModelName:nil andStorageName:NSStringFromClass([self class]) error:nil]).to.beTruthy();
    
    Weather *storedWeather = [Weather all].firstObject;
    expect(storedWeather).toNot.beNil();
//    /Users/alex/workspace/office/MAGCoreData/MAGCoreDataExample/MAGCoreDataTests/MAGCoreDataObjectCreationTests.m:72:14: Incompatible pointer types initializing 'Weather *' with an expression of type '__kindof NSManagedObjectContext * __nullable'
    MAGCoreDataLog(@"array %d", [Weather all].count);
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    expect(same).to.beTruthy();
}

- (void)testCreateOrUpdateObject {
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
}

- (void)testObjectsDeletion {
    id mock = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    id obj = [OCMockObject mockForClass:[NSManagedObject class]];
    [[[mock stub] andReturn:@[obj]] executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]];
    [[mock expect] deleteObject:[OCMArg any]];
    [Weather deleteAllInContext:mock];
    [mock verify];
}

@end
