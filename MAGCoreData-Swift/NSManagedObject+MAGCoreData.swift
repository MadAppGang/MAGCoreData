//
//  NSManagedObject+MAGCoreData.swift
//  MAGCoreData
//
//  Created by Dmytro Lisitsyn on 25.05.15.
//  Copyright (c) 2015 Dmytro Lisitsyn. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    // MARK: - Properties
    
    private struct AssociatedKey {
        static var AttributesNamesMap = "MAGCoreDataAttributesNamesMap"
        static var AttributesValuesTransformers = "MAGCoreDataAttributesValuesTransformers"
        static var RelationClasses = "MAGCoreDataRelationClasses"
        static var DatesFormats = "MAGCoreDataDatesFormats"
        static var DefaultDateFormat = "MAGCoreDataDefaultDateFormat"
        static var PrimaryKeyName = "MAGCoreDataPrimaryKeyName"
        static var DateUpdatedAttributeName = "MAGCoreDataDateUpdatedAttributeName"
    }
    
    static var attributesNamesMap: [String: String]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.AttributesNamesMap) as? [String: String]
        }
        set(attributesNamesMap) {
            objc_setAssociatedObject(self, &AssociatedKey.AttributesNamesMap, attributesNamesMap, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var attributesValuesTransformers: [String: AnyObject]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.AttributesValuesTransformers) as? [String: AnyObject]
        }
        set(attributesValuesTransformers) {
            objc_setAssociatedObject(self, &AssociatedKey.AttributesValuesTransformers, attributesValuesTransformers, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var relationClasses: [String: AnyClass]? { // AnyClass???
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.RelationClasses) as? [String: AnyClass]
        }
        set(relationClasses) {
            objc_setAssociatedObject(self, &AssociatedKey.RelationClasses, relationClasses, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))

        }
    }
    
    static var datesFormats: [String: String]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DatesFormats) as? [String: String]
        }
        set(datesFormats) {
            objc_setAssociatedObject(self, &AssociatedKey.DatesFormats, datesFormats, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var defaultDateFormat: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DefaultDateFormat) as? String
        }
        set(defaultDateFormat) {
            objc_setAssociatedObject(self, &AssociatedKey.DefaultDateFormat, defaultDateFormat, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var primaryKeyName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.PrimaryKeyName) as? String
        }
        set(primaryKeyName) {
            objc_setAssociatedObject(self, &AssociatedKey.PrimaryKeyName, primaryKeyName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    static var dateUpdatedAttributeName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DateUpdatedAttributeName) as? String
        }
        set(dateUpdatedAttributeName) {
            objc_setAssociatedObject(self, &AssociatedKey.DateUpdatedAttributeName, dateUpdatedAttributeName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }

    // MARK: - Public
    
    // MARK: ManagedObject creating
    
    class func create<T: NSManagedObject>() -> T {
        return createInContext(MAGCoreData.context)
    }
    
    class func createInContext<T: NSManagedObject>(context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context) as! T
    }
    
    class func createWithAttributes<T: NSManagedObject>(attributes: [String: AnyObject]) -> T {
        return createWithAttributes(attributes, inContext: MAGCoreData.context)
    }
    
    class func createWithAttributes<T: NSManagedObject>(attributes: [String: AnyObject], inContext context: NSManagedObjectContext) -> T {
        var managedObject = createInContext(context)
        managedObject.setAttributes(attributes)
        return managedObject as! T
    }
    
    // MARK: ManagedObjects receiving
    
    class func all(error: NSErrorPointer) -> [NSManagedObject] {
        return allInContext(MAGCoreData.context, error: error)
    }
    
    class func allInContext(context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, error: NSErrorPointer) -> [NSManagedObject] {
        return allOrderedBy(orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func allOrderedBy(orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, error: NSErrorPointer) -> [NSManagedObject] {
        return allForPredicate(predicate, inContext: MAGCoreData.context, error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, error: NSErrorPointer) -> [NSManagedObject] {
        return allForPredicate(predicate, orderedBy: orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func allForPredicate(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [NSManagedObject] {
            return managedObjects
        }
        
        return []
    }
    
    // MARK: First ManagedObject receiving
    
    class func first<T: NSManagedObject>(error: NSErrorPointer) -> T? {
        return firstInContext(MAGCoreData.context, error: error)
    }
    
    class func firstInContext<T: NSManagedObject>(context: NSManagedObjectContext, error: NSErrorPointer) -> T? {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.fetchLimit = 1
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [T] {
            return managedObjects.first
        }
        
        return nil
    }
    
    class func firstForPredicate<T: NSManagedObject>(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, error: NSErrorPointer) -> T? {
        return firstForPredicate(predicate, orderedBy: orderingKey, ascending: ascending, inContext: MAGCoreData.context, error: error)
    }
    
    class func firstForPredicate<T: NSManagedObject>(predicate: NSPredicate, orderedBy orderingKey: String, ascending: Bool, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> T? {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: orderingKey, ascending: ascending)]
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [T] {
            return managedObjects.first
        }
        
        return nil
    }
    
    class func firstForAttribute<T: NSManagedObject>(attributeName: String, attributeValue: AnyObject, error: NSErrorPointer) -> T? {
        return firstForAttribute(attributeName, attributeValue: attributeValue, inContext: MAGCoreData.context, error: error) as? T
    }
    
    class func firstForAttribute<T: NSManagedObject>(attributeName: String, attributeValue: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> T? {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "%K == %@", attributeName, attributeValue as! NSObject) // NSObject??
        fetchRequest.predicate = predicate
        
        if let managedObjects = context.executeFetchRequest(fetchRequest, error: error) as? [T] {
            return managedObjects.first
        }
        
        return nil
    }

    // MARK: ManagedObjects deletion
    
    class func deleteAll(error: NSErrorPointer) {
        deleteAllInContext(MAGCoreData.context, error: error)
    }
    
    class func deleteAllInContext(context: NSManagedObjectContext, error: NSErrorPointer) {
        for managedObject in allInContext(context, error: error) {
            managedObject.delete()
        }
    }
    
    func delete() {
        managedObjectContext?.deleteObject(self)
    }
    
    // MARK: Common
    
    func setShouldMerge(shouldMerge: Bool) {
        managedObjectContext?.refreshObject(self, mergeChanges: shouldMerge)
    }
    
    func setAttributes(attributesForSet: [String: AnyObject]) {
        setAttributes(attributesForSet, inContext: MAGCoreData.context)
    }
    
    func setAttributes(attributesForSet: [String: AnyObject], inContext context: NSManagedObjectContext) {
        let attributesNamesMap = self.dynamicType.attributesNamesMap
        
        if shouldUpdateWithAttributes(attributesForSet) {
            for (currentAttributeName, currentAttributeValue) in entity.attributesByName {
                if let currentAttributeName = currentAttributeName as? String {
                    var nameForAttribute = currentAttributeName
                    if let attributesNamesMap = attributesNamesMap, mappedNameForAttribute = attributesNamesMap[currentAttributeName] {
                        nameForAttribute = mappedNameForAttribute
                    }
                    
                    if let attributeForSetValue: AnyObject = attributesForSet[nameForAttribute] {
                        let typedValue: AnyObject? = self.dynamicType.typedAttributeValue(attributeForSetValue, attributeName: currentAttributeName, attributeType: currentAttributeValue.attributeType)
                        setValue(typedValue, forKey: currentAttributeName)
                    }
                }
            }
        }
        
        if let relationClasses = self.dynamicType.relationClasses {
            for (relationClassName, relationClassValue) in relationClasses {
                var relationName = relationClassName
                if let attributesNamesMap = attributesNamesMap, mappedAttributeName = attributesNamesMap[relationName] {
                    relationName = mappedAttributeName
                }
                
                if let attributes = attributesForSet[relationName] as? [String: AnyObject] {
                    createRelationshipToOneForRelationName(relationClassName, relationKey: relationName, attributes: attributes, inContext: context)
                } else if let attributesArray = attributesForSet[relationName] as? [[String: AnyObject]] {
                    createRelationshipToManyForRelationName(relationClassName, relationKey: relationName, attributesArray: attributesArray, inContext: context)
                }
            }
        }
    }
    
    
    class func objectForPrimaryKey(primaryKey: AnyObject, error: NSErrorPointer) -> NSManagedObject? {
        return objectForPrimaryKey(primaryKey, inContext: MAGCoreData.context, error: error)
    }
    
    class func objectForPrimaryKey(primaryKey: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSManagedObject? {
        if let primaryKeyName = primaryKeyName {
            return firstForAttribute(primaryKeyName, attributeValue: primaryKey, inContext: context, error: error)
        }
        
        return nil
    }
    
    class func getOrCreateObjectForPrimaryKey(primaryKey: AnyObject, error: NSErrorPointer) -> NSManagedObject? {
        return getOrCreateObjectForPrimaryKey(primaryKey, inContext: MAGCoreData.context, error: error)
    }
    
    class func getOrCreateObjectForPrimaryKey(primaryKey: AnyObject, inContext context: NSManagedObjectContext, error: NSErrorPointer) -> NSManagedObject? {
        if let primaryKeyName = primaryKeyName {
            if let managedObject = firstForAttribute(primaryKeyName, attributeValue: primaryKey, inContext: context, error: error) {
                return managedObject
            } else {
                return createInContext(context)
            }
        }
        
        return nil
    }
    
    class func safeCreateOrUpdateWithAttributes(attributes: [String: AnyObject]) -> NSManagedObject? {
        return safeCreateOrUpdateWithAttributes(attributes, inContext: MAGCoreData.context)
    }
    
    class func safeCreateOrUpdateWithAttributes(attributes: [String: AnyObject], inContext context: NSManagedObjectContext) -> NSManagedObject? {
        if let attributesNamesMap = attributesNamesMap,
            primaryKeyName = primaryKeyName,
            entityDescription = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: context),
            primaryKeyAttributeDescription: AnyObject = entityDescription.attributesByName[primaryKeyName] {
                let attributeType = primaryKeyAttributeDescription.attributeType
                if let mappedPrimaryKey = attributesNamesMap[primaryKeyName], primaryKeyValue: AnyObject = attributes[mappedPrimaryKey] {
                    if let typedPrimaryValue: AnyObject = typedAttributeValue(primaryKeyValue, attributeName: primaryKeyName, attributeType: attributeType) {
                        var error: NSError?
                        let selfManagedObject = getOrCreateObjectForPrimaryKey(typedPrimaryValue, inContext: context, error: &error)
                        selfManagedObject?.setAttributes(attributes, inContext: context)
                        return selfManagedObject
                    }
                }
        }
        
        return nil
    }
    
    private func stringByFirstCharUppercased(string: String) -> String {
        return string.stringByReplacingCharactersInRange(string.startIndex...string.startIndex, withString: String(string[string.startIndex]).uppercaseString)
    }

    private class func entityName() -> String {
        return NSStringFromClass(self)
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
        if let attributesNamesMap = self.dynamicType.attributesNamesMap,
            dateUpdatedAttributeName = self.dynamicType.dateUpdatedAttributeName,
            dateUpdatedAttributeForUpdateName = attributesNamesMap[dateUpdatedAttributeName],
            dateUpdatedAttributeForUpdateValue = attributesForUpdate[dateUpdatedAttributeForUpdateName] as? String,
            dateUpdatedForUpdate = self.dynamicType.dateFromString(dateUpdatedAttributeForUpdateValue, forAttribute: dateUpdatedAttributeName),
            dateUpdatedToUpdate = valueForKey(dateUpdatedAttributeName) as? NSDate where dateUpdatedToUpdate.compare(dateUpdatedForUpdate) != .OrderedAscending {
                return false
        }
        
        return true
    }
    
    private class func typedAttributeValue(attributeValue: AnyObject, attributeName: String, attributeType: NSAttributeType) -> AnyObject? {
        if let valueTransformers = attributesValuesTransformers, valueTransaformerForAttribute = valueTransformers[attributeName] as? (AnyObject) -> (AnyObject) {
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
    
    private func addManagedObject(managedObject: NSManagedObject, toRelation relation: String) { // FIXME:
        if let set = valueForKey(relation) as? NSSet {
            if !set.containsObject(managedObject) {
                // FIXME: performSelector
                
            }
        } else if let set = valueForKey(relation) as? NSOrderedSet {
            if !set.containsObject(managedObject) {
                // FIXME: performSelector
                
            }
        }
    }
    
    private func setManagedObject(managedObject: NSManagedObject?, forRelation relation: String) { // FIXME:
        if let valueForRelationKey = valueForKey(relation) as? NSManagedObject where valueForRelationKey != managedObject {
            // FIXME: performSelector
        }
    }
    
    private func createRelationshipToOneForRelationName(relationName: String, relationKey: String, attributes: [String: AnyObject], inContext context: NSManagedObjectContext) {
        if let relationshipDescription = entity.relationshipsByName[relationName] as? NSRelationshipDescription, relationClasses = self.dynamicType.relationClasses, objectClass: AnyClass = relationClasses[relationName] {
            if let managedObject = objectClass.safeCreateOrUpdateWithAttributes(attributes, inContext: context) {
                if relationshipDescription.toMany {
                    addManagedObject(managedObject, toRelation: relationName)
                } else {
                    setManagedObject(managedObject, forRelation: relationName)
                }
            }
        }
    }
    
    private func createRelationshipToManyForRelationName(relationName: String, relationKey: String, attributesArray: [[String: AnyObject]], inContext context: NSManagedObjectContext) {
        setManagedObject(nil, forRelation: relationName)
        
        for attributesItem in attributesArray {
            createRelationshipToOneForRelationName(relationName, relationKey: relationKey, attributes: attributesItem, inContext: context)
        }
    }
}
