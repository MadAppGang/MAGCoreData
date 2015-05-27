//
//  NSManagedObject+MAGCoreData.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    private struct AssociatedKey {
        static var KeyMap = "NSManagedObjectMAGCoreDataMappingKey"
        static var Relations = "NSManagedObjectMAGCoreDataRelationsKey"
        static var DateFormats = "NSManagedObjectMAGCoreDataDateFormatsKey"
        static var DefaultDateFormat = "NSManagedObjectMAGCoreDataDefaultDateFormatKey"
        static var PrimaryKeyName = "NSManagedObjectMAGCoreDataPrimaryKeyNameKey"
        static var UpdateDate = "NSManagedObjectMAGCoreDataUpdateDateKey"
        static var ValueTransformers = "NSManagedObjectValueTransformersKey"
    }
    
    class func keyMapping() -> [String: AnyObject]? {
        return objc_getAssociatedObject(self, &AssociatedKey.KeyMap) as? [String: AnyObject]
    }
    
    class func setKeyMapping(keyMapping: [String: AnyObject]) {
        objc_setAssociatedObject(self, &AssociatedKey.KeyMap, keyMapping, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func valueTransformers() -> [String: AnyObject]? {
        return objc_getAssociatedObject(self, &AssociatedKey.ValueTransformers) as? [String: AnyObject]
    }
    
    class func setValueTransformers(valueTransformers: [String: AnyObject]) {
        objc_setAssociatedObject(self, &AssociatedKey.ValueTransformers, valueTransformers, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func relationClasses() -> [String: AnyObject]? {
        return objc_getAssociatedObject(self, &AssociatedKey.Relations) as? [String: AnyObject]
    }
    
    class func setRelationClasses(relationClasses: [String: AnyObject]) {
        objc_setAssociatedObject(self, &AssociatedKey.Relations, relationClasses, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func dateFormats() -> [String: AnyObject]? {
        return objc_getAssociatedObject(self, &AssociatedKey.DateFormats) as? [String: AnyObject]
    }
    
    class func setDateFormats(dateFormats: [String: AnyObject]) {
        objc_setAssociatedObject(self, &AssociatedKey.DateFormats, dateFormats, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func defaultDateFormat() -> String? {
        return objc_getAssociatedObject(self, &AssociatedKey.DefaultDateFormat) as? String
    }
    
    class func setDefaultDateFormat(dateFormat: String) {
        objc_setAssociatedObject(self, &AssociatedKey.DefaultDateFormat, dateFormat, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func primaryKeyName() -> String? {
        return objc_getAssociatedObject(self, &AssociatedKey.PrimaryKeyName) as? String
    }
    
    class func setPrimaryKeyName(primaryKey: String) {
        objc_setAssociatedObject(self, &AssociatedKey.PrimaryKeyName, primaryKey, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    class func updateDateKeyName() -> String? {
        return objc_getAssociatedObject(self, &AssociatedKey.UpdateDate) as? String
    }
    
    private class func entityName() -> String {
        return NSStringFromClass(self)
    }
    
    class func setUpdateDateKeyName(updateDateKeyName: String) {
        objc_setAssociatedObject(self, &AssociatedKey.UpdateDate, updateDateKeyName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    func safeSetValuesForKeys(keyedValues: [String: AnyObject]) {
        safeSetValuesForKeysWithKeyedValues(keyedValues, inContext: MAGCoreData.context())
    }
    
    class func dateFromObject(object: AnyObject, forAttribute attribute: AnyObject) -> NSDate? {
        let objectString = "\(object)"
        let attributeString = "\(attribute)"
        
        let dateFormat: String
        if let dateFormats = dateFormats(), dateFormatForAttribute = dateFormats[attributeString] as? String {
            dateFormat = dateFormatForAttribute
        } else if let defaultDateFormat = defaultDateFormat() {
            dateFormat = defaultDateFormat
        } else {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        if let rangeOfString = dateFormat.rangeOfString("ZZZZZ") where distance(dateFormat.startIndex, rangeOfString.startIndex) == NSNotFound {
            dateFormatter.dateFormat = dateFormat
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        }
        
        return dateFormatter.dateFromString(objectString)
    }
    
    func shouldUpdateForKeyedValues(keyedValues: [String: AnyObject]) -> Bool {
        if let mapping = self.dynamicType.keyMapping(),
            updateDateKey = self.dynamicType.updateDateKeyName(),
            updateDateMappedKey = mapping[updateDateKey] as? String,
            keyedValueForUpdateDateMappedKey: AnyObject = keyedValues[updateDateMappedKey],
            remoteUpdateDate = self.dynamicType.dateFromObject(keyedValueForUpdateDateMappedKey, forAttribute: updateDateKey),
            localUpdateDate = valueForKey(updateDateKey) as? NSDate where localUpdateDate.compare(remoteUpdateDate) != .OrderedAscending {
                return false
        }
        
        return true
    }
    
    func safeSetValuesForKeysWithKeyedValues(keyedValues: [String: AnyObject], inContext context: NSManagedObjectContext) {
        let mapping = self.dynamicType.keyMapping()
        
        if shouldUpdateForKeyedValues(keyedValues) {
            for (key, value) in entity.attributesByName {
                if let attributeKey = key as? String {
                    var keyForKeyedValue = attributeKey
                    if let mapping = mapping, mappingForAttribute = mapping[attributeKey] as? String {
                        keyForKeyedValue = mappingForAttribute
                    }
                    
                    if let keyedValue: AnyObject = keyedValues[attributeKey] { // FIXME AnyObject
                        let safeValue: AnyObject? = self.dynamicType.safeValueMappedFromKeyedValue(keyedValue, attribute: attributeKey, attributeType: value.attributeType)
                        setValue(safeValue, forKey: attributeKey)
                    }
                }
            }
        }
        
        if let relationClasses = self.dynamicType.relationClasses() {
            for (key, value) in relationClasses {
                var relationKey = key
                if let mapping = mapping, mappingForRelationKey = mapping[relationKey] as? String {
                    relationKey = mappingForRelationKey
                }
                
                if let value = keyedValues[relationKey] as? [String: AnyObject] {
                    // FIXME: createRelationshipToManyForRelationName
                } else if let value = keyedValues[relationKey] as? [AnyObject] {
                    createRelationshipToManyForRelationName(key, relationKey: relationKey, value: value, inContext: context)
                }
            }
        }
    }
    
    class func safeValueMappedFromKeyedValue(keyedValue: AnyObject, attribute: String, attributeType: NSAttributeType) -> AnyObject? {
        
        if let valueTransformers = valueTransformers(), valueTransaformerForAttribute: AnyObject = valueTransformers[attribute], transformer = valueTransaformerForAttribute as? (AnyObject) -> (AnyObject) {
            return transformer(keyedValue)
        } else if let keyedValue = keyedValue as? NSNumber where attributeType == .StringAttributeType {
            return keyedValue.stringValue
        } else if let keyedValue = keyedValue as? String where attributeType == .Integer16AttributeType || attributeType == .Integer32AttributeType || attributeType == .Integer64AttributeType || attributeType == .BooleanAttributeType {
            if let keyedValueNumber = NSNumberFormatter().numberFromString(keyedValue) {
                return keyedValueNumber.integerValue
            }
        } else if let keyedValue = keyedValue as? String where attributeType == .FloatAttributeType || attributeType == .DoubleAttributeType {
            if let keyedValueNumber = NSNumberFormatter().numberFromString(keyedValue) {
                return keyedValueNumber.doubleValue
            }
        } else if let keyedValue = keyedValue as? String where attributeType == .DateAttributeType {
            return dateFromObject(keyedValue, forAttribute: attribute)
        }
        
        return nil
    }
    
    func createRelationshipToManyForRelationName(relationName: String, relationKey: String, value: AnyObject, inContext context: NSManagedObjectContext) {
        setObject(nil, forRelation: relationName)
        
        
    }
    
    func createRelationshipForRelationName(relationName: String, relationKey: String, value: AnyObject, inContext context: NSManagedObjectContext) {
        if let relationshipDescription = entity.relationshipsByName[relationName] as? NSRelationshipDescription, relationClasses = self.dynamicType.relationClasses {
            let objectClass = relationClasses[relationName]
        }
    }
    
    private func stringByFirstLetterCap(string: String) -> String {
        return string.stringByReplacingCharactersInRange(string.startIndex...string.startIndex, withString: String(string[string.startIndex]).capitalizedString)
    }
    
    func addObject(object: NSManagedObjectContext, toRelation relation: String) {
        if let set = valueForKey(relation) as? NSSet {
            if !set.containsObject(object) {
                // FIXME: performSelector
    
            }
        } else if let set = valueForKey(relation) as? NSOrderedSet {
            if !set.containsObject(object) {
                // FIXME: performSelector

            }
        }
    }
    
    func setObject(object: NSManagedObject?, forRelation relation: String) {
        if let valueForRelationKey = valueForKey(relation) as? NSManagedObject where valueForRelationKey != object {
            
        }
    }
    
    class func create() -> NSManagedObject {
        return createInContext(MAGCoreData.context())
    }
    
    class func createInContext(context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context) as! NSManagedObject
    }
    
    class func createWithKeyedValues(keyedValues: [String: AnyObject]) -> NSManagedObject {
        return createWithKeyedValues(keyedValues, inContext: MAGCoreData.context())
    }
    
    class func createWithKeyedValues(keyedValues: [String: AnyObject], inContext context: NSManagedObjectContext) -> NSManagedObject {
        var object = createInContext(context)
        object.safeSetValuesForKeys(keyedValues)
        return object
    }
    
    class func all(error: NSErrorPointer) -> [NSManagedObject] {
        return allInContext(MAGCoreData.context(), error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, error: NSErrorPointer) -> [NSManagedObject] {
        return allForPredicate(predicate, inContext: MAGCoreData.context(), error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedByKey orderingKey: String, ascending: Bool, error: NSErrorPointer) -> [NSManagedObject] {
        return allForPredicate(predicate, orderedByKey: orderingKey, ascending: ascending, inContext: MAGCoreData.context(), error: error)
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, error: NSErrorPointer) -> [NSManagedObject] {
        return allOrderedBy(orderingKey, ascending: ascending, inContext: MAGCoreData.context(), error: error)
    }
    
    class func allInContext(context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName())
        
        if let elements = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return elements
        }
        
        return []
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName())
        request.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        
        if let elements = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return elements
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName())
        request.predicate = predicate
        
        if let elements = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return elements
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedByKey orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName())
        request.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        request.predicate = predicate
        
        if let elements = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return elements
        }
        
        return []
    }
    
    class func first(error: NSErrorPointer) -> NSManagedObject? {
        return firstInContext(MAGCoreData.context(), error: error)
    }
    
    class func firstWithKey(key: String, value: AnyObject, error: NSErrorPointer) -> NSManagedObject? {
        return firstWithKey(key, value: value, inContext: MAGCoreData.context(), error: error)
    }
    
    class func firstForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, error: NSErrorPointer) -> NSManagedObject? {
        return firstForPredicate(predicate, orderedBy: orderingKey, ascending: ascending, inContext: MAGCoreData.context(), error: error)
    }
    
    class func firstForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSManagedObject? {
        let sortDescriptor = NSSortDescriptor(key: orderingKey, ascending: ascending)
        let request = NSFetchRequest(entityName: entityName())
        request.fetchLimit = 1
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        if let objects = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return objects.first
        }
        
        return nil
    }
    
    class func firstInContext(context: NSManagedObjectContext, error: NSErrorPointer) -> NSManagedObject? {
        let request = NSFetchRequest(entityName: entityName())
        request.fetchLimit = 1
        
        if let objects = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return objects.first
        }
        
        return nil
    }
    
    class func firstWithKey(key: String, value: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSManagedObject? {
        let predicate = NSPredicate(format: "%K == %@", key, value as! NSObject) // NSObject??
        let request = NSFetchRequest(entityName: entityName())
        request.fetchLimit = 1
        request.predicate = predicate
        
        if let objects = context.executeFetchRequest(request, error: error) as? [NSManagedObject] {
            return objects.first
        }
        
        return nil
    }
        
    class func deleteAll(error: NSErrorPointer) {
        deleteAllInContext(MAGCoreData.context(), error: error)
    }
    
    class func deleteAllInContext(context: NSManagedObjectContext, error: NSErrorPointer) {
        for object in allInContext(context, error: error) {
            object.delete()
        }
    }
    
    func delete() {
        if let managedObjectContext = managedObjectContext {
            managedObjectContext.deleteObject(self)
        }
    }
    
    func refreshMerging(merging: Bool) {
        if let managedObjectContext = managedObjectContext {
            managedObjectContext.refreshObject(self, mergeChanges: merging)
        }
    }
}
