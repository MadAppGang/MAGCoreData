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
                          @"fog"         : @"fog"
                          }];
    [self setPrimaryKeyName:@"identifier"];
   
    [self setValueTransformers:@{@"fog": ^id(id value) { return @(((NSString *)value).boolValue); }}];
}

@end
