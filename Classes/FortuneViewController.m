//
//  FortuneViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "FortuneViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Fortune.h"

#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@implementation FortuneViewController

@synthesize fetchedResultsController, managedObjectContext;


- (void)reset {
	
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset Fortunes"
                                                                   message:@"Go back to preset fortunes. You will lose all of your typed in fortunes."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self resetValues];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        // do nothing
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
	
}


- (void)viewDidLoad {
	
	[[self navigationController] setNavigationBarHidden:NO animated:YES];

    [super viewDidLoad];
	NSLog(@"inside fvc");

	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;
	
	self.title = @"Fortunes";
	
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Reset", @selector(reset));
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error in rootviewcontroller.h %@, %@", error, [error userInfo]);
		abort();
	}
	
}

- (void)resetFortunesOK{
    NSFetchRequest *fRequest = [[NSFetchRequest alloc] init];
    [fRequest setEntity:[NSEntityDescription entityForName:@"Fortune" inManagedObjectContext:managedObjectContext]];
    
    NSError *error = nil;
    NSArray *oldForts = [[managedObjectContext executeFetchRequest:fRequest error:&error] retain] ;
    
    for (NSManagedObject * fort in oldForts) {
        [managedObjectContext deleteObject:fort];
    }
    
    int i=0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(NSString *f_str in appDelegate.resetValues){
        NSManagedObject *newFortune = [NSEntityDescription insertNewObjectForEntityForName:@"Fortune" inManagedObjectContext:managedObjectContext];
        [newFortune setValue:f_str forKey:@"FortuneString"];
        [newFortune setValue:[NSNumber numberWithInt:i] forKey:@"FortunePosition"];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error adding Fortune - error:%@",error);
        }
        i++;
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
	// Configure the cell.
	NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [[managedObject valueForKey:@"FortuneString"] description];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
	NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	dvc.selectedObject = selectedObject;
	[self.navigationController pushViewController:dvc animated:YES];

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

	
	NSLog(@"inside fvcs frc retaincount: %d", (int)[aFetchedResultsController retainCount]);

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


@end

