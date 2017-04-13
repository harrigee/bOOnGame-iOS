//
//  GameCenterViewController.h
//  Mumpiz
//
//  Created by Stefan Gregor on 11.06.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementsViewController : UIViewController

typedef enum
{
    POINTS_1,
    POINTS_10,
    POINTS_25,
    POINTS_50,
    POINTS_100,
    POINTS_250,
    POINTS_500,
    POINTS_1000,
    SO_CLOSE,
    DOUBLED,
    TRIPPLED,
    MAX,
    
}AchievementType;

@property(nonatomic,assign) AchievementType type;

- (void)showAchievement:(AchievementType)achievement;

@end
