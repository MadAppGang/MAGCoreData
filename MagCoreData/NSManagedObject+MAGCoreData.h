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
//Inline relation classes for recursive instantination
+ (NSDictionary *)relationClasses;
+ (void)setRelationClasses:(NSDictionary *)newRelationClasses;
//DefaultDateFormat
//regarding:
//https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW1
//http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns for iOS6
//http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns for iOS6
//http://www.unicode.org/reports/tr35/tr35-17.html#Date_Format_Patterns for iOS4.3
+ (NSString*)defaultDateFormat;
+ (void)setDefaultDateFormat:(NSString*)dateFormat;
//DateFormatForEveryField
+ (NSDictionary *)dateFormats;
+ (void)setDateFormats:(NSDictionary *)datesFormat;




- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;


+ (instancetype)create ;
+ (instancetype)createInContext:(NSManagedObjectContext*)context;
+ (instancetype)createFromDictionary:(NSDictionary *)dictionary;
+ (instancetype)createFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext*)context;
@end
