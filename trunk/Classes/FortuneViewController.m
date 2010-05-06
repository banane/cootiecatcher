//
//  FortuneViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "FortuneViewController.h"
#import "CootieAppDelegate.h"
#import "DetailViewController.h"
#import "Fortune.h"

#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@implementation FortuneViewController

@synthesize fetchedResultsController, managedObjectContext;


- (void)reset {
	
	
	UIAlertView *charAlert = [[UIAlertView alloc]
							  initWithTitle:@"Reset Fortunes"
							  message:@"Go back to factory settings. You will lose all typed in fortunes."
							  delegate:nil
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:nil];
	
	[charAlert addButtonWithTitle:@"Reset"];
	charAlert.delegate = self;
	
	
	[charAlert show];
	[charAlert autorelease];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"inside fvc");

	CootieAppDelegate *appDelegate = (CootieAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;
	
	self.title = @"Fortunes";
	
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Reset", @selector(reset));
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error in rootviewcontroller.h %@, %@", error, [error userInfo]);
		abort();
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){		
		// delete all fortunes
		NSLog(@"in user chose to delete and add canned fortunes");
		
		NSFetchRequest *fRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fRequest setEntity:[NSEntityDescription entityForName:@"Fortune" inManagedObjectContext:managedObjectContext]];
		
		NSError *error = nil;
		NSArray *oldForts = [[managedObjectContext executeFetchRequest:fRequest error:&error] retain] ;

		for (NSManagedObject * fort in oldForts) {
			[managedObjectContext deleteObject:fort];
		}

		// add the canned fortunes
		NSArray * resetValuesArray = [[NSArray alloc] initWithObjects:								  
									 @"You will be president.",
									 @"Giraffes are neat.",
									 @"Someone will steal your pencil.",
									 @"Give someone a dollar.",
									 @"Nobody gets you, like I get you.",
									 @"Your secret is safe.",
									 @"You will make an amazing pie.",
									 @"You wish will come true.",
									 nil ] ;
	
		int i = 0;
		NSLog(@"past deletion, onto addition:  -->");
		for (NSString *f_str in resetValuesArray) {
			NSManagedObject *newFortune = [NSEntityDescription insertNewObjectForEntityForName:@"Fortune" inManagedObjectContext:managedObjectContext];
			[newFortune setValue:f_str forKey:@"FortuneString"];
			[newFortune setValue:[ NSNumber numberWithInt:i ]  forKey:@"FortunePosition"];

			if (![managedObjectContext save:&error]) {
				NSLog(@"Error adding Fortune - error:%@",error);
			}
			i++;
		}
		[resetValuesArray release];
		[oldForts release];
	}
}


- (void)viewDidUnload {
}



#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [[managedObject valueForKey:@"FortuneString"] description];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
	NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	detailViewController.selectedObject = selectedObject;
	
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	[detailViewController release];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			
			NSLog(@"Unresolved error in commiteditingstyle %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {		
        return fetchedResultsController;
	}
    /*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fortune" inManagedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:8];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FortunePosition" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;

	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	NSLog(@"inside fvcs frc retaincount: %d", [aFetchedResultsController retainCount]);

	return fetchedResultsController;
}    

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

