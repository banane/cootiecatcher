//
//  RootViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved


#import "RootViewController.h"
#import "FortuneViewController.h"
#import "CootieAppDelegate.h"
#import "Fortune.h"


@implementation RootViewController

@synthesize BlueButton;
@synthesize YellowButton;
@synthesize RedButton;
@synthesize GreenButton;
@synthesize AgainButton;
@synthesize craftyButton;

@synthesize FortuneLabel;

@synthesize stage;
@synthesize lastState;

@synthesize ClosedImageView;

@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize fortuneArray;
@synthesize mysound;


- (void)viewDidLoad {
		// setup the static arrays for game play
	
	CootieAppDelegate *appDelegate = (CootieAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;

	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
		
	stage = 0;
	lastState = 0;

	/* build fortunearray once - for view load */
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    [fetchRequest setEntity:entity];
	[fetchRequest setReturnsObjectsAsFaults:NO];
		
	fortuneArray = [[context executeFetchRequest:fetchRequest error:&error] retain] ;

	//[entity release];
	[error release];
    [fetchRequest release];

	// setup sound
	NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"cootie" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mysound);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mysound, sizeof(AudioServicesPropertyID), &flag);
	
	
}

- (IBAction)click:(id)sender;
{
	
	NSArray *tallA = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:6],  [NSNumber numberWithInt:5],  [NSNumber numberWithInt:2], nil]  ;		
	NSArray *wideA = [NSArray arrayWithObjects: [NSNumber numberWithInt:8],  [NSNumber numberWithInt:7],  [NSNumber numberWithInt:4],  [NSNumber numberWithInt:3],nil] ;


	int buttonInt = [sender tag];
	
	int flipTimes = 0;
	if(stage == 0) { //color round- the char length of the word
		NSArray *colors = [[[NSArray alloc] initWithObjects: @"red", @"green",@"blue", @"yellow", nil] autorelease];
		NSString *tmp = [colors objectAtIndex:buttonInt]; 
		flipTimes = tmp.length;
		//[colors release];
	} else {  // all other rounds interpret the id to displayed numbers based on state
		if(lastState ==0){
			flipTimes = [[tallA objectAtIndex:buttonInt] intValue];
		} else {
			flipTimes = [[wideA objectAtIndex:buttonInt] intValue];
		}
		
	}	
	// logging, animate for number rounds
	NSLog(@"play info:stage %d, fliptimes %d, buttonInt %d, lastState %d",stage, flipTimes, buttonInt, lastState);
	
// setup final display actions for rounds
	
	if(stage <3 ){			
		[self animateToy:flipTimes];		
	}
	if(stage<=2){
		[self playSound];
	}
	if(stage ==3){
		NSLog(@"in stage is 3");
		[self revealFortune:flipTimes];
	}
}



- (void) animateToy:(int)numTimes {
	NSLog(@"beginning in animate toy ------------ numtimes: %d", numTimes);
	
	int alternator = lastState;
	NSArray* masterImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tall.png"], [UIImage imageNamed:@"wide.png"], [UIImage imageNamed:@"closed.png"], nil] ;
	NSMutableArray *animationArray = [[NSMutableArray alloc] init] ;
	
	for(int i=1; i<=numTimes; i++){
		
		// flip alternator
		if(alternator == 0){
			alternator = 1;
		} else {
			alternator = 0;
		}

		[animationArray addObject:[masterImageArray objectAtIndex:alternator]] ;
		
		// store the last state of tall/wide for next stage
		if(i==numTimes){
			lastState = alternator;
		} 
		if (i<numTimes){
			[animationArray addObject:[masterImageArray objectAtIndex:2]]; // helps make it the "look" of the cootiecatcher
		}
	}
//	[ClosedImageView.animationImages release];
	ClosedImageView.animationImages = nil; // for good measure, clear it out before assigning
	ClosedImageView.animationImages = animationArray; 
	ClosedImageView.animationDuration = 2.0;// seconds	
	ClosedImageView.animationRepeatCount = 1;
	
	[ClosedImageView startAnimating]; 	
	[ClosedImageView setImage:[masterImageArray objectAtIndex:lastState]];


	NSLog(@"ending animate array .........................animation array count: %d", [animationArray count]);
	NSLog(@"retain counts, anim: %d and master: %d, civ.animimgs %d", [animationArray retainCount], [masterImageArray retainCount], [ClosedImageView.animationImages retainCount]);
	stage ++; 
	
	[masterImageArray release];
	[animationArray release];
}


- (void)revealFortune:(int)fortuneID{
	fortuneID --; // indexes start at 0 not 1
	NSLog(@"the fortune count: %d and retain count %d",[fortuneArray count], [fortuneArray retainCount]);
	NSObject *selectedObj = [[fortuneArray objectAtIndex:fortuneID] retain];
	NSString *fortuneString = [[selectedObj valueForKey:@"FortuneString"] retain];
	FortuneLabel.text = fortuneString;
	[fortuneString release];
	[selectedObj release];

	NSLog(@"%@ the fortunestring, fortuneID (-1), %d", fortuneString, fortuneID);
	
	//clean out closedimagearray	 
	[ClosedImageView setImage:[UIImage imageNamed:@"closed.png"]];
	
	ClosedImageView.hidden = YES;
	YellowButton.hidden = YES;
	BlueButton.hidden = YES;
	RedButton.hidden = YES;
	GreenButton.hidden = YES;
	
	craftyButton.hidden = NO;
	AgainButton.hidden = NO;	
	FortuneLabel.hidden = NO;
	
}


- (IBAction) playAgain {
	NSLog(@"in playAgain");
	ClosedImageView.animationImages = nil;
	[ClosedImageView setImage:[UIImage imageNamed:@"closed.png"]];
	
	FortuneLabel.hidden = YES;
	AgainButton.hidden = YES;
	craftyButton.hidden = YES;
	
	ClosedImageView.hidden = NO;
	RedButton.hidden = NO;
	BlueButton.hidden = NO;
	GreenButton.hidden = NO;
	YellowButton.hidden = NO;
	
	// reset game state vars
	stage = 0;
	lastState = 0;
	
	NSLog(@"play again");
	NSLog(@"retaincount for civ.anim %d", [ClosedImageView.animationImages retainCount]);
}


- (void) playSound {
	AudioServicesPlaySystemSound(mysound);	
}


- (IBAction)clickFortune: (id)sender{
	FortuneViewController *fvc = [[FortuneViewController alloc] initWithStyle:UITableViewStylePlain];	
	[[self navigationController] pushViewController:fvc animated: YES];
	[fvc autorelease];
	
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
	
	NSLog(@"the retain count of aFetchedResultsController: %d", [aFetchedResultsController retainCount]);
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	NSLog(@"the retain count of aFetchedResultsController after first release: %d", [aFetchedResultsController retainCount]);

	return fetchedResultsController;
}    

#pragma mark built-in methods

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}


- (void)viewDidUnload {
	[ClosedImageView release];
	[fortuneArray release];
}


- (void)dealloc {
	[BlueButton release];
	[YellowButton release];
	[RedButton release];
	[GreenButton release];
	[AgainButton release];
	[craftyButton release];
	
	[FortuneLabel release];
	
	[ClosedImageView release];

	[fortuneArray release];
	
    [super dealloc];
}


@end