#MAGCoreData

Core Data boilerplate code killer.

## Requirement
- iOS 7.0+
- Xcode 6.3

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager Cocoa projects, which automates and simplifies the process of using 3rd-party libraries in your projects.

### Podfile
```ruby
pod 'MAGCoreData', '~> 0.0.4'
```

## Usage
### Initialization
Use one of the following setup calls with the MAGCoreData class:
```objective-c
+ (NSError *)prepareCoreData;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName error:(NSError **)error;
+ (BOOL)prepareCoreDataWithModelName:(NSString *)modelName andStorageName:(NSString *)storageName error:(NSError **)error;
```
### Managed object contexts
To access the default context you can call:
```objective-c
NSManagedObjectContext *defaultContext = MAGCoreData.context;
```

If you need to create a new managed object context for use in non-main threads you can use the following method:
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

To update or create new object:
```objective-c
Weather *weather = [Weather safeCreateOrUpdateWithDictionary:dictionary];
```

To update or create object in specific context:
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
```
Also you can use any of these calls with specific context.

### Saving objects
You probably should save data after any changes you have made, because if application crashes you're going to loss all the changes.
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

### Relation classes

### Value transformers

### Parsing the date

### Deleting storage

### Mogenerator
We recommend you use [mogenerator](https://github.com/rentzsch/mogenerator). Mogenerator generates the model classes from Core Data model (.xcdatamodel) and adds helper functions for your classes to simplify their usage.

To delete all data from first persistent store in persistent store coordinator:
```objective-c
[MAGCoreData deleteAll];
```

To drop storage with default name:
```objective-c
[MAGCoreData deleteAllInStorageWithName:nil];
```

To drop storage with specific name:
```objective-c
[MAGCoreData deleteAllInStorageWithName:storageName];
```

### Logging
```
#ifdef MAGCOREDATA_LOGGING_ENABLED
```

## Credits
MAGCoreData is owned and maintained by the [MadAppGang](http://madappgang.com/).

## License
MAGCoreData is released under the MIT license. See LICENSE for details.
