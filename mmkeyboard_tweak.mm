static BOOL isHookedKeyboard = NO;
static NSDictionary *dict = nil;
static BOOL isExtra = NO;

static NSString *convertToMyanmar(NSString *str)
{
    if (!dict)
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Library/Application Support/MMKeyboard/zawgyi.plist"];
    
    return [dict objectForKey:str];
}

@interface UIKeyboard
@end

@interface UIKeyboardLayout : UIView
@end

@interface UIKBTree
@property(retain, nonatomic) NSMutableDictionary* cache;
@property(retain, nonatomic) NSMutableArray *subtrees;
@property(retain, nonatomic) NSMutableDictionary *properties;
@property(retain, nonatomic) NSString *name;
@end

@interface UIKeyboardLayoutStar
@property(copy, nonatomic) NSString* keyplaneName;
@property(assign, nonatomic) BOOL shift;
@end

@interface UIKBKeyplaneView
@property(assign, nonatomic) UIKeyboardLayoutStar *layout;
@end

@interface UIKeyboardImpl
+ (id)activeInstance;
@end

@interface UIKBShape
@property(assign, nonatomic) CGRect paddedFrame;
@property(assign, nonatomic) CGRect frame;
@end

%hook UIKBTree
- (NSString *)displayString
{
    NSString *original = %orig;

    if (isExtra)
    {
        if ([original isEqualToString:@"."])
            return @"႐";
        else if ([original isEqualToString:@","])
            return @"ၫ";
        else if ([original isEqualToString:@"?"])
            return @"ႆ";
        else if ([original isEqualToString:@"!"])
            return @"ႁ";
        else if ([original isEqualToString:@"’"])
            return @"ႎ";
    }
    
    if (!isHookedKeyboard && !isExtra)
        return %orig;

    if (!original)
        return %orig;
    
    if ([original isEqualToString:@"international"] || [original isEqualToString:@"123"] || [original isEqualToString:@"delete"] || [original isEqualToString:@"more"])
        return %orig;
    
    if ([self.name hasPrefix:@"Latin-Small"])
        original = original.lowercaseString;
        
    NSString *toretrun = convertToMyanmar(original);
        
    if (toretrun)
        return toretrun;
    
    return %orig;
}

- (NSString *)representedString
{
    NSString *original = %orig;
    if (!isExtra && [original isEqualToString:@"'"] && isHookedKeyboard)
        return @"ဟ";

    if (isExtra)
    {
        if ([original isEqualToString:@"."])
            return @"႐";
        else if ([original isEqualToString:@","])
            return @"ၫ";
        else if ([original isEqualToString:@"?"])
            return @"ႆ";
        else if ([original isEqualToString:@"!"])
            return @"ႁ";
        else if ([original isEqualToString:@"'"])
            return @"ႎ";
    }
    
    if (!isHookedKeyboard && !isExtra)
        return %orig;

    if ([original isEqualToString:@"international"] || [original isEqualToString:@"123"] || [original isEqualToString:@"delete"] || [original isEqualToString:@"more"])
        return %orig;
    
    NSString *toretrun = convertToMyanmar(original);
    
    if (toretrun)
        return toretrun;
    
    return %orig;
}

- (id)subtreeWithName:(NSString *)name
{    
    if (isHookedKeyboard && [name hasPrefix:@"numbers"])
        return %orig;
    
    if ([name intValue] < 10)
        return %orig;
    
    if (isHookedKeyboard && [name hasPrefix:@"3136966873"])
        return %orig;
    
    if (isHookedKeyboard && [name hasPrefix:@"247755690"])
        return %orig;
    
    if (isHookedKeyboard && [name hasPrefix:@"2529512744"])
    {
        isExtra = NO;
        return %orig;
    }
    
    if (isHookedKeyboard && [name hasPrefix:@"772197114"])
    {
        isExtra = YES;
        return %orig;
    }
    
    if (isHookedKeyboard && [name hasPrefix:@"4152776063"])
    {
        isExtra = YES;
        return %orig;
    }
    
    isExtra = NO;
    
    if ([name hasPrefix:@"2841643449"] || [name hasPrefix:@"2014430901"] || [name hasPrefix:@"4213087982"] || [name hasPrefix:@"3258129580"] || [name hasPrefix:@"37950658"] || [name hasPrefix:@"1760372625"] || [name hasPrefix:@"2443595442"] || [name hasPrefix:@"1733078254"] || [name hasPrefix:@"3651175134"] || [name hasPrefix:@"3063867177"] || [name hasPrefix:@"1064426334"] || [name hasPrefix:@"1678219313"] || [name hasPrefix:@"2021188196"])
        isHookedKeyboard = YES;
    else
        isHookedKeyboard = NO;
            
    return %orig;
}
%end

%hook UIKeyboardLayoutStar
- (void)setKeyplaneName:(NSString *)name
{
    NSString *oldName = self.keyplaneName;
    %orig;
    
    if (name != nil && ![name isEqualToString:oldName]) 
    {
        NSMutableDictionary *dict = MSHookIvar<NSMutableDictionary *>(self, "_allKeyplaneViews");  
        NSArray *keys = [dict allKeys];
    
        for (NSString *key in keys) 
        {
            UIKBKeyplaneView *keyplaneView = [dict objectForKey:key];
            [keyplaneView setNeedsDisplay];
        }
    }
}
%end

%hook UIKBKeyplaneView
- (id)cacheKey
{
    id result = %orig;
    
    if ([result hasPrefix:@"772197114"] || [result hasPrefix:@"3136966873"] || [result hasPrefix:@"2529512744"] || [result hasPrefix:@"4152776063"])
        return nil;
    
    UIKeyboardLayoutStar *layout = self.layout;
    
    return layout.shift ? [result stringByReplacingOccurrencesOfString:@"small" withString:@"capital"] : result;
}
%end

%hook UIKeyboardMenuView
-(id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath
{
    UITableViewCell *hookedcell = %orig;
    if ([hookedcell.textLabel.text isEqualToString:@"Čeština"])
    {
        hookedcell.textLabel.text = @"Zawgyi";
        return hookedcell;
    }   
    return %orig;
}
%end
