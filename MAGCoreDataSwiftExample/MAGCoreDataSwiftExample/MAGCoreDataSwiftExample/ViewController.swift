//
//  ViewController.swift
//  MAGCoreDataSwiftExample
//
//  Created by Alexander Malovichko on 6/5/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
                            
    @IBOutlet var uiTableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init core data
        let modelName:String?
        let storageName = "MAGCoreDataSwiftStorage"
        var error:NSError?
        
        MAGCoreData.deleteAllInStorageWithName(storageName)
        assert(MAGCoreData.prepareCoreDataWithModelName(modelName, storageName: storageName, error: error), "Prepare error")
        assert(MAGCoreData.deleteAllInStorageWithName(storageName), "Delete error")

        assert(MAGCoreData.prepareCoreDataWithModelName(modelName, storageName: storageName, error: error), "Prepare error")
        
        
        // create objects
//        var obj = NSManagedObject()
//        NSManagedObject.createInContext
        
        
        
        // other
        
//        println(coreData.mad)
        
        NSFileManager.defaultManager()
        
//        coreData.cre
        
//        coreData.someDescr
        
//        MAGCoreData.someDescr
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Did select row: \(indexPath.description)")
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
        
        cell.text = "ROW \(indexPath.row)"
        cell.detailTextLabel.text = "\(indexPath.row)"
        
        return cell
    }

}

