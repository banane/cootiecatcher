//
//  AppDelegate.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "AppDelegate.h"
//#import "RootViewController.h"
#import "Cootie-Swift.h"
#import "Fortunes_resetValues.h"

@implementation AppDelegate
@class Fortunes;
@class RootVC;

@synthesize window, navCtrl, resetValues;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    RootVC *rvc = [[RootVC alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
	[self.window setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[self setupDB];
    [self setNavigationBarLook];
	return YES;
}

- (void)setupDB{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"fortunes"]) {
        [userDefaults setObject:StaticConstants.resetValues forKey: @"fortunes"];
    }
}

-(void)setNavigationBarLook{
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor grayColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor blackColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"WalterTurncoat" size:18.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
}

@end
