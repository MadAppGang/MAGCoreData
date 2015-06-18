#import "Weather.h"
#import "NSManagedObject+MAGCoreData.h"

@interface Weather ()
@end

@implementation Weather

+ (void)initialize {
    [self setKeyMapping:@{
                          @"identifier"  : @"id",
                          @"city"        : @"city",
                          @"temperature" : @"temperature"
                          }];
    [self setPrimaryKeyName:@"identifier"];
}

@end
