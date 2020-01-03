#import "CDVBackgroundColor.h"
#import <Cordova/CDV.h>

@implementation CDVBackgroundColor

- (id)settingForKey:(NSString*)key {
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

- (UIColor *)colorFromHexString:(NSString*)hexString {
    unsigned int rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0xFF"];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0];
}


- (void)pluginInitialize {
    // Set webview color
    UIColor *theColor;
    id backgroundColor = [self settingForKey:@"BackgroundColor"];
    if (backgroundColor) {
        theColor = [self colorFromHexString:backgroundColor];
        self.webView.backgroundColor = theColor;
    }

    // Set main view color as well
    id mainBackgroundColor = [self settingForKey:@"MainViewBackgroundColor"];
    if (!mainBackgroundColor && backgroundColor) mainBackgroundColor = backgroundColor;
    if (mainBackgroundColor) {
        theColor = [self colorFromHexString:mainBackgroundColor];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIView *topView = window.rootViewController.view;
        topView.backgroundColor = theColor;
    }
}


@end
