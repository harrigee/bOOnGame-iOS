//
//  World.m
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "World.h"
#import "Background.h"
#import "Properties.h"

@interface World ()

@property UIView* superview;
@property NSMutableArray *areas;
@property int space;
@property int random;
@property Background *background;

@end

@implementation World

@synthesize superview, areas, space, random, background;

- (instancetype)initWithSuperview:(UIView*)superviewParam
{
    self = [super init];
    if(self) {
        
        // set superview
        superview = superviewParam;
        
        // allocate memory for areas - array
        areas = [NSMutableArray new];
        
        // calculate spaces between areas
        space = ([Properties sharedProperties].globalGameHeight - [Properties sharedProperties].worldAreaCount * [Properties sharedProperties].worldAreaLength) / ([Properties sharedProperties].worldAreaCount + 1);
        
        // create start areas
        [self createAreas];
        
        // set background color of game
        superview.backgroundColor = [UIColor whiteColor];
        
        // create background areas
        background = [[Background alloc] initWithSuperview:superview withColorSet:[self getColors][[Properties sharedProperties].backgroundColorSet]];
    }
    return self;
}

- (void)move
{
    // test if areas are in the middle, if so, create new ones
    [self removeOffscreenAreasAndCreateNewOnes];
    
    // move areas
    [self moveAreas];
}

- (void)moveBackgroundWithoutWorld
{
    // move it
    [background moveAreas];
    
    // do the same for the background
    [background removeOffscreenAreasAndCreateNewOnes];
}

# pragma mark area controlling

// creates (AREA_COUNT) areas
- (void)createAreas
{
    NSMutableArray *colors = [self getRandomizedColors];
        
    // create new areas
    for (int i = 0; i < [Properties sharedProperties].worldAreaCount; i++)
    {
        UIView *view = [UIView new];
        view.frame = CGRectMake([Properties sharedProperties].worldAreaStart, (space * (i + 1)) + i * [Properties sharedProperties].worldAreaLength, [Properties sharedProperties].worldAreaLength, [Properties sharedProperties].worldAreaLength);
        view.backgroundColor = [colors objectAtIndex:i];
        view.alpha = [Properties sharedProperties].worldAreaAlpha;
        view.layer.cornerRadius = [Properties sharedProperties].worldAreaLength / 2;
        view.tag = i;
        view.userInteractionEnabled = false;
        
        //UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Properties sharedProperties].globalBubbleLayerName]];
        //bubbleView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        //[view addSubview:bubbleView];
        
        [superview addSubview:view];
        [superview bringSubviewToFront:view];
        [areas addObject:view];
    }
}

// moves the areas along the x axis with a specific speed
- (void)moveAreas
{
    // move areas
    for (UIView *area in areas) {
        area.center = CGPointMake(area.center.x - [Properties sharedProperties].logicSpeed, area.center.y);
    }
    
    // move background areas
    [background moveAreas];
}

// tests if the areas on screen are visible, removes them if not and creates new ones
- (void)removeOffscreenAreasAndCreateNewOnes
{
    bool createNewOnes = false;
    
    // create new areas
    for (int i = 0; i < areas.count; i++)
    {
        // actual area
        UIView *area = (UIView*)areas[i];
        
        if(area.center.x <= [Properties sharedProperties].globalGameWidth / 2 && area.tag == 1)
        {
            area.tag = 5;
            createNewOnes = true;
        }
        if(area.frame.origin.x + area.frame.size.width < 0)
        {            
            [area removeFromSuperview];
            [areas removeObjectAtIndex:i];
        }
    }
    
    // if there are no areas left on the screen, create new ones
    if(areas.count < [Properties sharedProperties].worldAreaCount + 1 && createNewOnes) {
        [self createAreas];
        [self.delegate newAreasCreated];
        createNewOnes = false;
    }
    
    // do the same for the background
    [background removeOffscreenAreasAndCreateNewOnes];
}

// removes a specific area
- (void)removeArea:(UIView*)area
{
    //[area removeFromSuperview];
    [areas removeObject:area];
}

// resets the playground
- (void)reset
{
    [background changeColorSet:[self getColors][[Properties sharedProperties].worldStandardColorSet]];
    
    space = ([Properties sharedProperties].globalGameHeight - [Properties sharedProperties].worldAreaCount * [Properties sharedProperties].worldAreaLength) / ([Properties sharedProperties].worldAreaCount + 1);
    
    for (UIView *view in areas)
    {
        [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            view.alpha = 0;
        }
        completion:^(BOOL finished){
            [view removeFromSuperview];
            [areas removeObject:view];
            if(areas.count <= 0) {
                [self createAreas];
            }
        }];
    }
}

#pragma mark colors

