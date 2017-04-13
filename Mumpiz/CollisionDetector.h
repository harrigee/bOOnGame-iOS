//
//  CollisionDetector.h
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AchievementsViewController.h"

@protocol AchievementsDelegate

- (void)reportAchievement:(AchievementType)type;

@end

@interface CollisionDetector : NSObject

- (id)initWithAchievementsDelegate:(id<AchievementsDelegate>)achievementsDelegateParam;

- (NSMutableArray*)collisionBetweenView:(UIView *)view andMultipleViews:(NSMutableArray*)views;
- (BOOL)collisionBetweenView:(UIView*)view1 andView:(UIView*)view2;

@end
