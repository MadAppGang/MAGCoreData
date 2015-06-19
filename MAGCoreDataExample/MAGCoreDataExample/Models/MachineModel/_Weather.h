// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Weather.h instead.

#import <CoreData/CoreData.h>

extern const struct WeatherAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *fog;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *temperature;
} WeatherAttributes;

@interface WeatherID : NSManagedObjectID {}
@end

@interface _Weather : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WeatherID* objectID;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* fog;

@property (atomic) BOOL fogValue;
- (BOOL)fogValue;
- (void)setFogValue:(BOOL)value_;

//- (BOOL)validateFog:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* temperature;

@property (atomic) float temperatureValue;
- (float)temperatureValue;
- (void)setTemperatureValue:(float)value_;

//- (BOOL)validateTemperature:(id*)value_ error:(NSError**)error_;

@end

@interface _Weather (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSNumber*)primitiveFog;
- (void)setPrimitiveFog:(NSNumber*)value;

- (BOOL)primitiveFogValue;
- (void)setPrimitiveFogValue:(BOOL)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveTemperature;
- (void)setPrimitiveTemperature:(NSNumber*)value;

- (float)primitiveTemperatureValue;
- (void)setPrimitiveTemperatureValue:(float)value_;

@end
