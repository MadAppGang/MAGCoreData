//
//  MAGCoreDataTestSafeValue.m
//  MAGCoreDataExample
//
//  Created by Konstantin Gerasimov on 12/8/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MAGCoreDataTestCase.h"


@interface NSManagedObject ()
+ (id)safeValueMappedFromKeyedValue:(id)keyedValue withAttributeType:(NSAttributeType)attributeType attribute:(NSString *)attribute valueTransformers:(NSDictionary *)valueTransformers;
@end


@interface MAGCoreDataTestSafeValue : MAGCoreDataTestCase

@end

@implementation MAGCoreDataTestSafeValue

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSafeDoubleValue {
    id dirtyValue = @"23.2343";
    id safeValue = [NSManagedObject safeValueMappedFromKeyedValue:dirtyValue withAttributeType:NSDoubleAttributeType attribute:@"attribute" valueTransformers:@{}];
    expect([safeValue isKindOfClass:[NSNumber class]]).beTruthy();
    expect([safeValue doubleValue] == 23.2343).beTruthy();
}


@end
