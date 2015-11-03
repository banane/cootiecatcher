//
//  MenuViewController.h
//  Cootie
//
//  Created by ANNA BILLSTROM on 11/2/15.
//  Copyright © 2015 banane.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController{
    NSArray *resetValues;
}

@property (nonatomic, retain) NSArray *resetValues;

-(IBAction)clickContactUs:(id)sender;

@end
