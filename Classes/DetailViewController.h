//
//  DetailViewController.h
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController <UITextFieldDelegate> {
	NSInteger *rowOfFortune;
	IBOutlet UITextField *fortuneTextField;
	IBOutlet UIButton  *saveButton;
    IBOutlet UIButton *clearBtn;
}

@property (nonatomic, retain) UITextField *fortuneTextField;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, strong) UIButton *clearBtn;
@property NSInteger *rowOfFortune;


-(IBAction)clearClicked:(id)sender;
-(IBAction)saveClicked:(id)sender;

@end
