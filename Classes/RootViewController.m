//
//  RootViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved


#import "RootViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "Fortune.h"
#import "UIButton+Cootie.h"


@implementation RootViewController

@synthesize blueButton, yellowButton, redButton, greenButton, againBtn, settingsBtn, fortuneLabel, stage, lastState, closedImageView;

@synthesize managedObjectContext, fetchedResultsController, fortuneArray, colors, imgNumsArray, masterImageArray, mysound;
- (void)viewDidLoad {
	// setup the static arrays for game play
    
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;

	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
		
	stage = 0;
	lastState = 0;
	
	/* static arrays */
	
	colors = [[NSArray alloc] initWithObjects: @"red", @"green",@"blue", @"yellow", nil];


	imgNumsArray = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:
														[NSNumber numberWithInt:1],
														[NSNumber numberWithInt:6],
														[NSNumber numberWithInt:5],
														[NSNumber numberWithInt:2],nil],
													[[NSArray alloc] initWithObjects:
														[NSNumber numberWithInt:8],
														[NSNumber numberWithInt:7],
														[NSNumber numberWithInt:4],
														[NSNumber numberWithInt:3],nil ],nil ];	
	
	masterImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tall.png"], [UIImage imageNamed:@"wide.png"], [UIImage imageNamed:@"closed.png"], nil] ;
	
	/* build fortunearray once - for view load */
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    [fetchRequest setEntity:entity];
	[fetchRequest setReturnsObjectsAsFaults:NO];
		
	NSArray *tmpArray = [context executeFetchRequest:fetchRequest error:&error] ;
    fortuneArray = [[NSMutableArray alloc] initWithArray:tmpArray];

	[error release];
    [fetchRequest release];

	// setup sound
	NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"cootie" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mysound);
	AudioServicesPropertyID flag = 0; 
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mysound, sizeof(AudioServicesPropertyID), &flag);
    
    [settingsBtn makeCootie];
    [againBtn makeCootie];
}

-(void)viewWillAppear:(BOOL)animated{
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[super viewDidAppear:animated];
}


- (IBAction)click:(id)sender;
{
	int buttonInt = (int *)[sender tag];
	int flipTimes = 0;
    
//    NSLog(@"stage: %d", stage);
	if(stage == 0) {						//color round- the char length of the word
		flipTimes = (int *)[[colors objectAtIndex:buttonInt] length];
	} else {								// all other rounds interpret the id to displayed numbers based on state
		flipTimes = [[[imgNumsArray objectAtIndex:lastState] objectAtIndex:buttonInt] intValue];
	}  
//    NSLog(@"flip times: %d", flipTimes);
											// logging, animate for number rounds
//	NSLog(@"play info:stage %d, fliptimes %d, buttonInt %d, lastState %d",stage, flipTimes, buttonInt, lastState);

							// setup final display actions for rounds

	if (stage < 2) {
		[self animateToy:flipTimes];        
		[self playSound];
	} else if (stage == 2) {
		NSLog(@"in stage is 3");
		[self revealFortune:flipTimes];
	}
}



-(void)animateToy:(int)numTimes {	
	int alternator = lastState;
	
	NSMutableArray *animationArray = [[NSMutableArray alloc] init] ;
	
	for(int i=1; i<=numTimes; i++){
		
		// flip alternator
		alternator ^=1;
        NSLog(@"alternator: %d", alternator);
		[animationArray addObject:[masterImageArray objectAtIndex:alternator]] ;
		
		// store the last state of tall/wide for next stage
		if (i<numTimes && i != numTimes){
			[animationArray addObject:[masterImageArray objectAtIndex:2]]; // helps make it the "look" of the cootiecatcher
		}
	}
	lastState = alternator;
    
    float duration = 2.0;

	closedImageView.animationImages = nil; // for good measure, clear it out before assigning
	closedImageView.animationImages = animationArray; 
	closedImageView.animationDuration = duration;// seconds
	closedImageView.animationRepeatCount = 1;
    
    [self performSelector:@selector(cootieAnimationStopped) withObject:nil
               afterDelay:duration];
    
	[closedImageView startAnimating];
    
	stage ++;
}

-(void)cootieAnimationStopped {
    closedImageView.animationImages = nil;
    [closedImageView setImage:[masterImageArray objectAtIndex:lastState]];
    
}

- (void)revealFortune:(int)fortuneID{
	fortuneID --; // indexes start at 0 not 1
	NSObject *selectedObj = [fortuneArray objectAtIndex:fortuneID] ;
	NSString *fortuneString = [selectedObj valueForKey:@"FortuneString"];
	fortuneLabel.text = fortuneString;

	//clean out closedimagearray	 
	[closedImageView setImage:[masterImageArray objectAtIndex:2]];
	
	closedImageView.hidden = YES;
	yellowButton.hidden = YES;
	blueButton.hidden = YES;
	redButton.hidden = YES;
	greenButton.hidden = YES;
	
	againBtn.hidden = NO;
	fortuneLabel.hidden = NO;
	
}


- (IBAction) playAgain {
	closedImageView.animationImages = nil;
	[closedImageView setImage:[masterImageArray objectAtIndex:2]];
	
	fortuneLabel.hidden = YES;
	againBtn.hidden = YES;
	
	closedImageView.hidden = NO;
	redButton.hidden = NO;
	blueButton.hidden = NO;
	greenButton.hidden = NO;
	yellowButton.hidden = NO;
	
	// reset game state vars
	stage = 0;
	lastState = 0;
	
}


- (void) playSound {
	AudioServicesPlaySystemSound(mysound);	
}


- (IBAction)clickSettings:(id)sender{
    
    MenuViewController *mvc = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
	[[self navigationController] pushViewController:mvc animated: YES];
}

#pragma mark core data methods

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {		
        return fetchedResultsController;
	}
		
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fortune" inManagedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:8];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FortunePosition" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
		
	
	return fetchedResultsController;
}    


@end
