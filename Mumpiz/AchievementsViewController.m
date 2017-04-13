//
//  GameCenterViewController.m
//  Mumpiz
//
//  Created by Stefan Gregor on 11.06.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "AchievementsViewController.h"
#import <GameKit/GameKit.h>
#import "Properties.h"


@interface AchievementsViewController ()

@end

@implementation AchievementsViewController

@synthesize type;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Achievements

- (void)showAchievement:(AchievementType)achievementType
{
    switch ([Properties sharedProperties].globalGameMode) {
        case true: {
            switch (achievementType) {
                case POINTS_1:
                    [self reportAchievementComplete:@"1bOOnHard"];
                    break;
                case POINTS_10:
                    [self reportAchievementComplete:@"10bOOnHard"];
                    break;
                case POINTS_25:
                    [self reportAchievementComplete:@"25bOOnHard"];
                    break;
                case POINTS_50:
                    [self reportAchievementComplete:@"50bOOnHard"];
                    break;
                case POINTS_100:
                    [self reportAchievementComplete:@"100bOOnHard"];
                    break;
                case POINTS_250:
                    [self reportAchievementComplete:@"250bOOnHard"];
                    break;
                case POINTS_500:
                    [self reportAchievementComplete:@"500bOOnHard"];
                    break;
                case POINTS_1000:
                    [self reportAchievementComplete:@"1000bOOnHard"];
                    break;
                case SO_CLOSE:
                    [self reportAchievementComplete:@"soClose"];
                    break;
                default:
                    break;
            }
            break;
        }
        case false: {
            switch (achievementType) {
                case POINTS_1:
                    [self reportAchievementComplete:@"1bOOnEasy"];
                    break;
                case POINTS_10:
                    [self reportAchievementComplete:@"10bOOnEasy"];
                    break;
                case POINTS_25:
                    [self reportAchievementComplete:@"25bOOnEasy"];
                    break;
                case POINTS_50:
                    [self reportAchievementComplete:@"50bOOnEasy"];
                    break;
                case POINTS_100:
                    [self reportAchievementComplete:@"100bOOnEasy"];
                    break;
                case POINTS_250:
                    [self reportAchievementComplete:@"250bOOnEasy"];
                    break;
                case POINTS_500:
                    [self reportAchievementComplete:@"500bOOnEasy"];
                    break;
                case POINTS_1000:
                    [self reportAchievementComplete:@"1000bOOnEasy"];
                    break;
                case SO_CLOSE:
                    [self reportAchievementComplete:@"soClose"];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)reportAchievementComplete:(NSString*)identifier
{
    if(![[[NSUserDefaults standardUserDefaults] stringForKey:identifier] isEqualToString:@"1"]) {
        
        GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        
        achievement.percentComplete = 100;
        if(achievement) {
            [achievement reportAchievementWithCompletionHandler:^(NSError *error){
                if(error!=nil) {
                    NSLog(@"Error sending Achievement: %@", error);
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:identifier];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"Acvhievement sent!");
                }
            }];
        }
    }
    else {
        NSLog(@"Acvhievement already unlocked!");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
