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

### Adding objects / Updating objects
To create and insert a new instance of an Entity in the default context you can use:
```objective-c
Weather *weather = [Weather create];
Weather *weather = [Weather createFromDictionary:dictionary];
Weather *weather = [Weather safeCreateOrUpdateWithDictionary:dictionary];
```

You can also create and insert an entity into specific context:
```objective-c
Weather *weather = [Weather createInContext:context];
Weather *weather = [Weather createFromDictionary:dictionary inContext:context];
Weather *weather = [Weather safeCreateOrUpdateWithDictionary:dictionary inContext:context];
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

### Fetching objects
```objective-c
Weather *weather = [Weather getOrCreateObjectForPrimaryKey:primaryKey];
Weather *weather = [Weather getOrCreateObjectForPrimaryKey:primaryKey inContext:context];
```

### Mapping

### Logging
```
#ifdef MAGCOREDATA_LOGGING_ENABLED
```
## License
MAGCoreData is released under the MIT license. See LICENSE for details.
