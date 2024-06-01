//
//  FortuneViewController.m
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  Created by Anna on 2/25/10.
//  Copyright 2010 Anna Billstrom (banane.com) All Rights Reserved

#import "FortuneViewController.h"
#import "AppDelegate.h"
#import "Cootie-Swift.h"

@class DetailVC;

#define BARBUTTON(TITLE, SELECTOR) [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

@implementation FortuneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = @"Fortunes";
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Reset", @selector(reset));
}

- (void)reset {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset Fortunes"
                                                                   message:@"Go back to preset fortunes. You will lose all of your typed in fortunes."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self resetFortunesOK];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        // do nothing
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)resetFortunesOK{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [NSUserDefaults.standardUserDefaults setObject:appDelegate.resetValues forKey:@"fortunes"];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"fortunes"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
	// Configure the cell.
    NSString *fortune = [[NSUserDefaults.standardUserDefaults objectForKey:@"fortunes"] objectAtIndex: indexPath.row];
	cell.textLabel.text = fortune;
    cell.textLabel.font = [UIFont fontWithName:@"WalterTurncoat" size:18.0f];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailVC *dvc = [[DetailVC alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    dvc.rowOfFortune = indexPath.row;
	[self.navigationController pushViewController:dvc animated:YES];
}

@end

