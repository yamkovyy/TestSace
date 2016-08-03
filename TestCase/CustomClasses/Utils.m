//
//  Utils.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import "Reachability.h"

@implementation Utils

+ (void)showAlertIn:(UIViewController*)viewController withTitle:(NSString*)title message:(NSString*)message withDuration:(float)duration
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.customViewColor = [UIColor colorWithRed: 191.0f/255.0f green: 78.0f/255.0f blue: 78.0f/255.0f alpha: 1.0f];
    
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    [alert showSuccess: viewController ? viewController : vc title: title subTitle: message closeButtonTitle: (duration ? nil : @"Ok") duration: duration];
}

+ (void)showConfirm:(NSString*)title message:(NSString*)message confirmButtonPressed:(void (^)())actionBlock
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.customViewColor = [UIColor colorWithRed: 191.0f/255.0f green: 78.0f/255.0f blue: 78.0f/255.0f alpha: 1.0f];
    
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    
    [alert addButton: NSLocalizedString(@"Yes", nil) actionBlock:^{
        actionBlock();
    }];
    
    [alert showSuccess:vc title: title subTitle: message closeButtonTitle: NSLocalizedString(@"No", nil) duration: 0.0];
}

+ (BOOL)isOnline
{
    return [Reachability reachabilityWithHostname: @"www.google.com"].isReachable;
}

+ (void)saveCustomObject:(id)object key:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (id)loadCustomObjectWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


@end
