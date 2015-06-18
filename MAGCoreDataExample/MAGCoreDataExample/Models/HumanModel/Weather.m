#import "Weather.h"

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
