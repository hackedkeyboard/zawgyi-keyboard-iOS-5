#import <Foundation/Foundation.h>
#define plistPath @"/System/Library/Frameworks/UIKit.framework/Keyboard-cs.plist"

@interface MMKeyboardRemover : NSObject {}
- (BOOL) alterPrefValue;
@end

@implementation MMKeyboardRemover

- (BOOL) alterPrefValue
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [dict setObject:@"Odvolat akci" forKey:@"UI-Undo"];
    [dict setObject:@"čekat" forKey:@"UI-Wait"];
    [dict setObject:@"Mezerník" forKey:@"UI-Space"];
    [dict setObject:@"Hledat" forKey:@"UI-Search"];
    [dict setObject:@"Trasa" forKey:@"UI-Route"];
    [dict setObject:@"Enter" forKey:@"UI-Return"];
    [dict setObject:@"Znovu" forKey:@"UI-Redo"];
    [dict setObject:@"pauza" forKey:@"UI-Pause"];
    [dict setObject:@"Dále" forKey:@"UI-Next"];
    [dict setObject:@"Připojit" forKey:@"UI-Join"];
    [dict setObject:@"Otevřít" forKey:@"UI-Go"];
    [dict setObject:@"Done" forKey:@"UI-Done"];
    [dict setObject:@"odmítnout" forKey:@"UI-Dismiss"];
    [dict setObject:@"přijmout" forKey:@"UI-Confirm"];
    [dict setObject:@"Čeština" forKey:@"UI-LanguageIndicator"];
    [dict setObject:@"Odeslat" forKey:@"UI-Send"];
    [dict setObject:@"Hotovo" forKey:@"UI-Done"];
    
    BOOL status = [dict writeToFile:plistPath atomically:YES];
    [dict release];
    return status;
}

@end

int main(int argc, char **argv, char **envp) 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    MMKeyboardRemover *installer = [[MMKeyboardRemover alloc] init];
    BOOL status = [installer alterPrefValue];
    [installer release];
    [pool release];
    NSLog(@"gotta go!! bye");
    return (status ? 0 : 1);
}
