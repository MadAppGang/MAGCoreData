// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Student.h instead.

#import <CoreData/CoreData.h>

extern const struct StudentAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} StudentAttributes;

extern const struct StudentRelationships {
	__unsafe_unretained NSString *school;
} StudentRelationships;

@class School;

@interface StudentID : NSManagedObjectID {}
@end

@interface _Student : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) StudentID* objectID;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) School *school;

//- (BOOL)validateSchool:(id*)value_ error:(NSError**)error_;

@end

@interface _Student (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (School*)primitiveSchool;
- (void)setPrimitiveSchool:(School*)value;

@end
