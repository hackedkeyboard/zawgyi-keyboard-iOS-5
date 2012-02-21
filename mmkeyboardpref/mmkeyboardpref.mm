#import <Preferences/Preferences.h>
#define kURL @"cydia://package/com.w00tylab.mmkeyboardpref"

@interface mmkeyboardprefListController: PSListController {
}

- (void) openCydia:(id)sender;
- (void) openTwitter:(id)sender;
- (void) cleanCaches:(id) sender;
- (void) openWebsite:(id)sender;

@end

@implementation mmkeyboardprefListController

- (id)specifiers 
{
	if(_specifiers == nil)
		_specifiers = [[self loadSpecifiersFromPlistName:@"mmkeyboardpref" target:self] retain];
	return _specifiers;
}

- (void) cleanCaches:(id) sender
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:@"/var/mobile/Library/Caches/com.apple.keyboards" error:NULL];
    
    system("killall -9 SpringBoard");
}

- (void) openCydia:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL]];
}

- (void) openWebsite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wootylab.com/mmkeyboard"]];
}

- (void) openTwitter:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetie://"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetie:@moeseth"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) 
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/moeseth"]];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow me" message:@"www.twitter.com/moeseth" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

@end

// vim:ft=objc
