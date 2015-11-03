//
//  MenuViewController.m
//  Cootie
//
//  Created by ANNA BILLSTROM on 11/2/15.
//  Copyright © 2015 banane.com. All rights reserved.
//

#import "MenuViewController.h"
#import "FortuneViewController.h"
#import "UserVoice.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set this up once when your application launches
    UVConfig *config = [UVConfig configWithSite:@"banane.uservoice.com"];
    config.forumId = 328458;
    // [config identifyUserWithEmail:@"email@example.com" name:@"User Name", guid:@"USER_ID");
    [UserVoice initialize:config];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickContactUs:(id)sender{
    [UserVoice presentUserVoiceContactUsFormForParentViewController:self];
}
-(IBAction)viewFortunes:(id)sender{
    FortuneViewController *fvc = [[FortuneViewController alloc] initWithNibName:@"FortuneViewController" bundle:nil];
    [[self navigationController] pushViewController:fvc animated:YES];
    
}

-(IBAction)viewAbout:(id)sender{
    UIAlertController* infoAlert = [UIAlertController alertControllerWithTitle:@"CootieCatcher" message:@"By Anna Billstrom, with some help from her big sister Jennifer Huber.\n \n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cool" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"clicked ok in alert");
    }];
    [infoAlert addAction:action];
    [self presentViewController:infoAlert animated:YES completion:nil];

}

@end
