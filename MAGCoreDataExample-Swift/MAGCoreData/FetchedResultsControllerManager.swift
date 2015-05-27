//
//  FetchedResultsControllerManager.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import UIKit
import CoreData

typealias FetchedResultsControllerUpdateBlock = (tableViewCell: UITableViewCell, indexPath: NSIndexPath) -> ()

class FetchedResultsControllerManager: NSObject {
   
    weak var tableView: UITableView?
    weak var fetchedResultsController: NSFetchedResultsController?
    
    private var updateBlock: FetchedResultsControllerUpdateBlock?
    
    override init() {
        super.init()
    }
    
    init(fetchedResultsController: NSFetchedResultsController, tableView: UITableView, updateBlock: FetchedResultsControllerUpdateBlock) {
        super.init()
        
        self.tableView = tableView
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController?.delegate = self
        self.updateBlock = updateBlock
    }
}

extension FetchedResultsControllerManager: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch (type) {
        case .Insert:
            tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
        case .Delete:
            tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
        default:
            break
        }
    }
        
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if let tableView = tableView, indexPath = indexPath, newIndexPath = newIndexPath {
            switch (type) {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                break
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                break
            case .Update:
                if let updateBlock = updateBlock, tableViewCell = tableView.cellForRowAtIndexPath(indexPath) {
                    updateBlock(tableViewCell: tableViewCell, indexPath: indexPath)
                }
                break
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                break
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }
}

