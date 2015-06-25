<center>![MAGCoreData](http://i.imgur.com/anoiYlP.png)</center>
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/MAGCoreData.svg)](https://img.shields.io/cocoapods/v/MAGCoreData.svg)
<b>master branch:</b> [![Build Status](https://travis-ci.org/MadAppGang/MAGCoreData.svg?branch=master)](https://travis-ci.org/MadAppGang/MAGCoreData)
<b>develop branch:</b>[![Build Status](https://travis-ci.org/MadAppGang/MAGCoreData.svg?branch=develop)](https://travis-ci.org/MadAppGang/MAGCoreData)
## Index
- [What is MAGCoreData?](#what-is-magcoredata)
- [Requirement](#requirement)
- [Installation with CocoaPods](#installation-with-cocoapods)
- [Usage](#usage)
    - [Initialization](#initialization)
    - [Managed object contexts](#managed-object-contexts)
    - [Adding objects](#adding-objects)
    - [Updating objects](#updating-objects)
    - [Fetching objects](#fetching-objects)
    - [Saving objects](#saving-objects)
    - [Deleting objects](#deleting-objects)
    - [Mapping](#mapping)
    - [Relation classes](#relation-classes)
    - [Value transformers](#value-transformers)
    - [Deleting storage](#deleting-storage)
    - [Logging](#logging)
- [Mogenerator](#mogenerator)
- [Credits](#credits)
- [License](#license)

## What is MAGCoreData?
Core Data boilerplate code killer.

## Requirement
- iOS 7.0+
- Xcode 6.3

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager of Cocoa projects, which automates and simplifies the process of using 3rd-party libraries in your projects

### Podfile
```ruby
pod 'MAGCoreData', '~> 0.0.4'
```

## Usage
### Initialization

MAGCoreData setup:
```objective-c
[MAGCoreData prepareCoreData];
[MAGCoreData instance].autoMergeFromChildContexts = YES;
```

You can also use one of the following setup calls with the MAGCoreData class to initialize:
```objective-c
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;
```

### Managed object contexts
To access the default context you can call:
```objective-c
NSManagedObjectContext *defaultContext = MAGCoreData.context;
```

If you need to create a new managed object context for usage in non-main threads you can use the following method:
```objective-c
NSManagedObjectContext *privateContext = MAGCoreData.createPrivateContext;
```

### Adding objects
To create and insert a new instance of an Entity in the default context you can use:
```objective-c
Weather *weather = [Weather create];
Weather *weather = [Weather createFromDictionary:dictionary];
```

You can also create and insert an object into specific context:
```objective-c
Weather *weather = [Weather createInContext:context];
Weather *weather = [Weather createFromDictionary:dictionary inContext:context];
```

### Updating objects
To update objects you should specify primary key. See ['Mapping'](#mapping) section for additional instructions.

To update or create a new object:
```objective-c
Weather *weather = [Weather safeCreateOrUpdateWithDictionary:dictionary];
```

To update or create an object in specific context:
```objective-c
Weather *weather = [Weather safeCreateOrUpdateWithDictionary:dictionary inContext:context];
```

To update an object, change the object’s property, primary key value may be updated:
```objective-c
[weather safeSetValuesForKeysWithDictionary:dictionary];
```

### Fetching objects
```objective-c
Weather *weather = [Weather objectForPrimaryKey:primaryKey];
Weather *weather = [Weather getOrCreateObjectForPrimaryKey:primaryKey];
Weather *weather = [Weather first];
...
NSArray *array = [Weather all];
NSArray *array = [Weather allOrderedBy:@"temperature" ascending:YES];
NSArray *array = [Weather allForPredicate:predicate orderBy:@"temperature" ascending:YES];
...
```
Also you can use any of these calls with specific context.

### Saving objects
You probably should save data after any changes you have made, because if the application crashes you're going to loss all the changes.

To save data:
```objective-c
[MAGCoreData save];
```
or
```objective-c
[MAGCoreData saveContext:context];
```

### Deleting objects

To delete a single object in the default context:
```objective-c
[weatherObject delete];
```

To delete all objects in the default context:
```objective-c
[Weather deleteAll];
```

To delete all objects in a specific context:
```objective-c
[Weather deleteAllInContext:context];
```

### Mapping
Example of usage:
```objective-c
#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"

@interface Weather ()
@end

@implementation Weather

+ (void)initialize {
    [self setKeyMapping:@{
                          @"identifier"  : @"id",
                          @"city"        : @"city",
                          @"temperature" : @"temperature",
                          @"updatedAt"   : @"updatedAt"
                          }];
    [self setPrimaryKeyName:@"identifier"];
    [self setUpdateDateKeyName:@"updatedAt"];
    [self setDateFormats:@{@"updatedAt":@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"}];
}

@end

```

```objective-c
Weather *weather = [Weather createFromDictionary:@{@"id": @"1", @"city": @"Glasgow", @"temperature": @"17"}];
NSLog(@"%@", weather.identifier); // 1
NSLog(@"%@", weather.city); // Glasgow
NSLog(@"%@", weather.temperature); // 17
```

#### Auto-mapping
The feature allows to set properties automatically if the key dictionary and the object's property name are the same.
```objective-c
Student *student = [Student createFromDictionary:@{@"identifier": @"1", @"name": @"Marcus"}];
NSLog(@"id = %@", student.identifier); // 1
NSLog(@"name = %@", student.name); // Marcus
```

### Relation classes

Example of usage:
```objective-c
@implementation School
+ (void)initialize {
    [self setKeyMapping:@{@"identifier": @"id", @"students": @"students"}];
    [self setPrimaryKeyName:@"identifier"];
    
    [self setRelationClasses:@{@"students": [Student class]}];
}
@end
```

```objective-c
@implementation Student
+ (void)initialize {
    [self setKeyMapping:@{@"identifier": @"id", @"name": @"name"}];
    [self setPrimaryKeyName:@"identifier"];
}
@end
```

```objective-c
NSDictionary *dictionary = @{@"id": @"1", @"students": @[@{@"id": @"1", @"name": @"Marcus"}, @{@"id": @"2", @"name": @"Livia"}]};
School *school = [School createFromDictionary:dictionary];
NSLog(@"First student's name is %@", ((Student *)school.students.allObjects[0]).name); // Marcus
NSLog(@"Second student's name is %@", ((Student *)school.students.allObjects[1]).name); // Livia
```

### Value transformers
Example of usage:
```objective-c
+ (void)initialize {
    [self setKeyMapping:@{@"fog": @"fog"}];
    [self setValueTransformers:@{@"fog": ^id(id value) { return @(((NSString *)value).boolValue); }}];
}
```

```objective-c
Weather *weather = [Weather createFromDictionary:@{@"fog": @"YES"}];
NSLog(@"Fog = %@", weather.fog); // 1
```

### Deleting storage

To delete all the data from the first persistent store in the persistent store coordinator:
```objective-c
[MAGCoreData deleteAll];
```

To drop the storage with a default name:
```objective-c
[MAGCoreData deleteAllInStorageWithName:nil];
```

To drop the storage with a specific name:
```objective-c
[MAGCoreData deleteAllInStorageWithName:storageName];
```

### Logging
You can define Preprocessor Macros `MAGCOREDATA_LOGGING_ENABLED` which enable MAGCoreData logging.


## Mogenerator
We recommend you to use [mogenerator](https://github.com/rentzsch/mogenerator). Mogenerator generates the model classes from Core Data model (.xcdatamodel) and adds helper functions for your classes to simplify their usage.

Mogenerator script example:
```
mogenerator -m "${PROJECT_DIR}/MAGCoreDataExample/Models/Model.xcdatamodeld/Model.xcdatamodel" -M "${PROJECT_DIR}/MAGCoreDataExample/Models/MachineModel" -H "${PROJECT_DIR}/MAGCoreDataExample/Models/HumanModel" --template-var arc=true
```

* * *

## Credits
MAGCoreData is owned and maintained by the [MadAppGang](http://madappgang.com/).

## License
MAGCoreData is released under the MIT license. See LICENSE for details.
