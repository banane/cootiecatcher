//
//  DetailViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "DetailViewController.h"
#import "UIButton+Cootie.h"

@implementation DetailViewController {
    NSString *fortune;
}

@synthesize fortuneTextField, saveButton, clearBtn, rowOfFortune;

-(IBAction)saveClicked:(id)sender{
    NSMutableArray *tmpArray = [[NSUserDefaults.standardUserDefaults objectForKey:@"fortunes"] mutableCopy];
    int myInt = (int)rowOfFortune;
    tmpArray[myInt] = fortuneTextField.text;
    
    NSArray *tmp3 = [NSArray arrayWithArray:tmpArray];
    [NSUserDefaults.standardUserDefaults setObject:tmp3 forKey:@"fortunes"];
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
    fortuneTextField.text = [[NSUserDefaults.standardUserDefaults objectForKey:@"fortunes"] objectAtIndex: rowOfFortune];
    [saveButton makeCootie];
    [clearBtn makeCootie];
}

@end
