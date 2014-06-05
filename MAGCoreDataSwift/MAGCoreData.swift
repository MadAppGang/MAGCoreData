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
    
    init() {
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
        
        /*
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
            NSInferMappingModelAutomaticallyOption:@(YES)};
        if (![mag.persistentStore addPersistentStoreWithType:NSSQLiteStoreType
            configuration:nil
            URL:[self defaultStorageURLWithName:storageName]
            options:options
            error:error]) {
                NSLog(@"MAGCoreData: Error creating persistent store:%@", *error);
                return NO;
        }
        */
        
        self.mainContext = NSManagedObjectContext(concurrencyType:NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
//        self.mainContext.persistentStoreCoordinator = self.persistentStore
        
        return true;
    }

}