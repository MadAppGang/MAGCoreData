//
//  MAGCoreDataLogicTests.m
//  MAGCoreDataLogicTests
//
//  Created by Sergii Kostanian on 5/21/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND YES
#import "Expecta.h"
#import "OCMock.h"
#import "MAGCoreData.h"
#import "NSManagedObject+MAGCoreData.h"
#import "Person.h"

@interface MAGCoreDataTests : XCTestCase

@end

@implementation MAGCoreDataTests

- (void)setUp {
    [super setUp];
    [MAGCoreData prepareCoreData];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatingSingletonInstance {
    XCTAssertNotNil([MAGCoreData instance]);
}

- (void)testCreatingSingletonInstanceOnce {
    XCTAssertEqual([MAGCoreData instance], [MAGCoreData instance]);
}

- (void)testCoreDataPreparing {
    NSError *error = [MAGCoreData prepareCoreData];
    expect(error).to.beNil();
}

- (void)testManagedObjectCreating {
    expect([Person create]).toNot.beNil();
    [Person deleteAll];
}

- (void)testKeyMappingNotNil {
    
    NSDictionary *keyMap = @{@"identifier"  : @"id",
                             @"name"        : @"name"};
    [Person setKeyMapping:keyMap];
    expect([Person keyMapping]).toNot.beNil();
}

- (void)testKeyMapping {
    
    NSDictionary *keyMap = @{@"identifier"  : @"id",
                             @"name"        : @"name"};
    [Person setKeyMapping:keyMap];
    expect([Person keyMapping]).equal(keyMap);
}

- (void)testFirstWithKeyNotNill {
    [self createTestEntity];
    Person *serg = [Person firstWithKey:@"identifier" value:@123];
    expect(serg).toNot.beNil();
    [Person deleteAll];
}

- (void)testFirstWithKey {
    [self createTestEntity];
    Person *serg = [Person firstWithKey:@"identifier" value:@123];
    expect(serg.name).equal(@"serg");
    [Person deleteAll];
}

- (void)testAllForPredicate {
    [self createTestEntity];
    NSArray *arr = [Person allForPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", @123]];
    expect(arr).toNot.beNil();
    [Person deleteAll];
}

- (void)testDeleteAll {
    [self createTestEntity];
    [Person deleteAll];
    NSArray *arr = [Person all];
    expect(arr.count).equal(0);
}

#pragma mark - Helper methods

- (void)createTestEntity {
    [Person safeCreateOrUpdateWithDictionary:@{@"identifier"  : @123,
                                               @"name"        : @"serg"}];
}


@end
