//
//  Weather+Initialization.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 5/26/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import "Weather+Initialization.h"
#import "NSManagedObject+MAGCoreData.h"

@implementation Weather (Initialization)

+ (void)initialize {
    [self setKeyMapping:@{
                          @"identifier"  : @"id",
                          @"city"        : @"city",
                          @"temperature" : @"temperature"
                          }];
    [self setPrimaryKeyName:@"identifier"];
}

@end
