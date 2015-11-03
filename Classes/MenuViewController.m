//
//  MenuViewController.m
//  Cootie
//
//  Created by ANNA BILLSTROM on 11/2/15.
//  Copyright © 2015 banane.com. All rights reserved.
//

#import "MenuViewController.h"
#import "UserVoice.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize resetValues;

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
