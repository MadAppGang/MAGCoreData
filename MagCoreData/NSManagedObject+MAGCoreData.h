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
+ (NSDictionary *)keyMapping;
+ (void)setKeyMapping:(NSDictionary*)mapping;
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

+ (instancetype)objectWithID:(NSManagedObjectID *)managedObjectID;
+ (instancetype)objectWithID:(NSManagedObjectID *)managedObjectID inContext:(NSManagedObjectContext *)context;

+ (instancetype)objectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;
+ (instancetype)objectForPrimaryKey:(id)primaryKey;

+ (instancetype)getOrCreateObjectForPrimaryKey:(id)primaryKey;
+ (instancetype)getOrCreateObjectForPrimaryKey:(id)primaryKey inContext:(NSManagedObjectContext *)context;

+ (instancetype)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues;
+ (instancetype)safeCreateOrUpdateWithDictionary:(NSDictionary *)keyedValues inContext:(NSManagedObjectContext *)context;


+ (instancetype)create;
+ (instancetype)createInContext:(NSManagedObjectContext *)context;
+ (instancetype)createFromDictionary:(NSDictionary *)dictionary;
+ (instancetype)createFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

#pragma mark - fetching objects
+ (NSArray *)all;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allInContext:(NSManagedObjectContext*)context;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (id)first;
+ (id)firstWithKey:(NSString *)key value:(id)value;
+ (id)firstForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (id)firstForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;


+ (id)firstInContext:(NSManagedObjectContext *)context;
+ (id)firstWithKey:(NSString *)key value:(id)value inContext:(NSManagedObjectContext *)context;

#pragma mark - deleting objects
+ (void)deleteAll;
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;
- (void)delete;

#pragma mark - refreshing object
- (void)refreshMerging:(BOOL)merging;

@end
