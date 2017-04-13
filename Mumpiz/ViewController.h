//
//  ViewController.h
//  Mumpiz
//
//  Created by Stefan Gregor on 19.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "AchievementsViewController.h"
#import "GameLogic.h"

@interface ViewController : UIViewController<GKGameCenterControllerDelegate, GKLeaderboardViewControllerDelegate, AchievementsDelegate>

- (void)startMenuAnimation;
- (void)pauseGame;
- (void)reportScore:(int64_t)score;
- (void)showLeaderboard;

@property ADBannerView *adBannerView;

@end
