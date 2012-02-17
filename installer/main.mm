#import <Foundation/Foundation.h>

#define plistPath @"/System/Library/Frameworks/UIKit.framework/Keyboard-cs.plist"

@interface MMKeyboardInstaller : NSObject {}
- (BOOL) alterPrefValue;
@end

@implementation MMKeyboardInstaller

- (BOOL) alterPrefValue
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [dict setObject:@"undo" forKey:@"UI-Undo"];
    [dict setObject:@"Wait" forKey:@"UI-Wait"];
    [dict setObject:@"Space" forKey:@"UI-Space"];
    [dict setObject:@"Search" forKey:@"UI-Search"];
    [dict setObject:@"Route" forKey:@"UI-Route"];
    [dict setObject:@"Return" forKey:@"UI-Return"];
    [dict setObject:@"redo" forKey:@"UI-Redo"];
    [dict setObject:@"Pause" forKey:@"UI-Pause"];
    [dict setObject:@"Next" forKey:@"UI-Next"];
    [dict setObject:@"Join" forKey:@"UI-Join"];
    [dict setObject:@"Go" forKey:@"UI-Go"];
    [dict setObject:@"Done" forKey:@"UI-Done"];
    [dict setObject:@"Dismiss" forKey:@"UI-Dismiss"];
    [dict setObject:@"Confirm" forKey:@"UI-Confirm"];
    [dict setObject:@"Zawgyi" forKey:@"UI-LanguageIndicator"];
    [dict setObject:@"Send" forKey:@"UI-Send"];
    [dict setObject:@"Done" forKey:@"UI-Done"];

    BOOL status = [dict writeToFile:plistPath atomically:YES];
    [dict release];

    return status;
}

@end

int main(int argc, char **argv, char **envp) 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    MMKeyboardInstaller *installer = [[MMKeyboardInstaller alloc] init];
    BOOL status = [installer alterPrefValue];
    [installer release];
    [pool release];
    NSLog(@"@moeseth in your device! :D");
    return (status ? 0 : 1);
}
