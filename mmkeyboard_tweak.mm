static BOOL isHookedKeyboard = NO;
static NSDictionary *dict = nil;
static BOOL isExtra = NO;
static BOOL isCap = NO;

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
    
    if (isCap && [original isEqualToString:@"´"])
        return @"ၚ";
    else if (isCap && [original isEqualToString:@"ˇ"])
        return @"ဓ";
        
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
    
    if (isCap && [original isEqualToString:@"´"])
        return @"ၚ";
    else if (isCap && [original isEqualToString:@"ˇ"])
        return @"ဓ";
    
    if (!isHookedKeyboard && !isExtra)
        return %orig;

    if ([original isEqualToString:@"international"] || [original isEqualToString:@"123"] || [original isEqualToString:@"delete"] || [original isEqualToString:@"more"])
        return %orig;
    
    NSString *toretrun = convertToMyanmar(original);
    
    if (toretrun)
        return toretrun;
    
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
        UIKBKeyplaneView *hookedPlane = MSHookIvar<UIKBKeyplaneView *>(self, "_keyplaneView");
        [hookedPlane setNeedsDisplay];
    }
}

-(void)setKeyboardName:(NSString *)name appearance:(int)appearance
{
    NSRange range = [name rangeOfString:@"Czech-Slovak"];
    if (range.location != NSNotFound)
        isHookedKeyboard = YES;
    else
        isHookedKeyboard = NO;
        
    %orig;
}
%end

%hook UIKBKeyplaneView
- (id)cacheKey
{
    NSString *result = %orig;    
    if (isHookedKeyboard)
    {
        NSRange range = [result rangeOfString:@"punctuation-alternate"];
        NSRange range1 = [result rangeOfString:@"second-alternate"];
        
        if (range.location != NSNotFound || range1.location != NSNotFound)
        {
            isExtra = YES;
            return nil;
        }
    }
    
    isExtra = NO;
    
    NSRange range = [result rangeOfString:@"numbers-and-punctuation"];
    NSRange range1 = [result rangeOfString:@"first-alternate"];

    if (range.location != NSNotFound || range1.location != NSNotFound)
        return nil;
        
    UIKeyboardLayoutStar *layout = self.layout;
    
    if (layout.shift)
        isCap = YES;
    else
        isCap = NO;
    
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
