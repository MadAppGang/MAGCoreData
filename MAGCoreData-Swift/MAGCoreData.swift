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
        return instance.mainContext
    }
    
    var autoMergeFromChildContexts = false {
        didSet {
            didSetAutoMergeFromChildContexts()
        }
    }
    
    // MARK: Private
    
    private var mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    private var model: NSManagedObjectModel?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?

    // MARK: - Public methods
    
    // MARK: Preparations
    
    class func prepareCoreData(error: NSErrorPointer = nil) -> Bool {
        return prepareCoreDataWithModelName(nil, error: error)
    }
  
    class func prepareCoreDataWithModelName(modelName: String?, error: NSErrorPointer = nil) -> Bool {
        return prepareCoreDataWithModelName(modelName, storageName: nil, error: error)
    }
    
    class func prepareCoreDataWithModelName(modelName: String?, storageName: String?, error: NSErrorPointer = nil) -> Bool {
        if let modelName = modelName, modelURL = NSBundle(forClass: self).URLForResource(modelName, withExtension: "momd") {
            instance.model = NSManagedObjectModel(contentsOfURL: modelURL)
        } else {
            instance.model = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())
        }
        
        if let model = instance.model {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            if let persistentStore = persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: defaultStorageURLWithName(storageName), options: options, error: error) {
                instance.mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                instance.mainContext.persistentStoreCoordinator = persistentStore.persistentStoreCoordinator
                instance.persistentStoreCoordinator = persistentStore.persistentStoreCoordinator

                return true
            }
        }
        
        return false
    }
    
    //  MARK: ManagementObjectContext
    
    class func createPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = instance.persistentStoreCoordinator
        return privateContext
    }
    
    // MARK: Saving
    
    class func save(error: NSErrorPointer = nil) -> Bool {
        return saveContext(MAGCoreData.context, error: error)
    }
    
    class func saveContext(context: NSManagedObjectContext, error: NSErrorPointer = nil) -> Bool {
        if context.hasChanges && !context.save(error) {
            return false
        }
        
        return true
    }
    
    // MARK: Resetting
    
    class func close() {
        instance.mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        instance.model = nil
        instance.persistentStoreCoordinator = nil
    }
    
    // MARK: Removing
    
    class func deleteAll(error: NSErrorPointer = nil) -> Bool {
        if let persistentStores = instance.persistentStoreCoordinator?.persistentStores as? [NSPersistentStore] {
            close()
            
            for persistentStore in persistentStores {
                if let persistentStoreURL = persistentStore.URL where !removeStoreWithURL(persistentStoreURL, error: error) {
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
    
    class func deleteStorageWithName(storageName: String?, error: NSErrorPointer = nil) -> Bool {
        close()
        
        if let defaultStorageURL = defaultStorageURLWithName(storageName) {
            return removeStoreWithURL(defaultStorageURL, error: error)
        }
        
        return false
    }
    
    // MARK: - Private methods
    
    private class func defaultStorageURLWithName(storageName: String?) -> NSURL? {
        if let documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as? NSURL {
            if let storageName = storageName {
                return documentDirectory.URLByAppendingPathComponent("\(storageName).sqlite")
            } else {
                return documentDirectory.URLByAppendingPathComponent("MAGCoreDataDefaultStorage.sqlite")
            }
        }
        
        return nil
    }
    
    private class func removeStoreWithURL(storeURL: NSURL, error: NSErrorPointer) -> Bool {
        return NSFileManager.defaultManager().removeItemAtURL(storeURL, error: error)
    }
    
    private func didSetAutoMergeFromChildContexts() {
        if autoMergeFromChildContexts {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { notification in
                if let context = notification.object as? NSManagedObjectContext {
                    if context != self.mainContext && context.persistentStoreCoordinator == self.persistentStoreCoordinator {
                        self.mainContext.performBlock {
                            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
                        }
                    }
                }
            }
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
}