- (NSMutableArray*)getColors
{
    NSArray *inputColors1 = [NSArray new];
    NSArray *inputColors2 = [NSArray new];
    NSArray *inputColors3 = [NSArray new];
    NSArray *inputColors4 = [NSArray new];
    NSArray *inputColors5 = [NSArray new];
    NSArray *inputColors6 = [NSArray new];
    NSArray *inputColors7 = [NSArray new];
    
    
    NSMutableArray *setOfColors = [NSMutableArray new];
    
    inputColors1 = @[[UIColor colorWithRed:149/255.0f green:8/255.0f blue:255/255.0f alpha:1],
                     [UIColor colorWithRed:232/255.0f green:12/255.0f blue:201/255.0f alpha:1],
                     [UIColor colorWithRed:232/255.0f green:75/255.0f blue:12/255.0f alpha:1],
                     [UIColor colorWithRed:255/255.0f green:148/255.0f blue:13/255.0f alpha:1]];
    
    inputColors2 = @[[UIColor colorWithRed:129/255.0f green:201/255.0f blue:249/255.0f alpha:1],
                     [UIColor colorWithRed:90/255.0f green:140/255.0f blue:173/255.0f alpha:1],
                     [UIColor colorWithRed:250/255.0f green:215/255.0f blue:130/255.0f alpha:1],
                     [UIColor colorWithRed:173/255.0f green:137/255.0f blue:90/255.0f alpha:1]];

    inputColors3 = @[[UIColor colorWithRed:158/255.0f green:204/255.0f blue:186/255.0f alpha:1],
                     [UIColor colorWithRed:12/255.0f green:114/255.0f blue:130/255.0f alpha:1],
                     [UIColor colorWithRed:207/255.0f green:106/255.0f blue:19/255.0f alpha:1],
                     [UIColor colorWithRed:130/255.0f green:47/255.0f blue:12/255.0f alpha:1]];
    
    // TestSet
    inputColors4 = @[[UIColor colorWithRed:158/255.0f green:204/255.0f blue:186/255.0f alpha:1],
                     [UIColor colorWithRed:158/255.0f green:204/255.0f blue:186/255.0f alpha:1],
                     [UIColor colorWithRed:158/255.0f green:204/255.0f blue:186/255.0f alpha:1],
                     [UIColor colorWithRed:158/255.0f green:204/255.0f blue:186/255.0f alpha:1]];
    
    // NonAlphaSet
    inputColors5 = @[[UIColor colorWithRed:225/255.0f green:250/255.0f blue:205/255.0f alpha:1],
                     [UIColor colorWithRed:245/255.0f green:205/255.0f blue:255/255.0f alpha:1],
                     [UIColor colorWithRed:255/255.0f green:205/255.0f blue:225/255.0f alpha:1],
                     [UIColor colorWithRed:205/255.0f green:225/255.0f blue:255/255.0f alpha:1]];
    
    inputColors6 = @[[UIColor colorWithRed:80/255.0f green:193/255.0f blue:0/255.0f alpha:1],
                     [UIColor colorWithRed:166/255.0f green:4/255.0f blue:255/255.0f alpha:1],
                     [UIColor colorWithRed:255/255.0f green:0/255.0f blue:93/255.0f alpha:1],
                     [UIColor colorWithRed:0/255.0f green:137/255.0f blue:255/255.0f alpha:1]];
    
    inputColors7 = @[[UIColor colorWithRed:80/255.0f green:193/255.0f blue:0/255.0f alpha:1],
                     [UIColor colorWithRed:0/255.0f green:137/255.0f blue:255/255.0f alpha:1],
                     [UIColor colorWithRed:255/255.0f green:0/255.0f blue:93/255.0f alpha:1]];
    
                     
    [setOfColors addObject:inputColors1];
    [setOfColors addObject:inputColors2];
    [setOfColors addObject:inputColors3];
    [setOfColors addObject:inputColors4];
    [setOfColors addObject:inputColors5];
    [setOfColors addObject:inputColors6];
    [setOfColors addObject:inputColors7];

    return setOfColors;
}

- (NSMutableArray*)getRandomizedColors
{
    NSArray *inputColors = [self getColors][[Properties sharedProperties].worldStandardColorSet];
    NSMutableArray *resultColors = [NSMutableArray new];
    NSMutableArray *freeColorIndizes = [NSMutableArray new];
    
    for (int i = 0; i < [Properties sharedProperties].worldAreaCount; i++) {
        [freeColorIndizes addObject:[NSNumber numberWithInt:i]];
    }
        
    for (int i = 0; i < [Properties sharedProperties].worldAreaCount; i++) {
        random = arc4random() % freeColorIndizes.count;
        NSInteger nextColorIndex = [[freeColorIndizes objectAtIndex:random] integerValue];
        [freeColorIndizes removeObjectAtIndex:random];
        UIColor *nextColor = (UIColor*)[inputColors objectAtIndex:nextColorIndex];
        [resultColors addObject:nextColor];
    }
    
    return resultColors;
}

#pragma mark animations

- (void)fadeOutElement:(UIView*)element withCompletionHandler:(void (^) (void))handler;
{
    [UIView animateWithDuration:[Properties sharedProperties].worldFadeoutDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        element.alpha = 0;
        element.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [element removeFromSuperview];
    }];
}

- (void)fadeOutElement:(UIView*)element;
{
    [UIView animateWithDuration:[Properties sharedProperties].worldFadeoutDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        element.alpha = 0;
        element.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [element removeFromSuperview];
    }];
}

#pragma mark getter

- (int)getHowManyAreasLeft
{
    return areas.count;
}

- (NSMutableArray*)getAreas
{
    return areas;
}

@end
