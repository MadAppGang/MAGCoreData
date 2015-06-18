//
//  MAGAppDelegate.m
//  MAGCoreDataExample
//
//  Created by Ievgen Rudenko on 8/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "MAGAppDelegate.h"
#import "MAGCoreData.h"
#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"

@implementation MAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [MAGCoreData instance];

//    NSString *primaryKey = @"primaryKey";
//    NSManagedObjectContext *context = MAGCoreData.context;
//    NSDictionary *dictionary = [NSDictionary dictionary];
////    Weather *weather = [Weather createFromDictionary:dictionary inContext:context];
//    
////    [weather safeSetValuesForKeysWithDictionary:dictionary];
//    
////    [Weather deleteAllInContext:context];
//    
//    Weather *weather = [Weather objectForPrimaryKey:primaryKey];
//    
//    [MAGCoreData deleteAllInStorageWithName:@"storageName"];
//    [MAGCoreData saveContext:context];
//    
////    weather 
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
