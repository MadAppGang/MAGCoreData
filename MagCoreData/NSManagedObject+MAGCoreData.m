//
//  NSManagedObject+MAGCoreData.m
//  TopMission
//
//  Created by Ievgen Rudenko on 8/30/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//
#import "NSManagedObject+MAGCoreData.h"
#import "MAGCoreData.h"
#import "ISO8601DateFormatter.h"
#import <objc/runtime.h>

static NSString const * kKeyMapKey = @"NSManagedObjectMagCoreDataMappingKey";
static NSString const * kRelationsKey = @"NSManagedObjectMagCoreDataRelationsKey";
static NSString const * kDatesFormatKey = @"NSManagedObjectMagCoreDataDatesFormatKey";
static NSString const * kDefaultDateFormatKey = @"NSManagedObjectMagCoreDataDefaultDateFormatKey";


@implementation NSManagedObject (MAGCoreData)


+ (NSDictionary *)keyMapping {
    return objc_getAssociatedObject(self, &kKeyMapKey);
}

+ (void)setKeyMapping:(NSDictionary *)keyMapping {
    objc_setAssociatedObject(self, &kKeyMapKey, keyMapping, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


+ (NSDictionary *)relationClasses {
    return objc_getAssociatedObject(self, &kRelationsKey);

}

+ (void)setRelationClasses:(NSDictionary *)newRelationClasses {
    objc_setAssociatedObject(self, &kRelationsKey, newRelationClasses, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSDictionary *)dateFormats {
    return objc_getAssociatedObject(self, &kDatesFormatKey);
}

+ (void)setDateFormats:(NSDictionary *)datesFormat {
    objc_setAssociatedObject(self, &kDatesFormatKey, datesFormat, OBJC_ASSOCIATION_COPY_NONATOMIC);

}


+ (NSString *)defaultDateFormat {
    return objc_getAssociatedObject(self, &kDefaultDateFormatKey);
}

+ (void)setDefaultDateFormat:(NSString *)dateFormat {
    objc_setAssociatedObject(self, &kDefaultDateFormatKey, dateFormat, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    //TODO: Rule is it neccesery ?
//    if ([super respondsToSelector:@selector(safeSetValuesForKeysWithDictionary:)])
//        [super performSelector:@selector(safeSetValuesForKeysWithDictionary:) withObject:keyedValues];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    NSDictionary *mapping = [[self class] keyMapping];
    //attributes
    for (NSString *attribute in attributes) {
        NSString *attributeKey = mapping?mapping[attribute]:attribute;
        id value = keyedValues[attributeKey];
        if (value == nil) {
            // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        } else if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value  integerValue]];
        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
            NSString *df = [[self class] defaultDateFormat];
            NSString *specificDF = [[self class] dateFormats][attribute];
            df = specificDF?specificDF:df;
            if (df) {
//                ISO8601 timezone +XX:XX not available on iOS<6.x, that is why using ISO8601 date formater:
                if ([df rangeOfString:@"ZZZZZ"].location == NSNotFound) {
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    dateFormatter.dateFormat = df;
                    value = [dateFormatter dateFromString:value];
                } else {
                    ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];
                    value = [dateFormatter dateFromString:value];
                }
            }  else {
                //prevent from crash
                NSLog(@"Unable to parse date (no date format specified):%@",value);
                value= nil;

            }
        }
        [self setValue:value forKey:attribute];
    }

    NSDictionary *relationsClasses = [[self class] relationClasses];
    for (NSString * relationName in [relationsClasses allKeys]) {
        NSString *relationKey = mapping?mapping[relationName]:relationName;
        id value = keyedValues[relationKey];
        if (value && [value isKindOfClass:[NSDictionary class]]) {
            NSRelationshipDescription *relationshipDescription = [[self entity] relationshipsByName][relationName];
            if (relationshipDescription) {
                Class objectClass = relationsClasses[relationName];
                NSManagedObject *object = [objectClass createInContext:self.managedObjectContext];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if (relationshipDescription.isToMany) {
                    //the object not created, so everything ok
                    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"add%@Object:",[relationKey capitalizedString]]) withObject:object];
                } else {
                    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@:",[relationKey capitalizedString]]) withObject:object];
                }
#pragma clang diagnostic pop
                //fill recursevly from dictionary
                [object safeSetValuesForKeysWithDictionary:value];
            }
        }
    }



}

#pragma mark - easy object manipulation
+ (id)create {
    return [self createInContext:[MAGCoreData context]];
}

+ (id)createInContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context);
    __block NSManagedObject *object = nil;
    [context performBlockAndWait:^{
        object =  [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.class) inManagedObjectContext:context];
    }];
    return object;
}

+ (instancetype)createFromDictionary:(NSDictionary *)dictionary {
    return [self createFromDictionary:dictionary inContext:[MAGCoreData context]];
}

+ (instancetype)createFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext*)context {
    NSParameterAssert(context);
    NSManagedObject * object = [self createInContext:context];
    [context performBlockAndWait:^{
        [object safeSetValuesForKeysWithDictionary:dictionary];
    }];
    return object;
}


@end
