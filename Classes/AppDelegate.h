//
//  CootieAppDelegate.h
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved


#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    UINavigationController *navCtrl;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navCtrl;
@property (nonatomic, retain) NSArray *resetValues;

@end

