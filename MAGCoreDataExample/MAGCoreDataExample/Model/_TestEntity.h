// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TestEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct TestEntityAttributes {
	__unsafe_unretained NSString *name;
} TestEntityAttributes;

extern const struct TestEntityRelationships {
} TestEntityRelationships;

extern const struct TestEntityFetchedProperties {
} TestEntityFetchedProperties;




@interface TestEntityID : NSManagedObjectID {}
@end

@interface _TestEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TestEntityID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _TestEntity (CoreDataGeneratedAccessors)

@end

@interface _TestEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
