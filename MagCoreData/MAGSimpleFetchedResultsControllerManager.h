//
// Created by Ievgen Rudenko on 8/28/13.
// Copyright (c) 2013 MadAppGang. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NSFetchedResultsController;


@interface MAGSimpleFetchedResultsControllerManager : NSObject

@property (nonatomic, readonly, weak) UITableView *tableView;
@property (nonatomic, readonly, weak) NSFetchedResultsController *fetchedResultController;

- (instancetype)initWithFRC:(NSFetchedResultsController *)frc forTableView:(UITableView *)tableView withUpdateBlock:(void(^)(UITableViewCell *, NSIndexPath *))updateBlock;

@end