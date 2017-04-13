//
//  Player.m
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "Player.h"
#import "Gravity.h"
#import "Properties.h"

@interface Player()

@property float jumpHeight;
@property (nonatomic)  NSArray* possibleColors;
@property (nonatomic)  NSMutableArray* varPossibleColors;
@property CGPoint startPosition;

@end

@implementation Player

@synthesize jumpHeight, varPossibleColors, possibleColors, startPosition;

- (instancetype)initAtCGPoint:(CGPoint)position intoView:(UIView*)superview;
{
    self = [super init];
    if(self) {
    
        // set start position
        startPosition = position;
        
        // make rounded player
        self.layer.cornerRadius = [Properties sharedProperties].playerLength / 2;
        
        // set player size
        self.frame = CGRectMake(startPosition.x - [Properties sharedProperties].playerLength / 2, [Properties sharedProperties].globalGameHeight / 2 - [Properties sharedProperties].playerLength / 2, [Properties sharedProperties].playerLength, [Properties sharedProperties].playerLength);
        
        // set player color
        self.backgroundColor = [UIColor darkGrayColor];
        
        // set alpha
        self.alpha = [Properties sharedProperties].playerAlpha;
        
        // set jumpheight
        self.jumpHeight = [Properties sharedProperties].playerJumpHeight;
        
        // alloc possible colors
        possibleColors = [NSMutableArray new];
        varPossibleColors = [NSMutableArray new];
        
        // add bubble
        UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Properties sharedProperties].globalBubbleLayerName]];
        bubbleView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        // set to superview
        [superview addSubview:self];
    }
    return self;
}

- (void)updateProperties
{
    // set player size
    CGPoint tempCenter = self.center;
    self.frame = CGRectMake(0,0, [Properties sharedProperties].playerLength, [Properties sharedProperties].playerLength);
    self.center = tempCenter;
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    
    // set jumpheight
    self.jumpHeight = [Properties sharedProperties].playerJumpHeight;
    
    [UIView animateWithDuration:0.66f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = CGPointMake(50 * [Properties sharedProperties].globalWidthRatio, [Properties sharedProperties].globalGameHeight / 2);
        [self setRandomColor];
    }
    completion:^(BOOL finished){}];
    
}

- (void)move
{
    if (self.gravityImpact)
        self.center = CGPointMake(self.center.x, self.center.y + ([Properties sharedProperties].playerSpeed * self.motionVector.y));
    
    if(self.center.y > [Properties sharedProperties].globalGameHeight + [Properties sharedProperties].playerLength / 2) {
        self.center = CGPointMake(self.center.x, 0 - [Properties sharedProperties].playerLength / 2);
    }
    else if (self.center.y < - [Properties sharedProperties].playerLength / 2) {
        self.center = CGPointMake(self.center.x, [Properties sharedProperties].globalGameHeight + [Properties sharedProperties].playerLength / 2);
    }
}

#pragma mark set player status

- (void)reset
{
    self.gravityImpact = true;
    self.motionVector = CGPointMake(0, 0);
    
    [UIView animateWithDuration:0.66f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = CGPointMake(50 * [Properties sharedProperties].globalWidthRatio, 50 * [Properties sharedProperties].globalWidthRatio);
    }
    completion:^(BOOL finished){}];
}

- (void)clearMotionVector
{
    self.motionVector = CGPointMake(0, 0);
}

- (void)setDead
{
    self.gravityImpact = false;
}

# pragma mark colors

- (void)setRandomColor
{
    //if([Properties sharedProperties].globalGameMode)
        [self removePossibleColor:self.backgroundColor]; // Raus weil Corinna Consultant ist...
    
    if(varPossibleColors.count > 0) {
        self.backgroundColor = [self.varPossibleColors objectAtIndex:(arc4random() % self.varPossibleColors.count)];
    }
    else {
        self.backgroundColor = [self.possibleColors objectAtIndex:(arc4random() % self.possibleColors.count)];
    }
}

- (void)setPossibleColors:(NSArray*)possibleColorsParam
{
    possibleColors = possibleColorsParam;
    varPossibleColors = [possibleColorsParam mutableCopy];
}

- (void)removePossibleColor:(UIColor*)color
{
    [varPossibleColors removeObject:color];
}

# pragma mark actions

- (void)jump
{
    self.motionVector = CGPointMake(self.motionVector.x, - ((1 * [Properties sharedProperties].globalHeightRatio) + jumpHeight) * [Properties sharedProperties].playerSpeed);
}

- (BOOL)onGround
{
    if(self.center.y >= [Properties sharedProperties].globalScreenHeight)
        return true;
    else
        return false;
}

@end
