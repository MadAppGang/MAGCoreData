//
//  MAGCoreDataManagedObjectTests.m
//  MAGCoreDataExample
//
//  Created by Sergii Kostanian on 5/22/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAGCoreData.h"
#import "NSManagedObject+MAGCoreData.h"

@interface MAGCoreDataManagedObjectTests : XCTestCase

@property (strong, nonatomic) NSManagedObject *testObject;

@end

@implementation MAGCoreDataManagedObjectTests

- (void)setUp {
    [super setUp];
    
    // create the entity
    NSEntityDescription *testEntity = [NSEntityDescription entityForName:@"Human" inManagedObjectContext:[MAGCoreData context]];
    
    // create the attributes
	NSAttributeDescription *idAttribute = [NSAttributeDescription new];
	[idAttribute setName:@"id"];
	[idAttribute setAttributeType:NSInteger64AttributeType];
	[idAttribute setOptional:NO];
	[idAttribute setIndexed:YES];
    
	NSAttributeDescription *nameAttribute = [NSAttributeDescription new];
	[nameAttribute setName:@"name"];
	[nameAttribute setAttributeType:NSStringAttributeType];
	[nameAttribute setOptional:NO];
    
    [testEntity setProperties:@[idAttribute, nameAttribute]];

    self.testObject = [[NSManagedObject alloc] initWithEntity:testEntity insertIntoManagedObjectContext:[MAGCoreData context]];
//    self.testObject 
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testKeyMapping {
    NSDictionary *testDict = @{@"key": @"object"};
    [NSManagedObject setKeyMapping:testDict];
    XCTAssertEqual(testDict, [NSManagedObject keyMapping]);
}

- (void)testSomeUnit {
    
}

@end
