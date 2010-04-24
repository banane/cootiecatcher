//
//  Fortune.h
//  Cootie
//
//  Created by Anna on 4/12/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Fortune :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * FortunePosition;
@property (nonatomic, retain) NSString * FortuneString;

@end



