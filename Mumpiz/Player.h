//
//  Player.h
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectWithGravity.h"

@interface Player : ObjectWithGravity

- (instancetype)initAtCGPoint:(CGPoint)position intoView:(UIView*)superview;

- (void)move;
- (void)reset;
- (void)clearMotionVector;
- (void)setDead;
- (void)jump;

- (void)setRandomColor;
- (void)setPossibleColors:(NSArray*)possibleColorsParam;

- (void)updateProperties;
- (BOOL)onGround;

@end
