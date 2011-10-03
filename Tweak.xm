#import <UIKit/UIKit.h>
@interface AddressView : UIView
{

}
- (id)reloadImageView;
- (void)_reloadImageViewClicked;

@end

@interface BrowserController : NSObject {


}
- (void)_doSearch:(id)arg1;

@end

//from https://github.com/chpwn/Unifari
static BOOL is_string_url(NSString *location) {
    if ([location hasPrefix:@"?"])
        return NO;
    
    NSUInteger offset = 0;
    
    offset = [location rangeOfString:@":"].location;
    if (offset != NSNotFound) {
        NSString *scheme = [location substringToIndex:offset];
        
        NSMutableCharacterSet *character = [NSMutableCharacterSet alphanumericCharacterSet];
        [character addCharactersInString:@"-"];
        BOOL alphanumeric = ([[scheme stringByTrimmingCharactersInSet:character] length] == 0);
        
        BOOL special = ([scheme isEqualToString:@"localhost"]);
        
        if (alphanumeric && !special)
            return YES;
    }
    
    offset = [location rangeOfString:@"/"].location;
    if (offset != NSNotFound) {
        NSString *domain = [location substringToIndex:offset];
        
        BOOL space = ([domain rangeOfString:@" "].location != NSNotFound);
        BOOL dot = ([domain rangeOfString:@"."].location != NSNotFound);
        
        BOOL localhost = ([domain isEqualToString:@"localhost"]);
        
        if ((dot && !space) || localhost)
            return YES;
    }
    
    BOOL space = ([location rangeOfString:@" "].location != NSNotFound);
    BOOL dot = ([location rangeOfString:@"."].location != NSNotFound);
    
    if (dot && !space)
        return YES;
    
    return NO;
}


%hook AddressView 
- (CGRect)_frameForProgressViewNormal {    
%orig;
	id search = MSHookIvar<id>(self, "_searchTextField");
	[search removeFromSuperview];
	//[[self reloadImageView]setEnabled:YES];
return CGRectMake(%orig.origin.x,%orig.origin.y,%orig.size.width * 1.5502, %orig.size.height);

}
+ (BOOL)shouldShowInactiveFieldWhileEditing {
%orig;
return NO;
}

- (void)layoutSubviews {
%orig;
[MSHookIvar<UIView *>(self,"_searchTextField") removeFromSuperview];



}


%end


%hook ProgressView
- (id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 {
AddressView *address = MSHookIvar<AddressView *>(self,"_delegate");
	if (CGRectContainsPoint([[address reloadImageView]frame], arg1))
	[address _reloadImageViewClicked];

return %orig;

}



%end
%hook BrowserController
- (void)goToAddress:(id)arg1 fromAddressView:(id)arg2 {
if(!is_string_url(arg1)) {
[self _doSearch:arg1];
}
else {
%orig;

}


}
%end

