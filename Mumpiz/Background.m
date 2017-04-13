//
//  Background.m
//  Mumpiz
//
//  Created by Stefan Gregor on 30.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "Background.h"
#import "Properties.h"

@interface Background ()

@property NSMutableArray *backgroundAreas;
@property UIView *superview;
@property NSArray *colorSet;
@property BOOL initial;

@end

@implementation Background

@synthesize backgroundAreas, superview, colorSet, initial;

- (instancetype)initWithSuperview:(UIView*)superviewParam withColorSet:(NSArray*)colorSetParam
{
    self = [super init];
    if(self) {
        
        // set superview
        superview = superviewParam;
        
        // set colors
        colorSet = colorSetParam;
        
        // allocate memory for backgroundAreas - array
        backgroundAreas = [NSMutableArray new];
        
        // if its initial or not
        initial = true;
        
        // create background areas
        [self createBackgroundAreas:[Properties sharedProperties].backgroundCount];
    }
    return self;
}

- (void)createBackgroundAreas:(int)count
{
    int randomX;
                                 
    if(initial)
        randomX = arc4random() % [Properties sharedProperties].globalGameWidth * 2;
    else
        randomX = arc4random() % [Properties sharedProperties].globalGameWidth + [Properties sharedProperties].globalGameWidth;
    
    int randomY = arc4random() % [Properties sharedProperties].globalGameHeight - [Properties sharedProperties].backgroundMaxHeight / 2;
    int randomWidth = (arc4random() % [Properties sharedProperties].backgroundMaxWidth) + [Properties sharedProperties].backgroundMinWidth;
    
    for (int i = 0; i < count; i++)
    {
        UIView *view = [UIView new];
        view.frame = CGRectMake(randomX, randomY, randomWidth, randomWidth);
        view.backgroundColor = [colorSet objectAtIndex:arc4random()%[Properties sharedProperties].worldAreaCount];
        view.alpha = [Properties sharedProperties].backgroundAlpha;
        view.layer.cornerRadius = randomWidth / 2;
        view.userInteractionEnabled = false;
        
        [superview addSubview:view];
        [superview sendSubviewToBack:view];
        [backgroundAreas addObject:view];

        if(initial)
            randomX = arc4random() % [Properties sharedProperties].globalGameWidth * 2;
        else
            randomX = arc4random() % [Properties sharedProperties].globalGameWidth + [Properties sharedProperties].globalGameWidth;
        
        randomY = arc4random() % [Properties sharedProperties].globalGameHeight - [Properties sharedProperties].backgroundMaxHeight / 2;
        randomWidth = (arc4random() % [Properties sharedProperties].backgroundMaxWidth) + [Properties sharedProperties].backgroundMinWidth;
    }
    initial = false;
}

- (void)changeColorSet:(NSArray*)colorSetParam
{
    colorSet = colorSetParam;
}

// moves the areas along the x axis with a specific speed
- (void)moveAreas
{
    // move background areas
    for (UIView *area in backgroundAreas)
        area.center = CGPointMake(area.center.x - ([Properties sharedProperties].backgroundSpeed * area.frame.size.width / [Properties sharedProperties].backgroundMaxWidth), area.center.y);
}

// tests if the areas on screen are visible, removes them if not and creates new ones
- (void)removeOffscreenAreasAndCreateNewOnes
{
    for (int i = 0; i < backgroundAreas.count; i++)
    {
        // actual area
        UIView *area = (UIView*)backgroundAreas[i];
        
        if(area.frame.origin.x + area.frame.size.width < 0)
        {
            [area removeFromSuperview];
            [backgroundAreas removeObjectAtIndex:i];
            [self createBackgroundAreas:1];
        }
    }
}
@end
