#import "School.h"
#import "NSManagedObject+MAGCoreData.h"
#import "Student.h"

@interface School ()

// Private interface goes here.

@end

@implementation School

+ (void)initialize {
    [self setKeyMapping:@{@"identifier": @"id", @"students": @"students"}];
    [self setPrimaryKeyName:@"identifier"];
    
    [self setRelationClasses:@{@"students": [Student class]}];
}

@end
