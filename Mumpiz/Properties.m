//
//  Properties.m
//  Mumpiz
//
//  Created by Stefan Gregor on 07.05.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "Properties.h"
#import "UIDevice-Hardware.h"

@implementation Properties

@synthesize backgroundAlpha, backgroundColorSet, backgroundCount, backgroundMaxHeight, backgroundMaxWidth, backgroundMinHeight, backgroundMinWidth, backgroundSpeed, globalGameMode, globalBubbleLayerName, globalHeightRatio, globalWidthRatio, globalGameBoonCount, globalGameWidth, globalGameHeight, globalScreenHeight, globalScreenWidth, globalPlatform, globalBannerHeight, globalSoundOn, playerAlpha, playerJumpHeight, playerLength, playerSpeed, uiAlpha, uiItemCenterWidth, uiScoreLabelHeight, uiScreenLayerHeight, uiScreenLayerY, uiIPadOffsetX, uiMenuRotation, logicGravityY, logicSpeed, worldAreaAlpha, worldAreaCount, worldAreaLength, worldAreaStart, worldAreaXOffset, worldFadeoutDuration, worldStandardColorSet, isIpad;

+ (Properties *)sharedProperties
{
    static Properties *sharedProperties;
    
    @synchronized(self)
    {
        if (!sharedProperties) {
            sharedProperties = [[Properties alloc] init];
        }
        
        return sharedProperties;
    }
}

- (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

- (void)setup
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"mode"] isEqualToString:@"1"])
        globalGameMode = true;
    else
        globalGameMode = false;
    
    globalBannerHeight = 50;
    
    // How many boons
    if(globalGameMode)
        globalGameBoonCount = 4;
    else
        globalGameBoonCount = 3;
    
    // is it ipad?
    isIpad = NO;
    
    #ifdef UI_USER_INTERFACE_IDIOM
        isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    #endif
    
    if (isIpad) {
        globalBannerHeight = 66;
    }
    
    // GLOBAL
    globalGameHeight = [self screenSize].height - globalBannerHeight;
    globalScreenHeight = 568;
    globalGameWidth =  [self screenSize].width;
    globalScreenWidth = 320;
    globalHeightRatio = (float)globalGameHeight / (float)globalScreenHeight;
    globalWidthRatio = (float)globalGameWidth / (float)globalScreenWidth;
    globalBubbleLayerName = @"bubbleLayer2";
    globalSoundOn = true;
    
    
    // WORLD
    if(globalGameMode) {
        worldStandardColorSet = 5;
        worldAreaXOffset = 30;
    }
    else {
        worldStandardColorSet = 6;
        worldAreaXOffset = 60;
    }
    
    worldAreaCount = globalGameBoonCount;
    worldAreaLength = 120 / globalGameBoonCount * 4 * globalHeightRatio;
    worldFadeoutDuration = 0.3f;
    worldAreaStart = (globalGameWidth + worldAreaXOffset);
    
    if ([self isOldPhone]) {
        worldAreaAlpha = 1.0f;
    }
    else {
        worldAreaAlpha = 0.7f;
    }

    
    // BACKGROUND
    backgroundMaxWidth = worldAreaLength * 0.7;
    backgroundMinWidth = 20 * globalHeightRatio;
    backgroundMaxHeight = 0;
    backgroundMinHeight = 0;
    backgroundSpeed = 1 * globalWidthRatio;
    
    if ([self isOldPhone]) {
        backgroundCount = 10;
        backgroundColorSet = 4;
        backgroundAlpha = 1;
    }
    else {
        backgroundCount = 30;
        backgroundColorSet = worldStandardColorSet;
        backgroundAlpha = 0.1f;
    }
    
    
    // LOGIC
    logicSpeed = 2 * globalWidthRatio;
    logicGravityY = 0.22f * globalHeightRatio;
    
    
    // PLAYER
    playerLength = 50 * globalHeightRatio / globalGameBoonCount * 4;
    playerSpeed = 2;
    
    if(globalGameMode)
        playerJumpHeight = 1.3 * globalHeightRatio;
    else
        playerJumpHeight = 1.55 * globalHeightRatio;
    
    if ([self isOldPhone]) {
        playerAlpha = 1.0f;
    }
    else {
        playerAlpha = 0.7f;
    }
    
    // UI
    if (isIpad) {
        uiIPadOffsetX = 50;
        uiMenuRotation = 0.15f;
    }
    else {
        uiIPadOffsetX = -10;
        uiMenuRotation = M_PI / 4.5;
    }
    
    uiScreenLayerHeight = 320;
    uiItemCenterWidth = 60;
    uiScoreLabelHeight = 40;
    uiScreenLayerY = (globalGameHeight / 2 - uiScreenLayerHeight / 2) - 60;
    uiAlpha = 0.85f;
}

- (void)update
{
    // How many boons
    if(globalGameMode)
        globalGameBoonCount = 4;
    else
        globalGameBoonCount = 3;
    
    // WORLD
    if(globalGameMode) {
        worldStandardColorSet = 5;
        worldAreaXOffset = 30;
    }
    else {
        worldStandardColorSet = 6;
        worldAreaXOffset = 60;
    }
    
    worldAreaStart = (globalGameWidth + worldAreaXOffset);
    worldAreaCount = globalGameBoonCount;
    worldAreaLength = 120 / globalGameBoonCount * 4 * globalHeightRatio;
    
    // PLAYER
    playerLength = 50 * globalHeightRatio / globalGameBoonCount * 4;
    
    if(globalGameMode)
        playerJumpHeight = 1.3 * globalHeightRatio;
    else
        playerJumpHeight = 1.55 * globalHeightRatio;
    
    // BACKGROUND
    backgroundColorSet = worldStandardColorSet;
}

// test if iphone is old
- (BOOL)isOldPhone {
    
    // get current Device
    UIDevice *device = [UIDevice new];
    
    globalPlatform = device.platform;
    
    NSLog(@"Device: %@", globalPlatform);
    
    if ([globalPlatform isEqualToString:@"iPhone2,1"] ||
         [globalPlatform isEqualToString:@"iPhone3,1"] ||
         [globalPlatform isEqualToString:@"iPhone3,2"] ||
         [globalPlatform isEqualToString:@"iPhone3,3"])
            return true;
    else
        return false;
}

@end
