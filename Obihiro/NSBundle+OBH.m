#import "NSBundle+OBH.h"
#import <objc/runtime.h>

static NSBundle *OBHLocalizedBundle = nil;

@implementation NSBundle (OBH)

+ (void)setMessageLocalizationLocale:(NSString *)localeString {
    NSString *path = [[NSBundle mainBundle] pathForResource:localeString ofType:@"lproj"];
    OBHLocalizedBundle = [NSBundle bundleWithPath:path];
}

#pragma mark -

+ (void)load {
    [self swap:@selector(localizedStringForKey:value:table:) to:@selector(OBH_localizedStringForKey:value:table:)];
}

+ (void)swap:(SEL)from to:(SEL)to {
    Method fromMethod = class_getInstanceMethod(self, from);
    Method toMethod = class_getInstanceMethod(self, to);
    method_exchangeImplementations(fromMethod, toMethod);
}

- (NSString *)OBH_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    if (OBHLocalizedBundle) {
        return [OBHLocalizedBundle OBH_localizedStringForKey:key value:value table:tableName];
    } else {
        return [self OBH_localizedStringForKey:key value:value table:tableName];
    }
}

@end
