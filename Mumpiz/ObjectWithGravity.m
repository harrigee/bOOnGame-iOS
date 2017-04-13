//
//  ObjectWithGravity.m
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "ObjectWithGravity.h"

@implementation ObjectWithGravity

@synthesize motionVector;
@synthesize gravityImpact;

- (id)init
{
    self = [super init];
    if (self) {
        // set motion vector
        motionVector = CGPointMake(1, 1);
    
        // if gravity should impact
        gravityImpact = true;
    }
    return self;
}

@end
