// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to School.h instead.

#import <CoreData/CoreData.h>

extern const struct SchoolAttributes {
	__unsafe_unretained NSString *identifier;
} SchoolAttributes;

extern const struct SchoolRelationships {
	__unsafe_unretained NSString *students;
} SchoolRelationships;

@class Student;

@interface SchoolID : NSManagedObjectID {}
@end

@interface _School : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SchoolID* objectID;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *students;

- (NSMutableSet*)studentsSet;

@end

@interface _School (StudentsCoreDataGeneratedAccessors)
- (void)addStudents:(NSSet*)value_;
- (void)removeStudents:(NSSet*)value_;
- (void)addStudentsObject:(Student*)value_;
- (void)removeStudentsObject:(Student*)value_;

@end

@interface _School (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSMutableSet*)primitiveStudents;
- (void)setPrimitiveStudents:(NSMutableSet*)value;

@end
