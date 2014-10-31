//
//  MAGCoreDataExampleTests.m
//  MAGCoreDataExampleTests
//
//  Created by Yaroslav Symonenko on 5/25/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "MAGCoreData.h"
#import "NSManagedObject+MAGCoreData.h"
#import "TestEntity.h"

#define EXP_SHORTHAND
#import "Expecta.h"


@interface MAGCoreDataExampleTests : XCTestCase

@end

@implementation MAGCoreDataExampleTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCanCreateSingletone
{
    XCTAssertNotNil([MAGCoreData instance], @"CanCreateSingletone");
}

- (void)testSingletoneReturnSameObjects
{
    XCTAssertEqualObjects([MAGCoreData instance], [MAGCoreData instance], @"SingletoneReturnSameObject");
}

- (void)testCanCreateNewObject
{
    MAGCoreData *instantinatedInstance = [MAGCoreData new];
    XCTAssertNotEqual([MAGCoreData instance], instantinatedInstance, @"CanCreateNewObject");
}

- (void)testPrepareData
{
    NSError *error = [MAGCoreData prepareCoreData];
    expect(error).to.beNil();
}

- (void)testSaveContext {
    [MAGCoreData prepareCoreData];
    NSManagedObjectContext *context = [MAGCoreData context];
    expect(context).toNot.beNil();
    
    [self createTestEntity];
    expect([context hasChanges]).to.beTruthy();
    
    XCTAssertNoThrow([MAGCoreData saveContext:context], @"SaveContext must no raise exception");
    expect([context hasChanges]).to.beFalsy();
    
    [TestEntity deleteAll];
    expect([context hasChanges]).to.beTruthy();
    
    XCTAssertNoThrow([MAGCoreData saveContext:context], @"SaveContext must no raise exception");
    expect([context hasChanges]).to.beFalsy();
}

- (void)testManagedObjectCreating {
    [MAGCoreData prepareCoreData];
    expect([TestEntity create]).toNot.beNil();
    [TestEntity deleteAll];
}

- (void)testKeyMappingNotNil {
    
    NSDictionary *keyMap = @{@"name" : @"name"};
    [TestEntity setKeyMapping:keyMap];
    expect([TestEntity keyMapping]).toNot.beNil();
}

- (void)testKeyMapping {
    
    NSDictionary *keyMap = @{@"name" : @"name"};
    [TestEntity setKeyMapping:keyMap];
    expect([TestEntity keyMapping]).equal(keyMap);
}

- (void)testDeleteAll {
    [MAGCoreData prepareCoreData];
    [self createTestEntity];
    [TestEntity deleteAll];
    NSArray *arr = [TestEntity all];
    expect(arr.count).equal(0);
}

- (void)testContextAfterClose
{
    [MAGCoreData prepareCoreData];
    [MAGCoreData deleteAll];
    expect([MAGCoreData context]).to.beNil;
}

- (void)createTestEntity {
    [TestEntity safeCreateOrUpdateWithDictionary:@{@"name" : @"testName"}];
}


@end
