//
//  Venues.h
//  MAGCoreDataSwiftExample
//
//  Created by Alexander Malovichko on 6/6/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venues : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createdAt;

@end
