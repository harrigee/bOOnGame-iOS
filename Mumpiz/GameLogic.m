//
//  GameLogic.m
//  Mumpiz
//
//  Created by Stefan Gregor on 24.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "GameLogic.h"
#import "Properties.h"
#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface GameLogic ()

@property Player *player;
@property World *world;
@property CollisionDetector *collisionDetector;
@property Gravity *gravity;
@property UI *ui;
@property ADBannerView *adBannerView;
@property ViewController *superViewController;
@property bool stopped;
@property AVAudioPlayer *deadSound;
@property AVAudioPlayer *areaSound;
@property AVAudioPlayer *areaSound2;
@property AVAudioPlayer *areaSound3;
@property AVAudioPlayer *areaSound4;

@end

@implementation GameLogic

@synthesize deadSound, areaSound, areaSound2, areaSound3, areaSound4;
@synthesize adBannerView, superViewController;
@synthesize player, world, collisionDetector, gravity, ui, dead, stopped;

- (instancetype)initWithPlayer:(Player*)playerParam
                andWorld:(World*)worldParam
                andGravity:(Gravity*)gravityParam
                andUI:(UI *)uiParam
                andBannerView:(ADBannerView*)adBannerViewParam
                andSuperViewController:(ViewController*)superViewControllerParam
{
    player = playerParam;
    world = worldParam;
    gravity = gravityParam;
    ui = uiParam;
    adBannerView = adBannerViewParam;
    adBannerView.delegate = self;
    superViewController = superViewControllerParam;
    collisionDetector = [[CollisionDetector alloc] initWithAchievementsDelegate:self.delegate];

    // delegates
    world.delegate = self;
    ui.delegate = self;
    
    // sound loading
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"soundDead" ofType:@"wav" ]];
    deadSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [deadSound prepareToPlay];
    
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound1" ofType:@"wav" ]];
    areaSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [areaSound prepareToPlay];
    
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound2" ofType:@"wav" ]];
    areaSound2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [areaSound2 prepareToPlay];
    
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound3" ofType:@"wav" ]];
    areaSound3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [areaSound3 prepareToPlay];
    
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound4" ofType:@"wav" ]];
    areaSound4 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [areaSound4 prepareToPlay];

    // first backgroundcolor of player
    [player setPossibleColors:[world getColors][[Properties sharedProperties].worldStandardColorSet]];
    [player setRandomColor];
    
    dead = true;
    stopped = true;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    return self;
}

// update routine

- (void)update
{
    if(!dead && !stopped) {
        
        // handle collisions
        [self handleCollisions];
        
        // gravity
        [gravity gravitate:player];
        
        // updating player
        [player move];
        
        // updating world
        [world move];
    }
    else
        [world moveBackgroundWithoutWorld];
    
    // bring ui in front
    [ui bringToFront];
}

# pragma mark - controlling the game -

// handle all collisions
- (void) handleCollisions
{    
    // get collided Views
    NSMutableArray *collidedViews = [collisionDetector collisionBetweenView:player andMultipleViews:[world getAreas]];

    // count through collided views
    for (UIView* view in collidedViews) {
        
        // if the collisionview is of the same backgroundcolor as the player
        if([view.backgroundColor isEqual:player.backgroundColor] && view.transform.a == 1)
        {
            [self scoredWithView:view];
            [self checkForAchievements];
        }
        else if (view.transform.a == 1) {
            // if player is not yet dead, play dead sound
            if(!dead) {
                if([Properties sharedProperties].globalSoundOn)
                    [self performSelectorInBackground:@selector(playDeadSound) withObject:nil];
            }
            
            // player is dead and menu is shown
            dead = true;
            [player setDead];
            [ui showGameOverScreen];
        }
    }
}

// shows the score and counts
- (void)scoredWithView:(UIView*)view
{
    // collisionview is beeing removed
    [world removeArea:view];
    
    // score plus x
    int areaCount = [world getHowManyAreasLeft];
    int addScore = [Properties sharedProperties].worldAreaCount * 2 - areaCount;
    
    // add score
    [ui addToScore:addScore forView:view];
    //[ui addToScore:1];
    
    // play collision sound
    if([Properties sharedProperties].globalSoundOn)
        [self playCollisionSoundForView:view withScore:addScore];
    
    // fade out element
    [world fadeOutElement:view withCompletionHandler:^{[view removeFromSuperview];}];
    
    // new backgroundcolor for the player
    [player setRandomColor];
}

