//
//  MenuViewController.h
//  Cootie
//
//  Created by ANNA BILLSTROM on 11/2/15.
//  Copyright © 2015 banane.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate> {
    UITableView *myTableView;
    NSArray *tableTitles;
}

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property NSArray *tableTitles;


-(IBAction)clickContactUs:(id)sender;

@end
