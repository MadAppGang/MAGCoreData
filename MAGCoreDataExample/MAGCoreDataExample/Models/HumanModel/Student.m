#import "Student.h"
#import "NSManagedObject+MAGCoreData.h"

@interface Student ()

// Private interface goes here.

@end

@implementation Student

+ (void)initialize {
    [self setKeyMapping:@{@"identifier": @"id", @"name": @"name"}];
    [self setPrimaryKeyName:@"identifier"];
}

@end
