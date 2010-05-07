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

	IBOutlet UIButton *BlueButton;
	IBOutlet UIButton *YellowButton;
	IBOutlet UIButton *RedButton;
	IBOutlet UIButton *GreenButton;
	IBOutlet UIButton *AgainButton;
	IBOutlet UIButton *craftyButton;
	
	IBOutlet UILabel *FortuneLabel;
		
	IBOutlet UIImageView *ClosedImageView;
	
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

@property (nonatomic, retain) IBOutlet UIButton *BlueButton;
@property (nonatomic, retain) IBOutlet UIButton *YellowButton;
@property (nonatomic, retain) IBOutlet UIButton *RedButton;
@property (nonatomic, retain) IBOutlet UIButton *GreenButton;
@property (nonatomic, retain) IBOutlet UIButton *AgainButton;
@property (nonatomic, retain) IBOutlet UIButton *craftyButton;

@property (nonatomic, retain) IBOutlet UILabel *FortuneLabel;
@property (nonatomic, retain) IBOutlet UIImageView *ClosedImageView;


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
- (IBAction)clickFortune: (id) sender;
- (void) playSound;
- (void)animateToy:(int)numTimes;
- (void)revealFortune:(int)fortuneID;


@end
