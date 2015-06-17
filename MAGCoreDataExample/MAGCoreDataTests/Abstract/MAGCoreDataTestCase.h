//
//  MAGCoreDataTestCase.h
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "MAGCoreData.h"
#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"

#define kStorageName NSStringFromSelector(_cmd)

@interface MAGCoreDataTestCase : XCTestCase

@end
