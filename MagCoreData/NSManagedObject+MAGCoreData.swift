//
//  NSManagedObject+MAGCoreData.swift
//  MAGCoreData
//
//  Created by MadAppGang on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    // MARK: - Properties
    
    private struct AssociatedKey {
        static var KeyMapping = "NSManagedObjectMagCoreDataMappingKey"
        static var ValueTransformers = "NSManagedObjectValueTransformersKey"
        static var RelationClasses = "NSManagedObjectMagCoreDataRelationsKey"
        static var DatesFormats = "NSManagedObjectMagCoreDataDatesFormatKey"
        static var DefaultDateFormat = "NSManagedObjectMagCoreDataDefaultDateFormatKey"
        static var PrimaryKeyName = "NSManagedObjectMagCoreDataPrimaryKeyNameKey"
        static var UpdateDateKeyName = "NSManagedObjectMagCoreDataUpdateDateKey"
    }
    
    static var keyMapping: [String: String]? {
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.KeyMapping) as? [String: String]
        }
        set(keyMapping) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.KeyMapping, keyMapping, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var valueTransformers: [String: AnyObject]? {
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.ValueTransformers) as? [String: AnyObject]
        }
        set(valueTransformers) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.ValueTransformers, valueTransformers, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var relationClasses: [String: AnyObject.Type]? {
        get {
            if let relationClassesDictionary = objc_getAssociatedObject(classForCoder(), &AssociatedKey.RelationClasses) as? NSDictionary {
                var returnedRelationClasses = [String: AnyObject.Type]()
                for (relationName, relationValue) in relationClassesDictionary {
                    if let relationName = relationName as? String, relationValue: AnyClass = relationValue.classForCoder {
                        returnedRelationClasses[relationName] = relationValue
                    }
                }
                return returnedRelationClasses
            }
            return nil
        }
        set(relationClasses) {
            if let relationClasses = relationClasses {
                var relationClassesDictionary = NSMutableDictionary()
                for (relationName, relationClass) in relationClasses {
                    relationClassesDictionary[relationName] = relationClass
                }
                objc_setAssociatedObject(classForCoder(), &AssociatedKey.RelationClasses, relationClassesDictionary, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
            } else {
                objc_setAssociatedObject(classForCoder(), &AssociatedKey.RelationClasses, nil, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
            }
        }
    }
    
    static var datesFormats: [String: String]? {
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.DatesFormats) as? [String: String]
        }
        set(datesFormats) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.DatesFormats, datesFormats, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var defaultDateFormat: String? {
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.DefaultDateFormat) as? String
        }
        set(defaultDateFormat) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.DefaultDateFormat, defaultDateFormat, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var primaryKeyName: String? {
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.PrimaryKeyName) as? String
        }
        set(primaryKeyName) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.PrimaryKeyName, primaryKeyName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var updateDateKeyName: String? { // FIXME: Не всегда сохраняет.
        get {
            return objc_getAssociatedObject(classForCoder(), &AssociatedKey.UpdateDateKeyName) as? String
        }
        set(updateDateKeyName) {
            objc_setAssociatedObject(classForCoder(), &AssociatedKey.UpdateDateKeyName, updateDateKeyName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    private static var entityName: String {
        return NSStringFromClass(self)
    }
    
    // MARK: - Public
    
    // MARK: ManagedObject creating
    
    class func create() -> NSManagedObject {
        return createInContext(MAGCoreData.context)
    }
    
    class func createInContext(context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! NSManagedObject
    }
    
    class func createFromDictionary(dictionary: [String: AnyObject]) -> NSManagedObject {
        return createFromDictionary(dictionary, inContext: MAGCoreData.context)
    }
    
    class func createFromDictionary(dictionary: [String: AnyObject], inContext context: NSManagedObjectContext) -> NSManagedObject {
        var managedObject = createInContext(context)
        managedObject.safeSetValuesForKeysWithDictionary(dictionary, inContext: context)
        return managedObject
    }
    
    // MARK: ManagedObjects receiving
    
    class func all(error: NSErrorPointer = nil) -> [NSManagedObject] {
        return allInContext(MAGCoreData.context, error: error)
    }
    
    class func allInContext(context: NSManagedObjectContext, error: NSErrorPointer = nil) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, error: NSErrorPointer = nil) -> [NSManagedObject] {
        return allOrderedBy(orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, error: NSErrorPointer = nil) -> [NSManagedObject] {
        return allForPredicate(predicate, inContext: MAGCoreData.context, error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, error: NSErrorPointer = nil) -> [NSManagedObject] {
        return allForPredicate(predicate, orderedBy: orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    // MARK: First ManagedObject receiving
    
    class func first(error: NSErrorPointer = nil) -> NSManagedObject? {
        return firstInContext(MAGCoreData.context, error: error)
    }
    
    class func firstInContext(context: NSManagedObjectContext, error: NSErrorPointer = nil) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects.first
        }
        
        return nil
    }
    
    class func firstForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, error: NSErrorPointer = nil) -> NSManagedObject? {
        return firstForPredicate(predicate, orderedBy: orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func firstForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects.first
        }
        
        return nil
    }
    
    class func firstWithKey(key: String, value: AnyObject, error: NSErrorPointer = nil) -> NSManagedObject? {
        return firstWithKey(key, value: value, inContext: MAGCoreData.context, error: error)
    }
    
    class func firstWithKey(key: String, value: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "%K == %@", key, value as! NSObject) // NSObject??
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects.first
        }
        
        return nil
    }

    // MARK: ManagedObjects deletion
    
    class func deleteAll(error: NSErrorPointer = nil) {
        deleteAllInContext(MAGCoreData.context, error: error)
    }
    
    class func deleteAllInContext(context: NSManagedObjectContext, error: NSErrorPointer = nil) {
        for managedObject in allInContext(context, error: error) {
            managedObject.delete()
        }
    }
    
    func delete() {
        managedObjectContext?.deleteObject(self)
    }
    
    // MARK: Common
    
    func refreshMerging(merging: Bool) {
        managedObjectContext?.refreshObject(self, mergeChanges: merging)
    }
    
    func safeSetValuesForKeysWithDictionary(keyedValues: [String: AnyObject]) {
        safeSetValuesForKeysWithDictionary(keyedValues, inContext: MAGCoreData.context)
    }
    
    func safeSetValuesForKeysWithDictionary(keyedValues: [String: AnyObject], inContext context: NSManagedObjectContext) {
        let attributesNamesMap = self.dynamicType.keyMapping
        
        if shouldUpdateWithAttributes(keyedValues) {
            for (currentAttributeName, currentAttributeValue) in entity.attributesByName {
                if let currentAttributeName = currentAttributeName as? String {
                    var nameForAttribute = currentAttributeName
                    if let attributesNamesMap = attributesNamesMap, mappedNameForAttribute = attributesNamesMap[currentAttributeName] {
                        nameForAttribute = mappedNameForAttribute
                    }
                    
                    if let attributeForSetValue: AnyObject = keyedValues[nameForAttribute] {
                        let typedValue: AnyObject? = self.dynamicType.typedAttributeValue(attributeForSetValue, attributeName: currentAttributeName, attributeType: currentAttributeValue.attributeType)
                        setValue(typedValue, forKey: currentAttributeName)
                    }
                }
            }
        }

        if let relationClasses = self.dynamicType.relationClasses {
            for (relationClassName, _) in relationClasses {
                var relationName = relationClassName
                if let attributesNamesMap = attributesNamesMap, mappedAttributeName = attributesNamesMap[relationName] {
                    relationName = mappedAttributeName
                }
                
                if let attributes = keyedValues[relationName] as? [String: AnyObject] {
                    createRelationshipToOneForRelationName(relationClassName, relationKey: relationName, attributes: attributes, inContext: context)
                } else if let attributesArray = keyedValues[relationName] as? [[String: AnyObject]] {
                    createRelationshipToManyForRelationName(relationClassName, relationKey: relationName, attributesArray: attributesArray, inContext: context)
                }
            }
        }
    }
    
    class func objectForPrimaryKey(primaryKey: AnyObject, error: NSErrorPointer = nil) -> NSManagedObject? {
        return objectForPrimaryKey(primaryKey, inContext: MAGCoreData.context, error: error)
    }
    
    class func objectForPrimaryKey(primaryKey: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> NSManagedObject? {
        if let primaryKeyName = primaryKeyName {
            return firstWithKey(primaryKeyName, value: primaryKey, inContext: context, error: error)
        }
        
        return nil
    }
    
    class func getOrCreateObjectForPrimaryKey(primaryKey: AnyObject, error: NSErrorPointer = nil) -> NSManagedObject {
        return getOrCreateObjectForPrimaryKey(primaryKey, inContext: MAGCoreData.context, error: error)
    }
    
    class func getOrCreateObjectForPrimaryKey(primaryKey: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer = nil) -> NSManagedObject {
        if let primaryKeyName = primaryKeyName, managedObject = firstWithKey(primaryKeyName, value: primaryKey, inContext: context, error: error) {
            return managedObject
        }
        
        return createInContext(context)
    }
    
    class func safeCreateOrUpdateWithDictionary(keyedValues: [String: AnyObject]) -> NSManagedObject {
        return safeCreateOrUpdateWithDictionary(keyedValues, inContext: MAGCoreData.context)
    }
    
    class func safeCreateOrUpdateWithDictionary(keyedValues: [String: AnyObject], inContext context: NSManagedObjectContext) -> NSManagedObject {
        if let attributesNamesMap = keyMapping,
            primaryKeyName = primaryKeyName,
            entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context),
            primaryKeyAttributeDescription: AnyObject = entityDescription.attributesByName[primaryKeyName],
            mappedPrimaryKey = attributesNamesMap[primaryKeyName],
            primaryKeyValue: AnyObject = keyedValues[mappedPrimaryKey],
            typedPrimaryValue: AnyObject = typedAttributeValue(primaryKeyValue, attributeName: primaryKeyName, attributeType: primaryKeyAttributeDescription.attributeType) {
                var error: NSError?
                let selfManagedObject = getOrCreateObjectForPrimaryKey(typedPrimaryValue, inContext: context, error: &error)
                selfManagedObject.safeSetValuesForKeysWithDictionary(keyedValues, inContext: context)
                return selfManagedObject
        }
        
        return createFromDictionary(keyedValues, inContext: context)
    }
    
    private func stringByFirstCharUppercased(string: String) -> String {
        return string.stringByReplacingCharactersInRange(string.startIndex...string.startIndex, withString: String(string[string.startIndex]).uppercaseString)
    }
    
    private class func dateFromString(string: String, forAttribute attributeName: String) -> NSDate? {
        let dateFormat: String
        if let datesFormats = datesFormats, dateFormatForAttribute = datesFormats[attributeName] {
            dateFormat = dateFormatForAttribute
        } else if let defaultDateFormat = defaultDateFormat {
            dateFormat = defaultDateFormat
        } else {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        if let rangeOfString = dateFormat.rangeOfString("ZZZZZ") where distance(dateFormat.startIndex, rangeOfString.startIndex) == NSNotFound {
            dateFormatter.dateFormat = dateFormat
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        }
        
        return dateFormatter.dateFromString(string)
    }
    
    private func shouldUpdateWithAttributes(attributesForUpdate: [String: AnyObject]) -> Bool {
        if let attributesNamesMap = self.dynamicType.keyMapping,
            dateUpdatedAttributeName = self.dynamicType.updateDateKeyName,
            dateUpdatedAttributeForUpdateName = attributesNamesMap[dateUpdatedAttributeName],
            dateUpdatedAttributeForUpdateValue = attributesForUpdate[dateUpdatedAttributeForUpdateName] as? String,
            dateUpdatedForUpdate = self.dynamicType.dateFromString(dateUpdatedAttributeForUpdateValue, forAttribute: dateUpdatedAttributeName),
            dateUpdatedToUpdate = valueForKey(dateUpdatedAttributeName) as? NSDate where dateUpdatedToUpdate.compare(dateUpdatedForUpdate) != .OrderedAscending {
                return false
        }
        
        return true
    }
    
    private class func typedAttributeValue(attributeValue: AnyObject, attributeName: String, attributeType: NSAttributeType) -> AnyObject? {
        if let valueTransformers = valueTransformers, valueTransaformerForAttribute = valueTransformers[attributeName] as? (AnyObject) -> (AnyObject) {
            return valueTransaformerForAttribute(attributeValue)
        } else if let attributeValueNumber = attributeValue as? NSNumber where attributeType == .StringAttributeType {
            return attributeValueNumber.stringValue
        } else if let attributeValue = attributeValue as? String where attributeType == .Integer16AttributeType || attributeType == .Integer32AttributeType || attributeType == .Integer64AttributeType || attributeType == .BooleanAttributeType {
            if let attributeValueNumber = NSNumberFormatter().numberFromString(attributeValue) {
                return attributeValueNumber.integerValue
            }
        } else if let attributeValue = attributeValue as? String where attributeType == .FloatAttributeType || attributeType == .DoubleAttributeType {
            if let attributeValueNumber = NSNumberFormatter().numberFromString(attributeValue) {
                return attributeValueNumber.doubleValue
            }
        } else if let attributeValue = attributeValue as? String where attributeType == .DateAttributeType {
            return dateFromString(attributeValue, forAttribute: attributeName)
        }
        
        return attributeValue
    }
    
    private func addManagedObject(managedObject: NSManagedObject, toRelation relation: String) {
        if let set: AnyObject = valueForKey(relation) where (set is NSSet || set is NSOrderedSet) && !set.containsObject(managedObject) {
            NSThread.detachNewThreadSelector(Selector("add\(stringByFirstCharUppercased(relation))Object:"), toTarget:self, withObject: managedObject)
        }
    }
    
    private func setManagedObject(managedObject: NSManagedObject?, forRelation relation: String) {
        if let valueForRelationKey = valueForKey(relation) as? NSManagedObject where valueForRelationKey != managedObject {
            NSThread.detachNewThreadSelector(Selector("set\(stringByFirstCharUppercased(relation))"), toTarget:self, withObject: managedObject)
        }
    }
    
    private func createRelationshipToManyForRelationName(relationName: String, relationKey: String, attributesArray: [[String: AnyObject]], inContext context: NSManagedObjectContext) {
        setManagedObject(nil, forRelation: relationName)
        
        for attributesItem in attributesArray {
            createRelationshipToOneForRelationName(relationName, relationKey: relationKey, attributes: attributesItem, inContext: context)
        }
    }

    private func createRelationshipToOneForRelationName(relationName: String, relationKey: String, attributes: [String: AnyObject], inContext context: NSManagedObjectContext) {
        if let relationshipDescription = entity.relationshipsByName[relationName] as? NSRelationshipDescription, relationClasses = self.dynamicType.relationClasses, objectClass: AnyClass = relationClasses[relationName] {
            let managedObject = objectClass.safeCreateOrUpdateWithDictionary(attributes, inContext: context)
            if relationshipDescription.toMany {
                addManagedObject(managedObject, toRelation: relationName)
            } else {
                setManagedObject(managedObject, forRelation: relationName)
            }
            
        }
    }
}
