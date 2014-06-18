//
//  NSManagedObject+Association.swift
//  MAGCoreDataSwiftExample
//
//  Created by Alexander Malovichko on 6/10/14.
//  Copyright (c) 2014 MadAppGang. All rights reserved.
//

import Foundation

import CoreData

// TODO:: refactor weird code
var kKeyMapKeySelector:Selector = "NSManagedObjectMagCoreDataMappingKey"
var kRelationsKeySelector:Selector = "NSManagedObjectMagCoreDataRelationsKey"
var kDatesFormatKeySelector:Selector = "NSManagedObjectMagCoreDataDatesFormatKey"
var kDefaultDateFormatKeySelector:Selector = "NSManagedObjectMagCoreDataDefaultDateFormatKey"
var kPrimaryKeyNameKeySelector:Selector = "NSManagedObjectMagCoreDataPrimaryKeyNameKey"
var kUpdateDateKeySelector:Selector = "NSManagedObjectMagCoreDataUpdateDateKey"
var kValueTransformersKeySelector:Selector = "NSManagedObjectValueTransformersKey"

let kKeyMapKey:CConstVoidPointer = &kKeyMapKeySelector
let kRelationsKey:CConstVoidPointer = &kRelationsKeySelector
let kDatesFormatKey:CConstVoidPointer = &kDatesFormatKeySelector
let kDefaultDateFormatKey:CConstVoidPointer = &kDefaultDateFormatKeySelector
let kPrimaryKeyNameKey:CConstVoidPointer = &kPrimaryKeyNameKeySelector
let kUpdateDateKey:CConstVoidPointer = &kUpdateDateKeySelector
let kValueTransformersKey:CConstVoidPointer = &kValueTransformersKeySelector

extension NSManagedObject {
    
    /* Key mapping of local names and web service names, key of dictionary is local name and value is web service name
    */
    func keyMapping() -> Dictionary<String, String> {
        return objc_getAssociatedObject(self, kKeyMapKey) as Dictionary<String, String>
    }
    
    func setKeyMapping(keyMapping: Dictionary<String, String>) {
        objc_setAssociatedObject(self, kKeyMapKey, keyMapping, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }

    /* Inline relation classes for recursive instantiation
    */
    func relationClasses() -> Dictionary<String, String> {
        return objc_getAssociatedObject(self, kRelationsKey) as Dictionary<String, String>
    }
    
    func setRelationClasses(relationClasses: Dictionary<String, String>) {
        objc_setAssociatedObject(self, kRelationsKey, relationClasses, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    /* DefaultDateFormat
        regarding:
        https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW1
        http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns for iOS6
        http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns for iOS6
    */
    func defaultDateFormat() -> String {
        return objc_getAssociatedObject(self, kDefaultDateFormatKey) as String
    }
    
    func setDefaultDateFormat(dateFormat: String) {
         objc_setAssociatedObject(self, kDefaultDateFormatKey, dateFormat, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    /* DateFormatForEveryField
    */
    func dateFormats() -> Dictionary<String, String> {
        return objc_getAssociatedObject(self, kDatesFormatKey) as Dictionary<String, String>
    }
    
    func setDateFormats(dateFormats: Dictionary<String, String>) {
        objc_setAssociatedObject(self, kDatesFormatKey, dateFormats, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    /* Object unique of external data format
        When it found an object in local model, the object edited instead of inserting,
        if no object found - new object creating
    */
    func primaryKeyName() -> AnyObject {
        return objc_getAssociatedObject(self, kPrimaryKeyNameKey)
    }
    
    func setPrimaryKeyName(primaryKey: AnyObject) {
        objc_setAssociatedObject(self, kPrimaryKeyNameKey, primaryKey, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
    
    func updateDateKeyName() -> AnyObject {
        return objc_getAssociatedObject(self, kUpdateDateKey)
    }
    
    func setUpdateDatyKeyName(updateKeyName: AnyObject) {
        objc_setAssociatedObject(self, kUpdateDateKey, updateKeyName, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }

    /* Custom values transformers
    */
    func valueTransformers() -> Dictionary<String, String> {
        return objc_getAssociatedObject(self, kValueTransformersKey) as Dictionary<String, String>
    }
    
    func setValueTransformers(valueTransformers: Dictionary<String, String>) {
        objc_setAssociatedObject(self, kValueTransformersKey, valueTransformers, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
    }
}
