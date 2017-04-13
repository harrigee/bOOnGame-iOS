//
//  GameLogic.h
//  Mumpiz
//
//  Created by Stefan Gregor on 24.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "World.h"
#import "CollisionDetector.h"
#import "Gravity.h"
#import "UI.h"
#import "AchievementsViewController.h"
#import <iAd/iAd.h>

@interface GameLogic : NSObject<UIDelegate, WorldDelegate, ADBannerViewDelegate>

@property bool dead;

- (instancetype)initWithPlayer:(Player*)playerParam
                      andWorld:(World*)worldParam
                    andGravity:(Gravity*)gravityParam
                         andUI:(UI *)uiParam
                 andBannerView:(ADBannerView*)adBannerViewParam
        andSuperViewController:(UIViewController*)superViewController;

- (void)update;
- (void)touchesBegan;

@property (nonatomic, assign) id<AchievementsDelegate>delegate;

@end
