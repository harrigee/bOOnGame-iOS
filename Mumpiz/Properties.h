//
//  Properties.h
//  Mumpiz
//
//  Created by Stefan Gregor on 07.05.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Properties : NSObject

+ (Properties *)sharedProperties;

// GLOBAL
@property BOOL globalGameMode;
@property int globalGameBoonCount;
@property int globalGameHeight;
@property int globalBannerHeight;
@property int globalScreenHeight;
@property int globalScreenWidth;
@property int globalGameWidth;
@property float globalHeightRatio;
@property float globalWidthRatio;
@property BOOL globalSoundOn;
@property NSString *globalBubbleLayerName;
@property NSString *globalPlatform;

// BACKGROUND
@property int backgroundColorSet;
@property int backgroundMaxWidth;
@property int backgroundMinWidth;
@property int backgroundMaxHeight;
@property int backgroundMinHeight;
@property float backgroundSpeed;
@property int backgroundCount;
@property float backgroundAlpha;

// WORLD
@property int worldStandardColorSet;
@property int worldAreaCount;
@property int worldAreaLength;
@property float worldFadeoutDuration;
@property float worldAreaAlpha;
@property int worldAreaXOffset;
@property int worldAreaStart;

// LOGIC
@property float logicSpeed;
@property float logicGravityY;

// PLAYER
@property int playerLength;
@property float playerSpeed;
@property float playerJumpHeight;
@property float playerAlpha;

// UI
@property int uiItemCenterWidth;
@property int uiScoreLabelHeight;
@property int uiScreenLayerHeight;
@property int uiScreenLayerY;
@property int uiIPadOffsetX;
@property float uiAlpha;
@property float uiMenuRotation;
@property BOOL isIpad;

- (void)setup;
- (void)update;


@end
