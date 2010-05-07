//
//  DetailViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "DetailViewController.h"


@implementation DetailViewController

@synthesize selectedObject;
@synthesize fortuneTextField;
@synthesize saveButton;
@synthesize tmpFortune;


-(IBAction)textFieldDidEndEditing:(UITextField *)textField{	
	//[selectedObject setValue:[textField text] forKey:@"FortuneString"];
	tmpFortune = [textField text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}


-(IBAction)saveClicked:(id)sender{
	tmpFortune = [fortuneTextField text];
	[selectedObject setValue:tmpFortune forKey:@"FortuneString"];
	
}
-(IBAction)clearClicked:(id)sender{
	fortuneTextField.text = @"";
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	fortuneTextField.delegate = self;
	
	self.title=@"Edit Fortune";
	
	fortuneTextField.text = [[selectedObject valueForKey:@"FortuneString"] description];
}

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
//	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
	 return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[selectedObject release];
	[fortuneTextField release];
    [super dealloc];
}


@end
