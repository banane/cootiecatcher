//
//  CootieTests.m
//  CootieTests
//
//  Created by ANNA BILLSTROM on 11/13/15.
//  Copyright © 2015 banane.com. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END