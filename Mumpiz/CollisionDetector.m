//
//  CollisionDetector.m
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "CollisionDetector.h"
#import "Properties.h"
#import "GameLogic.h"


@interface CollisionDetector()

@property id<AchievementsDelegate> achievementsDelegate;

@end

@implementation CollisionDetector

@synthesize achievementsDelegate;

- (id)initWithAchievementsDelegate:(id<AchievementsDelegate>)achievementsDelegateParam {
    
    self = [super init];
    if(self) {
        achievementsDelegate = achievementsDelegateParam;
    }
    return self;
}

// detects if a view and multiple other ones did collide
- (NSMutableArray*)collisionBetweenView:(UIView *)view andMultipleViews:(NSMutableArray*)views
{
    NSMutableArray *collidedViews = [NSMutableArray new];
    
    for (UIView *collisionView in views) {
        if ([self collisionBetweenView:view andView:collisionView]) {
            [collidedViews addObject:collisionView];
        }
    }

    return collidedViews;
}

// detects if a view and another one did collide
- (BOOL)collisionBetweenView:(UIView*)view1 andView:(UIView*)view2
{
    //[[view1.layer presentationLayer] center].x;
    
    float lengthFromCenterToCenter = sqrt((view1.center.x - view2.center.x) *
                                          (view1.center.x - view2.center.x) +
                                          (view1.center.y - view2.center.y) *
                                          (view1.center.y - view2.center.y));
    
    float lengthFromRads = view1.frame.size.width / 2 + view2.frame.size.width / 2;
    
    float tester = lengthFromCenterToCenter - lengthFromRads - 1;
    
    if(tester < 1 && tester > 0)
       [achievementsDelegate reportAchievement:SO_CLOSE];
    
    if(lengthFromCenterToCenter <= lengthFromRads - 1 /* * [Properties sharedProperties].globalWidthRatio*/)
        return true;
    
    return false;
}

@end
