//
//  AppDelegate.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate
//@class MainController;

@synthesize window, navCtrl, resetValues;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    RootViewController *mvc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController:mvc];
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
	[self.window setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self setupResetValues];
	[self setupDB];
    [self setNavigationBarLook];
	return YES;
}

- (void)setupResetValues {
   resetValues = [[NSArray alloc] initWithObjects:
                                  @"You will be president.",
                                  @"Giraffes are neat.",
                                  @"Someone will steal your pencil.",
                                  @"Give someone a dollar.",
                                  @"Nobody gets you, like I get you.",
                                  @"Your secret is safe.",
                                  @"You will make an amazing pie.",
                                  @"Your wish will come true.",
                                  nil ] ;
}

- (void)setupDB{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"fortunes"]) {
        [userDefaults setObject:resetValues forKey: @"fortunes"];
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


#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

