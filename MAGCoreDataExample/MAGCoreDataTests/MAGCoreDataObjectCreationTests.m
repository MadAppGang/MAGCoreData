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
    
    NSLog(@"hasChanges");
    NSLog(@"array %lu", (unsigned long)[Weather all].count);
    
    [[MAGCoreData instance] close];
    expect([MAGCoreData prepareCoreDataWithModelName:nil andStorageName:NSStringFromClass([self class]) error:nil]).to.beTruthy();
    
    Weather *storedWeather = [[Weather all] firstObject];
    expect(storedWeather).toNot.beNil();
    
    NSLog(@"array %lu", (unsigned long)[Weather all].count);
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    expect(same).to.beTruthy();
}

- (void)testCreateOrUpdateObject {
    NSManagedObjectContext *contect = [MAGCoreData createPrivateContext];
    // Create an object
    NSNumber *identifier = @1;
    Weather *newObject = [Weather getOrCreateObjectForPrimaryKey:identifier inContext:contect];
    expect(newObject).toNot.beNil();
    expect(newObject.identifier).equal(identifier);
    
    expect([Weather getOrCreateObjectForPrimaryKey:nil]).to.beNil();
    
    // Get the object
    Weather *storedObject = [Weather getOrCreateObjectForPrimaryKey:identifier inContext:contect];
    expect(storedObject.identifier).equal(newObject.identifier);
    expect([storedObject.objectID.URIRepresentation isEqual:newObject.objectID.URIRepresentation]).to.beTruthy();
    
    expect([Weather objectForPrimaryKey:identifier]).to.beNil();
    expect([Weather objectForPrimaryKey:identifier inContext:contect]).toNot.beNil();
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
