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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
