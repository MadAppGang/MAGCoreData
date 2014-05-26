//
//  MAGCoreDataObjectCreationTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAGCoreData.h"
#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"

NSString * const storageName = @"TestStorage";

@interface MAGCoreDataObjectCreationTests : XCTestCase

@end

@implementation MAGCoreDataObjectCreationTests

+ (void)setUp {
}

+ (void)tearDown {
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)setupStorage {
    [MAGCoreData prepareCoreDataWithModelName:nil andStorageName:storageName error:nil];
}

- (void)dropStorage {
    [MAGCoreData deleteStorageWithName:storageName];
}

- (void)testObjectCreationAndUpdatingInMainContext {
    [self setupStorage];
    
    Weather *obj1 = [Weather create];
    XCTAssertNotNil(obj1);
    
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier}];
    XCTAssertNotNil(obj2);
    XCTAssertTrue([identifier isEqualToNumber:obj2.identifier]);
}

- (void)testObjectCreationInPrivateContext {
    [self setupStorage];
    
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];
    
    Weather *obj1 = [Weather createInContext:privateContext];
    XCTAssertNotNil(obj1);
    NSNumber *identifier = @1;
    Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier} inContext:privateContext];
    XCTAssertNotNil(obj2);
    XCTAssertTrue([identifier isEqualToNumber:obj2.identifier]);
}

- (void)testObjectCreationAndSavingInMainContext {
    [self dropStorage];
    [self setupStorage];
    Weather *weather = [Weather create];

    [MAGCoreData save];
    
    [[MAGCoreData instance] close];
    [self setupStorage];
    
    Weather *storedWeather = [Weather first];
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    XCTAssertTrue(same);
}

- (void)testObjectCreationAndSavingInPrivateContext {
    [self dropStorage];
    [self setupStorage];
    
    NSManagedObjectContext *privateContext = [MAGCoreData createPrivateContext];

    Weather *weather = [Weather createInContext:privateContext];
    
    [MAGCoreData saveContext:privateContext];
    
    [[MAGCoreData instance] close];
    [self setupStorage];
    
    Weather *storedWeather = [Weather first];
    
    BOOL same = [weather.objectID.URIRepresentation isEqual:storedWeather.objectID.URIRepresentation];
    XCTAssertTrue(same);
}

- (void)testCreateOrUpdateObject {
    [self dropStorage];
    [self setupStorage];
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
}

- (void)testObjectsDeletion {
    [self dropStorage];
    [self setupStorage];
    
}

//NSString *cityMoscow = @"Moscow";
//NSString *cityPoltava = @"Poltava";
//Weather *obj2 = [Weather createFromDictionary:@{@"id": identifier, @"city": cityMoscow}];
//Weather *obj2 = [Weather createFromDictionary:@{@"identifier": @1, @"city": @"Moscow", @"temperature" : @22}];

/*
 + (instancetype)getOrCreateObjectForPrimaryKey:(id)primaryKey;
 + (instancetype)getOrCreateObjectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;

+ (instancetype)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues;
+ (instancetype)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues inContext:(NSManagedObjectContext *)context;

#pragma mark - deleting objects
+ (void)deleteAll;
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;
- (void)delete;

#pragma mark - refreshing object
- (void)refreshMerging:(BOOL)merging;
*/

@end
