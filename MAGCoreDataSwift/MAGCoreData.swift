//
//  MAGCoreData.swift
//  MAGCoreDataExample
//
//  Created by Alexander Malovichko on 6/3/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

import Foundation
import CoreData


class MAGCoreData: NSObject {
    
    // TODO:: Class variables not yet supported :)
    
    var model:NSManagedObjectModel?
    var mainContext:NSManagedObjectContext?
    var persistentStore:NSPersistentStoreCoordinator?
  
    // TODO //default is NO
    var autoMergeFromChildContexts:Bool {
        get {
            return true
        }
        set (value) {
            
        }
    }
    
    /* Returns the singleton instance.
    */
    class func instance() -> MAGCoreData! {
        struct Static {
            static var instance : MAGCoreData? = nil
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MAGCoreData()
        }
        
        return Static.instance!
    }


    /* Initialisation
    */
    class func prepareCoreData() -> Bool {
        return self.prepareCoreDataWithModelName(nil, storageName: nil, error: nil)
    }
    
    class func prepareCoreDataWithModelName(modelName: String?, error: NSError?) -> Bool {
        return self.prepareCoreDataWithModelName(modelName, storageName: nil, error: error)
    }
    
    // TODO:: error pointer
    class func prepareCoreDataWithModelName(modelName: String?, storageName: String?, error: NSError?) -> Bool {
        let mag = MAGCoreData.instance()
        
        if MAGCoreData.instance().mainContext != nil {
            // TODO:: error
            return false
        }
        
        if modelName != nil {
            var modelURL:NSURL = NSBundle.mainBundle().URLForResource(modelName, withExtension:"momd")
            mag.model = NSManagedObjectModel(contentsOfURL: modelURL)
        } else {
            mag.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        }
        
        mag.persistentStore = NSPersistentStoreCoordinator(managedObjectModel: mag.model)
        var options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        var storeURL = defaultStorageURLWithName(storageName)
        
        if !mag.persistentStore!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: nil) {
            // TODO:: error
            return false
        }
        
        mag.mainContext = NSManagedObjectContext(concurrencyType:NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        mag.mainContext!.persistentStoreCoordinator = mag.persistentStore
        
        return true;
    }
    
    class func defaultStorageURLWithName(storageName: String?) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        var docDir : NSURL = urls[urls.endIndex - 1] as NSURL
        var fileName:String = storageName ? storageName! + ".sqlite" : "MAGStore.sqlite"
        return docDir.URLByAppendingPathComponent(fileName)
    }

    /* Management Object Context
    */
    class func context() -> NSManagedObjectContext? {
        return MAGCoreData.instance().mainContext
    }
    
    class func createPrivateContext() -> NSManagedObjectContext? {
        if !MAGCoreData.context() {
            return nil
        }
        var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = MAGCoreData.instance().persistentStore
        return moc
    }
    
    /* Save the main context
    */
    class func save() -> Bool {
        return self.saveContext(MAGCoreData.context())
    }
    
    /* Saving
    */
    class func saveContext(context: NSManagedObjectContext?) -> Bool {
        if !context {
            return false
        }
        if context!.hasChanges && !context!.save(nil) {
            return false
        }
        return true
    }
    
    class func close() {
        var mag = MAGCoreData.instance()
        mag.mainContext = nil
        mag.model = nil
        mag.persistentStore = nil
    }
    
    class func removeStoreAtPath(storeURL: NSURL) -> Bool {
        return NSFileManager.defaultManager().removeItemAtPath(storeURL.path, error: nil)
    }
    
    /* Delete all data from first persistent store in persistent store coordinator
    */
    class func deleteAll() -> Bool {
        var storeURL = MAGCoreData.instance().persistentStore!.persistentStores[0].URL
        self.close()
        return self.removeStoreAtPath(storeURL)
    }
    
    class func deleteAllInStorageWithName(storageName: String?) -> Bool {
        self.close()
        return self.removeStoreAtPath(self.defaultStorageURLWithName(storageName))
    }
    
}