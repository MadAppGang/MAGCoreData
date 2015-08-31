// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to School.m instead.

#import "_School.h"

const struct SchoolAttributes SchoolAttributes = {
	.identifier = @"identifier",
};

const struct SchoolRelationships SchoolRelationships = {
	.students = @"students",
};

@implementation SchoolID
@end

@implementation _School

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"School";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"School" inManagedObjectContext:moc_];
}

- (SchoolID*)objectID {
	return (SchoolID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic identifier;

- (int64_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result longLongValue];
}

- (void)setIdentifierValue:(int64_t)value_ {
	[self setIdentifier:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result longLongValue];
}

- (void)setPrimitiveIdentifierValue:(int64_t)value_ {
	[self setPrimitiveIdentifier:[NSNumber numberWithLongLong:value_]];
}

@dynamic students;

- (NSMutableSet*)studentsSet {
	[self willAccessValueForKey:@"students"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"students"];

	[self didAccessValueForKey:@"students"];
	return result;
}

@end

