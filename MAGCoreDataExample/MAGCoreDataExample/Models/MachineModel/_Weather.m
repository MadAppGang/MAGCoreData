// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Weather.m instead.

#import "_Weather.h"

const struct WeatherAttributes WeatherAttributes = {
	.city = @"city",
	.fog = @"fog",
	.identifier = @"identifier",
	.temperature = @"temperature",
};

@implementation WeatherID
@end

@implementation _Weather

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Weather";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:moc_];
}

- (WeatherID*)objectID {
	return (WeatherID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"fogValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fog"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"temperatureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"temperature"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic city;

@dynamic fog;

- (BOOL)fogValue {
	NSNumber *result = [self fog];
	return [result boolValue];
}

- (void)setFogValue:(BOOL)value_ {
	[self setFog:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFogValue {
	NSNumber *result = [self primitiveFog];
	return [result boolValue];
}

- (void)setPrimitiveFogValue:(BOOL)value_ {
	[self setPrimitiveFog:[NSNumber numberWithBool:value_]];
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

@dynamic temperature;

- (float)temperatureValue {
	NSNumber *result = [self temperature];
	return [result floatValue];
}

- (void)setTemperatureValue:(float)value_ {
	[self setTemperature:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTemperatureValue {
	NSNumber *result = [self primitiveTemperature];
	return [result floatValue];
}

- (void)setPrimitiveTemperatureValue:(float)value_ {
	[self setPrimitiveTemperature:[NSNumber numberWithFloat:value_]];
}

@end

