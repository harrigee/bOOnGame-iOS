//
//  Gravity.h
//  Mumpiz
//
//  Created by Stefan Gregor on 20.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectWithGravity.h"

@interface Gravity : NSObject

- (instancetype)init;

- (void)gravitate:(ObjectWithGravity *)object;
- (void)setGravityVector:(CGPoint)vec;

@end
