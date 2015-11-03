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

@synthesize myTableView, tableTitles;

- (void)viewDidLoad {
    self.title=@"Menu";
   [[self navigationController] setNavigationBarHidden:NO animated:NO];
    // Set this up once when your application launches
    UVConfig *config = [UVConfig configWithSite:@"banane.uservoice.com"];
    config.forumId = 328458;
    // [config identifyUserWithEmail:@"email@example.com" name:@"User Name", guid:@"USER_ID");
    [UserVoice initialize:config];
    tableTitles = [[NSArray alloc] initWithObjects:@"About CootieCatcher", @"Contact Us", @"I've got an idea", @"Fortunes", @"Discuss Cootie!", nil];
    UIImageView *jmv = [[UIImageView alloc] init];
    jmv.image = [UIImage imageNamed:@"me_jenny"];
    [myTableView setBackgroundView:jmv];
    [myTableView reloadData];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[UIColor blackColor] forKey:UITextAttributeTextColor];
    [attributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
    [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [attributes setValue:[UIFont fontWithName:@"WalterTurncoat" size:18.0f] forKey:UITextAttributeFont];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
  
    [super viewDidLoad];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableTitles count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    // Configure the cell...
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [tableTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"WalterTurncoat" size:18.0f];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row){
        case 0:
            [self viewAbout:nil];
            break;
        case 1:
            [self clickContactUs:nil];
            break;
        case 2:
            [self clickNewIdea:nil];
            break;
        case 3:
            [self viewFortunes:nil];
            break;
        case 4:
            [self clickDiscuss:nil];
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickContactUs:(id)sender{
    [UserVoice presentUserVoiceContactUsFormForParentViewController:self];
}

- (IBAction)clickDiscuss:(id)sender{
    [UserVoice presentUserVoiceForumForParentViewController:self];
}


- (IBAction)clickNewIdea:(id)sender{
    [UserVoice presentUserVoiceNewIdeaFormForParentViewController:self];
}

-(IBAction)viewFortunes:(id)sender{
    FortuneViewController *fvc = [[FortuneViewController alloc] initWithNibName:@"FortuneViewController" bundle:nil];
    [[self navigationController] pushViewController:fvc animated:YES];
    
}

-(IBAction)viewAbout:(id)sender{
    
    
    NSDictionary *strings = [[NSDictionary alloc] initWithObjectsAndKeys:@"About CootieCatcher", @"title", @"By Anna Billstrom, with some help from her big sister Jennifer Huber.", @"msg", @"Cool",@"buttonTitle", nil];

   
    
    UIAlertController* infoAlert = [UIAlertController alertControllerWithTitle:strings[@"title"] message:strings[@"msg"] preferredStyle:UIAlertControllerStyleAlert];

    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:strings[@"title"]];
    
    NSRange range = NSMakeRange(0, [strings[@"title"] length]);

    
    [attTitle addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"WalterTurncoat" size:20.0f]
                  range:range];
    [infoAlert setValue:attTitle forKey:@"attributedTitle"];
    
    
    
      UIAlertAction *action = [UIAlertAction actionWithTitle:strings[@"buttonTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"clicked ok in alert");
    }];
    
    
    [infoAlert addAction:action];
    [self presentViewController:infoAlert animated:YES completion:nil];

}

@end
