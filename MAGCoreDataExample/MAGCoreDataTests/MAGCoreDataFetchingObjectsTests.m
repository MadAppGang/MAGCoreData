//
//  MAGCoreDataFetchingObjectsTests.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MAGCoreDataFetchingObjectsTests : XCTestCase

@end

@implementation MAGCoreDataFetchingObjectsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSome {
    XCTAssertTrue(YES);
}

/*
 + (instancetype)objectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;
 + (instancetype)objectForPrimaryKey:(id)primaryKey;
 
#pragma mark - fetching objects
+ (NSArray *)all;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allInContext:(NSManagedObjectContext*)context;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (id)first;
+ (id)firstWithKey:(NSString *)key value:(id)value;

+ (id)firstInContext:(NSManagedObjectContext *)context;
+ (id)firstWithKey:(NSString *)key value:(id)value inContext:(NSManagedObjectContext *)context;
*/


@end
