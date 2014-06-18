//
//  NSManagedObject+MAGCoreData.swift
//  MAGCoreDataSwiftExample
//
//  Created by Alexander Malovichko on 6/5/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class func create() -> AnyObject! {
        return createInContext(MAGCoreData.instance().mainContext)
    }
    
    class func createInContext(context: NSManagedObjectContext?) -> AnyObject! {
        var entityName = "Venues"// NSStringFromClass(MAGCoreData)
        var object : AnyObject! = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)
        return object
//        NSParameterAssert(context);
//        NSManagedObject *object = nil;
//        object =  [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.class) inManagedObjectContext:context];
//        return object;
    }
    
    
    /* Fetching objects
    */
    
    class func all() -> AnyObject[]! {
        return allInContext(MAGCoreData.instance().mainContext)
    }
    
    class func allInContext(context: NSManagedObjectContext?) -> AnyObject[]! {
        if context {
            var entityName = "Venues" //NSStringFromClass(MAGCoreData)
            var request = NSFetchRequest(entityName:entityName)
            var objects = context!.executeFetchRequest(request, error: nil)
            return objects
        }
        return nil
    }

    /* Deleting objects
    */

    /* Refreshing object
    */
}