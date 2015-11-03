#import <UIKit/UIKit.h>

@interface UIButton ( Cootie )
- (void) makeCootie;
@end

@implementation UIButton ( Cootie )
- (void) makeCootie {
    [[self titleLabel] setFont:[UIFont fontWithName:@"WalterTurncoat" size:18.0f]];
    float padding_button                = 6.0f;
    UIEdgeInsets titleInsets            = UIEdgeInsetsMake(0.0f, padding_button, 0.0f, -padding_button);
    UIEdgeInsets contentInsets          = UIEdgeInsetsMake(padding_button, 0.0f, padding_button, 0.0f);
    CGFloat extraWidthRequiredForTitle  = titleInsets.left - titleInsets.right;
    contentInsets.right += extraWidthRequiredForTitle;
    [self setTitleEdgeInsets:titleInsets];
    [self setContentEdgeInsets:contentInsets];
    [self sizeToFit];
    return;
}
@end