# pragma mark Achievements

- (void)checkForAchievements
{
    if(ui.score >= 1 && ui.score < 10)
        [self.delegate reportAchievement:POINTS_1];
    else if(ui.score >= 10 && ui.score < 25)
        [self.delegate reportAchievement:POINTS_10];
    else if(ui.score >= 25 && ui.score < 50)
        [self.delegate reportAchievement:POINTS_25];
    else if(ui.score >= 50 && ui.score < 100)
        [self.delegate reportAchievement:POINTS_50];
    else if(ui.score >= 100 && ui.score < 250)
        [self.delegate reportAchievement:POINTS_100];
    else if(ui.score >= 250 && ui.score < 500)
        [self.delegate reportAchievement:POINTS_250];
    else if(ui.score >= 500 && ui.score < 1000)
        [self.delegate reportAchievement:POINTS_500];
    else if(ui.score >= 1000)
        [self.delegate reportAchievement:POINTS_1000];
}

# pragma mark Touches

// what if we touch the screen
- (void)touchesBegan
{
    if (!dead && !stopped) {
        [player jump];
    }
    else {
        // TODO: Implement Jumper for start
        [ui countdownToRestartManual];
    }
}

// sets new color for the player
- (void)setNewColorsForPlayer
{
    [player setPossibleColors:[world getColors][[Properties sharedProperties].worldStandardColorSet]];
}

// resets the game
- (void) resetGame
{
    [world reset];
    [player reset];
}

#pragma mark - sound -

- (void)playDeadSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [deadSound stop];
    [deadSound setCurrentTime:0.0];
    [deadSound play];
}

- (void)playCollisionSoundForView:(UIView*)view withScore:(int)score
{
    if(score == 1)
    {
        [self performSelectorInBackground:@selector(playCollisionSound1) withObject:nil];
    }
    else if(score == 2)
    {
        [self performSelectorInBackground:@selector(playCollisionSound2) withObject:nil];
    }
    else if(score == 3)
    {
        [self performSelectorInBackground:@selector(playCollisionSound3) withObject:nil];
    }
    else if(score == 4)
    {
        [self performSelectorInBackground:@selector(playCollisionSound4) withObject:nil];
    }
}

- (void)playCollisionSound1
{
    [areaSound stop];
	[areaSound setCurrentTime:0.0];
    [areaSound play];
    [areaSound prepareToPlay];
}

- (void)playCollisionSound2
{
    [areaSound2 stop];
	[areaSound2 setCurrentTime:0.0];
    [areaSound2 play];
    [areaSound2 prepareToPlay];
}

- (void)playCollisionSound3
{
    [areaSound3 stop];
	[areaSound3 setCurrentTime:0.0];
    [areaSound3 play];
    [areaSound3 prepareToPlay];
}

- (void)playCollisionSound4
{
    [areaSound4 stop];
	[areaSound4 setCurrentTime:0.0];
    [areaSound4 play];
    [areaSound4 prepareToPlay];
}

# pragma mark - delegates -

# pragma mark iAd Delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    banner.hidden = false;
    NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    banner.hidden = true;
    NSLog(@"didFailToReceiveAdWithError: %@", error);
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"bannerViewActionShouldBegin");
    [ui pauseGame];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerViewActionDidFinish");
    //[ui startAnimateMenu];
}

// UI-Delegate

- (void) continueGame
{
    stopped = false;
    dead = false;
    [ui reset];
}

- (void)stopGame
{
    if(dead) {
        [self resetGame];
    }
    else if(!stopped) {
        stopped = true;
    }
    [player clearMotionVector];
}

- (void)submitScore:(int)score
{
    [superViewController reportScore:score];
}

- (void)showLeaderboard
{
    [superViewController showLeaderboard];
}

- (void)modeChanged
{
    [Properties sharedProperties].globalGameMode = ![Properties sharedProperties].globalGameMode;
    [[Properties sharedProperties] update];
        
    [player setPossibleColors:[world getColors][[Properties sharedProperties].worldStandardColorSet]];
    [player updateProperties];
    
    [world reset];
}

// World-Delegate
- (void)newAreasCreated
{
    [self setNewColorsForPlayer];
}

@end
