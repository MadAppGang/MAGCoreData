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
    
    var model:NSManagedObjectModel?
    var mainContext:NSManagedObjectContext?
    var persistentStore:NSPersistentStoreCoordinator?
  
    // TODO::
//    @property (nonatomic, assign) BOOL autoMergeFromChildContexts; //default is NO

    
    init() {
    }
    
//    func instance() -> MAGCoreData {
//        let sharedInstance:MAGCoreData = MAGCoreData()
//        var token : dispatch_once_t = 0
//        dispatch_once(&token, {
//            sharedInstance = MAGCoreData()
//            })
//        return sharedInstance
//    }
    
    // TODO
    class var sharedInstance:MAGCoreData {
        get {
            struct Static {
                static var instance : MAGCoreData? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = MAGCoreData() }
            
            return Static.instance!
    }
    }
    
    func prepareCoreData() -> NSError? {
        self.prepareCoreDataWithModelName(nil, storageName: nil, error: nil)
        return nil
    }
    
    func prepareCoreDataWithModelName(modelName: String?, error: NSError?) -> Bool {
        return self.prepareCoreDataWithModelName(modelName, storageName: nil, error: error)
    }
    
    func prepareCoreDataWithModelName(modelName: String?, storageName: String?, error: NSError?) -> Bool {
        
        if modelName != nil {
            var modelURL:NSURL = NSBundle.mainBundle().URLForResource(modelName, withExtension:"momd")
            self.model = NSManagedObjectModel(contentsOfURL: modelURL)
        } else {
            self.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        }
        
        self.persistentStore = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        var options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        var storeURL = self.defaultStorageURLWithName(storageName)
        
        if !self.persistentStore!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: nil) {
            return false
        }
        
        self.mainContext = NSManagedObjectContext(concurrencyType:NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.mainContext!.persistentStoreCoordinator = self.persistentStore
        
        return true;
    }
    
    func defaultStorageURLWithName(storageName: String?) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        var docDir : NSURL = urls[urls.endIndex - 1] as NSURL
        var fileName:String = storageName ? storageName! + ".sqlite" : "MAGStore.sqlite"
        return docDir.URLByAppendingPathComponent(fileName)
    }

    func context() -> NSManagedObjectContext? {
        return self.mainContext
    }
    
    func createPrivateContext() -> NSManagedObjectContext? {
        if !self.mainContext {
            return nil
        }
        var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStore
        return moc
    }
    
    func save() -> Bool {
        return self.saveContext(self.mainContext)
    }
    
    func saveContext(context: NSManagedObjectContext?) -> Bool {
        if !context {
            return false
        }
        if context!.hasChanges && !context!.save(nil) {
            return false
        }
        return true
    }
    
    func close() {
        self.mainContext = nil
        self.model = nil
        self.persistentStore = nil
    }
    
    func removeStoreAtPath(storeURL: NSURL) -> Bool {
        NSFileManager.defaultManager().removeItemAtPath(storeURL.path, error: nil)
        return true
    }
    
    func deleteAll() -> Bool {
        var storeURL = self.persistentStore!.persistentStores[0].URL
        self.close()
        return self.removeStoreAtPath(storeURL)
    }
    
    func deleteAllInStorageWithName(storageName: String?) -> Bool {
        self.close()
        return self.removeStoreAtPath(self.defaultStorageURLWithName(storageName))
    }
    
}