//
//  RootViewController.h
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreData/CoreData.h>


@interface RootViewController : UIViewController {

	IBOutlet UIButton *blueButton;
	IBOutlet UIButton *yellowButton;
	IBOutlet UIButton *redButton;
	IBOutlet UIButton *greenButton;
	IBOutlet UIButton *againButton;
	IBOutlet UIButton *craftyButton;
	
	IBOutlet UILabel *fortuneLabel;
		
	IBOutlet UIImageView *closedImageView;
	
	SystemSoundID mysound;
		
	int stage;
	int lastState;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;

	NSArray *colors;
	NSArray *imgNumsArray;
	NSArray *resetValues;
	NSArray *masterImageArray;
	NSMutableArray *fortuneArray;

}

@property (nonatomic, retain) IBOutlet UIButton *blueButton;
@property (nonatomic, retain) IBOutlet UIButton *yellowButton;
@property (nonatomic, retain) IBOutlet UIButton *redButton;
@property (nonatomic, retain) IBOutlet UIButton *greenButton;
@property (nonatomic, retain) IBOutlet UIButton *againButton;
@property (nonatomic, retain) IBOutlet UIButton *craftyButton;

@property (nonatomic, retain) IBOutlet UILabel *fortuneLabel;
@property (nonatomic, retain) IBOutlet UIImageView *closedImageView;


@property (nonatomic) int stage;
@property (nonatomic) int lastState;

@property (nonatomic) SystemSoundID mysound;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *fortuneArray;
@property (nonatomic, retain) NSArray *imgNumsArray;
@property (nonatomic, retain) NSArray *masterImageArray;
@property (nonatomic, retain) NSArray *colors;
@property (nonatomic, retain) NSArray *resetValues;

- (IBAction)click:(id)sender;
- (IBAction)playAgain;
- (IBAction)clickFortune:(id)sender;
- (IBAction)viewInfoAlert;
- (void) playSound;
- (void)animateToy:(int)numTimes;
- (void)revealFortune:(int)fortuneID;


@end
