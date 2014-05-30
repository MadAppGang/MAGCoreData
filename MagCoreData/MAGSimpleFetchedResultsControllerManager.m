//
// Created by Ievgen Rudenko on 8/28/13.
// Copyright (c) 2013 MadAppGang. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreData/CoreData.h>
#import "MAGSimpleFetchedResultsControllerManager.h"


@interface MAGSimpleFetchedResultsControllerManager() <NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, copy) void(^updateBlock)(UITableViewCell *, NSIndexPath *);
@end;


@implementation MAGSimpleFetchedResultsControllerManager

- (instancetype)initWithFRC:(NSFetchedResultsController *)frc
               forTableView:(UITableView *)tableView
            withUpdateBlock:(void (^)(UITableViewCell *, NSIndexPath *))updateBlock {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _fetchedResultController = frc;
        _fetchedResultController.delegate = self;
        _updateBlock = [updateBlock copy];
    }
    return self;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            self.updateBlock([tableView cellForRowAtIndexPath:indexPath],indexPath);
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end