//
//  CoolButtons.m
//  CoolButtons
//
//  Created by ANNA BILLSTROM on 11/6/15.
//  Copyright © 2015 ANNA BILLSTROM. All rights reserved.
//

#import "CoolButtons.h"

@implementation CoolButton : UIButton

- (id) init:(UIButton *)btn {
    self = [super init];
    if (self) {
    [[btn titleLabel] setFont:[UIFont fontWithName:@"WalterTurncoat" size:18.0f]];
    float padding_button                = 6.0f;
    UIEdgeInsets titleInsets            = UIEdgeInsetsMake(0.0f, padding_button, 0.0f, -padding_button);
    UIEdgeInsets contentInsets          = UIEdgeInsetsMake(padding_button, 0.0f, padding_button, 0.0f);
    CGFloat extraWidthRequiredForTitle  = titleInsets.left - titleInsets.right;
    contentInsets.right += extraWidthRequiredForTitle;
    [btn setTitleEdgeInsets:titleInsets];
    [btn setContentEdgeInsets:contentInsets];
    [btn sizeToFit];
    }
    return (CoolButton *)btn;
}

-(void)logThis{
    NSLog(@"blah");
}

@end