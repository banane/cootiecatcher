//
//  AppDelegate.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "AppDelegate.h"
#import "RootViewController.h"
#import "FortuneViewController.h"
#import "UserVoice.h"

@implementation AppDelegate

@synthesize window,navCtrl, resetValues;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	NSManagedObjectContext *context = [self managedObjectContext];

	RootViewController *rvc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
    
   
    

  /*  rvc.managedObjectContext = context;

	// setup application-wide static variable here
	resetValues = [[[NSArray alloc] initWithObjects:								  
								  @"You will be president.",
								  @"Giraffes are neat.",
								  @"Someone will steal your pencil.",
								  @"Give someone a dollar.",
								  @"Nobody gets you, like I get you.",
								  @"Your secret is safe.",
								  @"You will make an amazing pie.",
								  @"You wish will come true.",
								  nil ] retain];
	
	rvc.resetValues = resetValues;

	[self checkData];
	*/
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}

- (void)checkData{

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Fortune" inManagedObjectContext:managedObjectContext]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FortunePosition" ascending:YES selector:nil];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];

	NSError *error;	
	NSArray *fortunes = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if(fortunes.count <8){
		for (int i=0;i<[resetValues count];i++){

			NSManagedObject *fortune = [NSEntityDescription insertNewObjectForEntityForName:@"Fortune" inManagedObjectContext:managedObjectContext];
			[fortune setValue:[resetValues objectAtIndex:i] forKey:@"FortuneString"];
			[fortune setValue:[ NSNumber numberWithInt:i ]  forKey:@"FortunePosition"];
			if (![self.managedObjectContext save:&error]) {
				NSLog(@"Error adding Fortune - error:%@",error);
			}
		}
	} else{
		NSLog(@"fortune count upon app start is: %d",fortunes.count);
	}
}

#pragma mark -
#pragma mark Core Data stack


- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Fortune.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		
		NSLog(@"In Pers. store coordinator part- Unresolved error %@, %@", error, [error userInfo]);
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

