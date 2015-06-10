//
//  MAGCoreData.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import CoreData

class MAGCoreData: NSObject {
   
    // MARK: - Properties
    
    // MARK: Public
    
    static let instance = MAGCoreData()
    static var context: NSManagedObjectContext {
        get {
            return instance.mainContext
        }
    }
    
    var autoMergeFromChildContexts = false {
        didSet {
            didSetAutoMergeFromChildContexts()
        }
    }
    
    // MARK: Private
    
    private var mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    private var model: NSManagedObjectModel?
    private var persistentStore: NSPersistentStoreCoordinator?

    // MARK: - Public methods
    
    // MARK: Preparations
    
    class func prepareCoreData(error: NSErrorPointer) -> Bool {
        return prepareCoreDataWithModelName(nil, error: error)
    }
  
    class func prepareCoreDataWithModelName(modelName: String?, error: NSErrorPointer) -> Bool {
        return prepareCoreDataWithModelName(modelName, storageName: nil, error: error)
    }
    
    class func prepareCoreDataWithModelName(modelName: String?, storageName: String?, error: NSErrorPointer) -> Bool {
        let magCoreDataInstance = MAGCoreData.instance

        if let modelName = modelName, modelURL = NSBundle(forClass: self).URLForResource(modelName, withExtension: "momd") {
            magCoreDataInstance.model = NSManagedObjectModel(contentsOfURL: modelURL)
        } else {
            magCoreDataInstance.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        }
        
        if let magCoreDataInstanceModel = magCoreDataInstance.model {
            let persistentStore = NSPersistentStoreCoordinator(managedObjectModel: magCoreDataInstanceModel)
            magCoreDataInstance.persistentStore = persistentStore
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            if let newPersistentStore = persistentStore.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: defaultStorageURLWithName(storageName), options: options, error: error) {
                magCoreDataInstance.mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                magCoreDataInstance.mainContext.persistentStoreCoordinator = newPersistentStore.persistentStoreCoordinator
                
                return true
            }
            
            return false
        }
        
        return false
    }
    
    //  MARK: ManagementObjectContext
    
    class func createPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = MAGCoreData.instance.persistentStore
        return privateContext
    }
    
    // MARK: Saving
    
    class func save(error: NSErrorPointer) -> Bool {
        return MAGCoreData.saveContext(MAGCoreData.context, error: error)
    }
    
    class func saveContext(context: NSManagedObjectContext, error: NSErrorPointer) -> Bool {
        if context.hasChanges && !context.save(error) {
            return false
        }
        
        return true
    }
    
    // MARK: Resetting
    
    class func close() {
        MAGCoreData.instance.mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        MAGCoreData.instance.model = nil
        MAGCoreData.instance.persistentStore = nil
    }
    
    // MARK: Removing
    
    class func deleteAll(error: NSErrorPointer) -> Bool {
        if let persistentStores = MAGCoreData.instance.persistentStore?.persistentStores as? [NSPersistentStore] {
            MAGCoreData.close()
            
            for persistentStore in persistentStores {
                if let persistentStoreURL = persistentStore.URL where !MAGCoreData.removeStoreWithURL(persistentStoreURL, error: error) {
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
    
    class func deleteStorageWithName(storageName: String?, error: NSErrorPointer) -> Bool {
        MAGCoreData.close()
        
        if let defaultStorageURL = defaultStorageURLWithName(storageName) {
            return MAGCoreData.removeStoreWithURL(defaultStorageURL, error: error)
        }
        
        return false
    }
    
    // MARK: - Private methods
    
    private class func defaultStorageURLWithName(storageName: String?) -> NSURL? {
        if let documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as? NSURL {
            if let storageName = storageName {
                return documentDirectory.URLByAppendingPathComponent("\(storageName).sqlite")
            } else {
                return documentDirectory.URLByAppendingPathComponent("MAGStore.sqlite")
            }
        }
        
        return nil
    }
    
    private class func removeStoreWithURL(storeURL: NSURL, error: NSErrorPointer) -> Bool {
        return NSFileManager.defaultManager().removeItemAtURL(storeURL, error: error)
    }
    
    private func didSetAutoMergeFromChildContexts() {
        if autoMergeFromChildContexts {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil, usingBlock: { (notification) -> Void in
                if let context = notification.object as? NSManagedObjectContext {
                    if context != self.mainContext && context.persistentStoreCoordinator == self.persistentStore {
                        self.mainContext.performBlock({ () -> Void in
                            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
                        })
                    }
                }
            })
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
}