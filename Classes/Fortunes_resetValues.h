//
//  Fortunes_resetValues.h
//  Cootie
//
//  Created by ANNA BILLSTROM on 6/1/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

#ifndef Fortunes_resetValues_h
#define Fortunes_resetValues_h
@interface StaticConstants{
    
}
+(NSArray *) resetValues;
@end

@implementation StaticConstants
+ (NSArray *)resetValues{
    return [[NSArray alloc] initWithObjects:
        @"You will be president.",
        @"Giraffes are neat.",
        @"Someone will steal your pencil.",
        @"Give someone a dollar.",
        @"Nobody gets you, like I get you.",
        @"Your secret is safe.",
        @"You will make an amazing pie.",
        @"Your wish will come true.",nil];
}
@end
#endif /* Fortunes_resetValues_h */
