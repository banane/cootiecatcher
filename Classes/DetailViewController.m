//
//  DetailViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "DetailViewController.h"
#import "UIButton+Cootie.h"

@implementation DetailViewController

@synthesize selectedObject, fortuneTextField, saveButton, clearBtn, tmpFortune;


-(IBAction)textFieldDidEndEditing:(UITextField *)textField{	
	tmpFortune = [textField text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

-(IBAction)saveClicked:(id)sender{
	[selectedObject setValue:[fortuneTextField text] forKey:@"FortuneString"];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)clearClicked:(id)sender{
	fortuneTextField.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
	fortuneTextField.delegate = self;
    [fortuneTextField setFont:[UIFont fontWithName:@"WalterTurncoat" size:20.0]];
	self.title=@"Edit Fortune";
	fortuneTextField.text = [[selectedObject valueForKey:@"FortuneString"] description];
    [saveButton makeCootie];
    [clearBtn makeCootie];
}

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	 return YES;
}


@end
