//
//  MAGViewController.m
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 6/18/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

#import "MAGViewController.h"
#import "MAGCoreData.h"
#import "NSManagedObject+MAGCoreData.h"
#import "Weather.h"
#import "School.h"
#import "Student.h"

@interface MAGViewController ()

@end

@implementation MAGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareCoreData];
    
//    NSString *primaryKey = @"primaryKey";
//    NSManagedObjectContext *context = MAGCoreData.context;
//    NSDictionary *dictionary = [NSDictionary dictionary];
    
//    Weather *weather = [Weather createFromDictionary:@{@"id": @"1", @"city": @"Glasgow", @"temperature": @"17"}];
//    NSLog(@"%@", weather.identifier); // 1
//    NSLog(@"%@", weather.city); // Glasgow
//    NSLog(@"%@", weather.temperature); // 17
    
//    NSDictionary *dictionary = @{@"identifier": @"1", @"students": @[@{@"id": @"1", @"name": @"Marcus"}, @{@"id": @"2", @"name": @"Livia"}]};
//    School *school = [School createFromDictionary:dictionary];
//    NSLog(@"First student's name is %@", ((Student *)school.students.allObjects[0]).name); // Marcus
//    NSLog(@"Second student's name is %@", ((Student *)school.students.allObjects[1]).name); // Livia
    
//    Student *student = [Student createFromDictionary:@{@"identifier": @"1", @"name": @"Marcus"}];
//    NSLog(@"id = %@", student.identifier); // 1
//    NSLog(@"name = %@", student.name); // Marcus
    
//    NSDictionary *dictionary = @{@"name": @"name"};
    
//    Weather *weather = [Weather createFromDictionary:@{@"fog": @"YES"}];
//    NSLog(@"Fog = %@", weather.fog); // Fog = 1
//    
//    NSString *x = @"NO";
//    NSString *y = @"YES";
//    NSLog(@"%d = %d", x.boolValue, y.boolValue);
}

- (void)prepareCoreData {
    NSError *error;
    NSString *modelName = @"Model";
    NSString *storageName = @"MAGCoreDataExampleStorage";
    [MAGCoreData prepareCoreDataWithModelName:modelName andStorageName:storageName error:&error];
    if (error) {
        [MAGCoreData deleteAllInStorageWithName:storageName];
        [MAGCoreData prepareCoreDataWithModelName:modelName andStorageName:storageName error:nil];
    }
    
    [MAGCoreData instance].autoMergeFromChildContexts = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
