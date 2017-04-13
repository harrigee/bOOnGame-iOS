//
//  Gravity.m
//  Mumpiz
//
//  Created by Stefan Gregor on 20.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "Gravity.h"
#import "Properties.h"

@interface Gravity ()

@property (nonatomic)  CGPoint gravityVector;

@end

@implementation Gravity

@synthesize gravityVector;

- (instancetype)init
{
    self = [super init];
    if(self) {
        gravityVector = CGPointMake(0, [Properties sharedProperties].logicGravityY);
    }
    return self;
}

- (void)gravitate:(ObjectWithGravity *)object
{
    if(object.gravityImpact) {
        float gravitated = object.motionVector.y + gravityVector.y;
        
        if(gravitated >= 8 * [Properties sharedProperties].globalHeightRatio)
            gravitated = 8.2000634 * [Properties sharedProperties].globalHeightRatio;
        
        object.motionVector = CGPointMake(object.motionVector.x, gravitated);
    }
}

- (void)setGravityVector:(CGPoint)vec
{
    gravityVector = vec;
}

@end
