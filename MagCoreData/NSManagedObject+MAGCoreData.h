//
//  NSManagedObject+MAGCoreData.h
//  TopMission
//
//  Created by Ievgen Rudenko on 8/30/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MAGCoreData)

//Key mapping of local names and web service names, key of dictionary is local name and value is web service name
+ (NSDictionary * __nullable)keyMapping;
+ (void)setKeyMapping:(NSDictionary *)mapping;
//Inline relation classes for recursive instantiation
+ (NSDictionary *)relationClasses;
+ (void)setRelationClasses:(NSDictionary *)newRelationClasses;
//DefaultDateFormat
//regarding:
//https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW1
//http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns for iOS6
//http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns for iOS6
//http://www.unicode.org/reports/tr35/tr35-17.html#Date_Format_Patterns for iOS4.3
+ (NSString *)defaultDateFormat;
+ (void)setDefaultDateFormat:(NSString *)dateFormat;
//DateFormatForEveryField
+ (NSDictionary *)dateFormats;
+ (void)setDateFormats:(NSDictionary *)datesFormat;

//Object unique of external data format
//When it found an object in local model, the object edited instead of inserting,
//if no object found - new object creating
+ (id)primaryKeyName;
+ (void)setPrimaryKeyName:(id)primaryKey;

+ (id)updateDateKeyName;
+ (void)setUpdateDateKeyName:(id)updateKeyName;

//custom values transformers
+ (NSDictionary *)valueTransformers;
+ (void)setValueTransformers:(NSDictionary *)valueTransformers;



- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues inContext:(NSManagedObjectContext *)context;

NS_ASSUME_NONNULL_BEGIN
+ (__kindof NSManagedObject *)objectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;
+ (__kindof NSManagedObject *)objectForPrimaryKey:(id)primaryKey;

+ (__kindof NSManagedObject *)getOrCreateObjectForPrimaryKey:(id)primaryKey;
+ (__kindof NSManagedObject *)getOrCreateObjectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;

+ (__kindof NSManagedObject *)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues;
+ (__kindof NSManagedObject *)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues inContext:(NSManagedObjectContext *)context;


+ (__kindof NSManagedObject *)create;
+ (__kindof NSManagedObject *)createInContext:(NSManagedObjectContext *)context;
+ (__kindof NSManagedObject *)createFromDictionary:(NSDictionary *)dictionary;
+ (__kindof NSManagedObject *)createFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;


#pragma mark - fetching objects
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)all;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allForPredicate:(NSPredicate *)predicate;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allInContext:(NSManagedObjectContext*)context;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allForPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray<__kindof NSManagedObjectContext*> * __nullable)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (__kindof NSManagedObject * __nullable)first;
+ (__kindof NSManagedObject * __nullable)firstWithKey:(NSString *)key value:(id)value;
+ (__kindof NSManagedObject * __nullable)firstForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (__kindof NSManagedObject * __nullable)firstForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;


+ (__kindof NSManagedObject * __nullable)firstInContext:(NSManagedObjectContext *)context;
+ (__kindof NSManagedObject * __nullable)firstWithKey:(NSString *)key value:(id)value inContext:(NSManagedObjectContext * __nullable)context;

#pragma mark - deleting objects
+ (void)deleteAll;
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;
- (void)delete;

#pragma mark - refreshing object
- (void)refreshMerging:(BOOL)merging;

@end

NS_ASSUME_NONNULL_END
