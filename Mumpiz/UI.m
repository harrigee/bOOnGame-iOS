//
//  UI.m
//  Mumpiz
//
//  Created by Stefan Gregor on 29.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "UI.h"
#import "Properties.h"
#import "ViewController.h"

@interface UI ()

@property ViewController *superViewController;
@property UIView *superview;
@property UIView *viewCenter;
@property UIView *viewCounter;
@property UIView *viewLeft;
@property UIView *viewMenuScreen;
@property UIView *mainMenuContentScreen;
@property UIView *bannerView;
@property UILabel *counterLabel;
@property UILabel *scoreLabel;
@property UILabel *yourScoreLabel;
@property UILabel *bestScoreLabel;
@property UILabel *menuNameLabel;
@property UILabel *boonLabel;
@property UIButton *retryButton;
@property UIButton *pauseButton;
@property UIButton *shareButton;
@property UIButton *soundButton;
@property UIButton *leaderBoardButton;
@property UIButton *modeButton;
@property UIColor *uiColor;
@property __block NSTimer *menuTimer;
@property __block int countdown;
@property __block BOOL screenIsShown;
@property __block BOOL isCounting;
@property __block int bestScore;
@property __block BOOL animateLeft;
@property float rotation;
@property float rotationSound;
@property float rotationRetry;
@property float rotationShare;
@property float rotationMenu;
@property float rotationLeaderboard;
@property float rotationMode;

@end

@implementation UI

@synthesize bannerView, superViewController, superview, viewCenter, viewCounter, viewLeft, scoreLabel, score, bestScore, viewMenuScreen, mainMenuContentScreen, yourScoreLabel, counterLabel, bestScoreLabel, menuNameLabel, boonLabel, retryButton, modeButton, pauseButton, leaderBoardButton, shareButton, soundButton, menuTimer, countdown, uiColor, screenIsShown, isCounting, animateLeft, rotation, rotationSound, rotationRetry, rotationShare, rotationMenu, rotationLeaderboard, rotationMode;

- (instancetype)initWithSuperview:(UIView*)superviewParam andSuperViewController:(ViewController*)superViewControllerParam
{
    self = [super init];
    if(self) {
        superview = superviewParam;
        
        uiColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.4 alpha:[Properties sharedProperties].uiAlpha];
        
        countdown = 3;
        
        screenIsShown = false;
        
        isCounting = false;
        
        superViewController = superViewControllerParam;
        
        score = 0;
        
        bestScore = 0;
        
        rotation = 0.015f;
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    // bannerView
    bannerView = [UIView new];
    bannerView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [Properties sharedProperties].globalBannerHeight);
    bannerView.center = CGPointMake(bannerView.center.x, [[UIScreen mainScreen] bounds].size.height - [Properties sharedProperties].globalBannerHeight / 2);
    bannerView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];

    // mantro logo
    UIImageView *boonImageView = [UIImageView new];
    boonImageView.frame = CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height);
    boonImageView.backgroundColor = [UIColor clearColor];
    boonImageView.image = [UIImage imageNamed:@"mantrologo"];
    boonImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMantroLogo:)];
    [self.bannerView addGestureRecognizer:singleFingerTap];
    
    // banner view
    [bannerView addSubview:boonImageView];
    [self.superview addSubview:bannerView];
    
    // side hud
    viewLeft = [UIView new];
    viewLeft.frame = CGRectMake(0 - [Properties sharedProperties].uiItemCenterWidth / 2, - [Properties sharedProperties].uiItemCenterWidth / 2, [Properties sharedProperties].uiItemCenterWidth, [Properties sharedProperties].uiItemCenterWidth);
    viewLeft.backgroundColor = uiColor;
    viewLeft.layer.cornerRadius = 25;
    //[superview addSubview:viewLeft];
    
    // normal hud
    viewCenter = [UIView new];
    viewCenter.frame = CGRectMake([Properties sharedProperties].globalGameWidth / 2 - [Properties sharedProperties].uiItemCenterWidth / 2, - [Properties sharedProperties].uiItemCenterWidth / 2, [Properties sharedProperties].uiItemCenterWidth, [Properties sharedProperties].uiItemCenterWidth);
    viewCenter.backgroundColor = uiColor;
    viewCenter.layer.cornerRadius = 25;
    [superview addSubview:viewCenter];

    // counter hud
    viewCounter = [UIView new];
    viewCounter.frame = CGRectMake(0,0, [Properties sharedProperties].uiScreenLayerHeight / 2, [Properties sharedProperties].uiScreenLayerHeight / 2);
    viewCounter.center = CGPointMake([Properties sharedProperties].globalGameWidth / 2, [Properties sharedProperties].globalGameHeight / 2);
    viewCounter.backgroundColor = uiColor;
    viewCounter.layer.cornerRadius = viewCounter.frame.size.width / 2;
    
    counterLabel = [UILabel new];
    counterLabel.frame = CGRectMake(0, 0, viewCounter.frame.size.width, viewCounter.frame.size.height);
    counterLabel.center = CGPointMake(viewCounter.frame.size.width / 2, viewCounter.frame.size.height / 2);
    counterLabel.textAlignment = NSTextAlignmentCenter;
    counterLabel.backgroundColor = [UIColor clearColor];
    counterLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:80.0f];
    counterLabel.textColor  = [UIColor whiteColor];
    counterLabel.text = [NSString stringWithFormat:@"%i", 3];
    [viewCounter addSubview:counterLabel];
    
    // score label
    scoreLabel = [UILabel new];
    scoreLabel.frame = CGRectMake(0, 0, [Properties sharedProperties].uiScoreLabelHeight * 4, [Properties sharedProperties].uiScoreLabelHeight);
    scoreLabel.center = CGPointMake(viewCenter.center.x, viewCenter.center .y + [Properties sharedProperties].uiScoreLabelHeight - 28);
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20.0f];
    scoreLabel.textColor  = [UIColor whiteColor];
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    [superview addSubview:scoreLabel];

    // menu
    viewMenuScreen = [UIView new];
    viewMenuScreen.frame = CGRectMake([Properties sharedProperties].globalGameWidth / 2 - [Properties sharedProperties].uiScreenLayerHeight / 2, [Properties sharedProperties].uiScreenLayerY, [Properties sharedProperties].uiScreenLayerHeight, [Properties sharedProperties].uiScreenLayerHeight);
    viewMenuScreen.center = CGPointMake(-viewMenuScreen.frame.size.width - 5, [Properties sharedProperties].uiScreenLayerY + viewMenuScreen.frame.size.height / 2);
    viewMenuScreen.layer.cornerRadius = 0;
    viewMenuScreen.backgroundColor = [UIColor colorWithRed:105/255.0f green:29/255.0f blue:116/255.0f alpha:1];
    viewMenuScreen.layer.masksToBounds = false;
    
    mainMenuContentScreen = [UIView new];
    mainMenuContentScreen.frame = CGRectMake(0, 0, [Properties sharedProperties].uiScreenLayerHeight, [Properties sharedProperties].uiScreenLayerHeight);
    mainMenuContentScreen.backgroundColor = [UIColor clearColor];
    
    [viewMenuScreen addSubview:mainMenuContentScreen];
    
    boonLabel = [UILabel new];
    boonLabel.frame = CGRectMake(0, -47, viewMenuScreen.frame.size.width, 50);
    boonLabel.textAlignment = NSTextAlignmentCenter;
    boonLabel.backgroundColor = [UIColor clearColor];
    boonLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0f];
    boonLabel.textColor  = uiColor;
    boonLabel.text = [NSString stringWithFormat:@"bOOn"];
    [viewMenuScreen addSubview:boonLabel];
    
    menuNameLabel = [UILabel new];
    menuNameLabel.frame = CGRectMake(0, 0, [Properties sharedProperties].uiScreenLayerHeight, [Properties sharedProperties].uiScreenLayerHeight);
    menuNameLabel.center = CGPointMake(viewMenuScreen.frame.size.width / 2, 50);
    menuNameLabel.textAlignment = NSTextAlignmentCenter;
    menuNameLabel.backgroundColor = [UIColor clearColor];
    menuNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0f];
    menuNameLabel.textColor  = [UIColor whiteColor];
    menuNameLabel.text = [NSString stringWithFormat:@"[ welcome ]"];
    [mainMenuContentScreen addSubview:menuNameLabel];
    
    bestScoreLabel = [UILabel new];
    bestScoreLabel.frame = CGRectMake(0, 0, [Properties sharedProperties].uiScreenLayerHeight, [Properties sharedProperties].uiScoreLabelHeight);
    if([Properties sharedProperties].isIpad)
        bestScoreLabel.center = CGPointMake(viewMenuScreen.frame.size.width / 2, viewMenuScreen.frame.size.height / 4 * [Properties sharedProperties].globalHeightRatio + 15);
    else
        bestScoreLabel.center = CGPointMake(viewMenuScreen.frame.size.width / 2, viewMenuScreen.frame.size.height / 4 + 15);
    bestScoreLabel.textAlignment = NSTextAlignmentCenter;
    bestScoreLabel.backgroundColor = [UIColor clearColor];
    bestScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.0f];
    bestScoreLabel.textColor  = [UIColor whiteColor];
    bestScoreLabel.text = [NSString stringWithFormat:@"best score: %i", bestScore];
    [mainMenuContentScreen addSubview:bestScoreLabel];
    
    yourScoreLabel = [UILabel new];
    yourScoreLabel.frame = CGRectMake(0, 0, [Properties sharedProperties].uiScreenLayerHeight, [Properties sharedProperties].uiScreenLayerHeight);
    if([Properties sharedProperties].isIpad)
        yourScoreLabel.center = CGPointMake(viewMenuScreen.frame.size.width / 2, viewMenuScreen.frame.size.height / 4 * [Properties sharedProperties].globalHeightRatio + 55);
    else
        yourScoreLabel.center = CGPointMake(viewMenuScreen.frame.size.width / 2, viewMenuScreen.frame.size.height / 4 + 55);
    yourScoreLabel.textAlignment = NSTextAlignmentCenter;
    yourScoreLabel.backgroundColor = [UIColor clearColor];
    yourScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.0f];
    yourScoreLabel.textColor  = [UIColor whiteColor];
    yourScoreLabel.text = [NSString stringWithFormat:@"your score: %i", score];
    [mainMenuContentScreen addSubview:yourScoreLabel];
    
    retryButton = [UIButton new];
    retryButton.frame = CGRectMake(0, 0, 120, 120);
    retryButton.center = CGPointMake([Properties sharedProperties].globalGameWidth / 2 + 40 + [Properties sharedProperties].uiIPadOffsetX, [[UIScreen mainScreen] bounds].size.height + retryButton.frame.size.height);
    [retryButton setTitle: @"start" forState: UIControlStateNormal];
    retryButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    retryButton.titleLabel.textColor = [UIColor whiteColor];
    retryButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:110/255.0f blue:240/255.0f alpha:1];
    retryButton.layer.cornerRadius = 0;
    [retryButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [retryButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton = [UIButton new];
    shareButton.frame = CGRectMake(0, 0, 130, 130);
    shareButton.center = CGPointMake([Properties sharedProperties].globalGameWidth + shareButton.frame.size.width / 2 + 10, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight - 80);
    [shareButton setTitle: @"share" forState: UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    shareButton.titleLabel.textColor = [UIColor whiteColor];
    shareButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:0/255.0f blue:80/255.0f alpha:1];
    shareButton.layer.cornerRadius = 0;
    [shareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    leaderBoardButton = [UIButton new];
    leaderBoardButton.frame = CGRectMake(0, 0, 110, 110);
    leaderBoardButton.center = CGPointMake(-leaderBoardButton.frame.size.width / 2, [Properties sharedProperties].globalGameHeight + leaderBoardButton.frame.size.height / 2);
    [leaderBoardButton setTitle: @"rankings" forState: UIControlStateNormal];
    leaderBoardButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    leaderBoardButton.titleLabel.textColor = [UIColor blackColor];
    leaderBoardButton.backgroundColor = [UIColor colorWithRed:20/255.0f green:180/255.0f blue:0/255.0f alpha:1];
    leaderBoardButton.layer.cornerRadius = 0;
    [leaderBoardButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leaderBoardButton addTarget:self action:@selector(leaderBoardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    pauseButton = [UIButton new];
    pauseButton.frame = viewCenter.frame;
    pauseButton.center = CGPointMake([Properties sharedProperties].globalGameWidth + pauseButton.frame.size.width / 2 + 1, + pauseButton.frame.size.height / 2 - 15);
    [pauseButton setTitle: @"| |" forState: UIControlStateNormal];
    pauseButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [pauseButton setTitleColor:uiColor forState:UIControlStateNormal];
    pauseButton.backgroundColor = [UIColor clearColor];
    [pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:pauseButton];
    
    soundButton = [UIButton new];
    soundButton.frame = CGRectMake(0, 0, 100, 50);
    soundButton.center = CGPointMake([Properties sharedProperties].globalGameWidth - soundButton.frame.size.width / 2 + 20, - soundButton.frame.size.height / 2 - 15);
    [soundButton setTitle: @"sound on" forState: UIControlStateNormal];
    soundButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    [soundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    soundButton.backgroundColor = uiColor;
    soundButton.layer.cornerRadius = 25;
    [soundButton addTarget:self action:@selector(soundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    soundButton.hidden = false;
    
    modeButton = [UIButton new];
    modeButton.frame = CGRectMake(0, 0, 70, 70);
    modeButton.center = CGPointMake(10,10);
    [modeButton setTitle: @"hard" forState: UIControlStateNormal];
    modeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    [modeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modeButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:0/255.0f blue:80/255.0f alpha:1];
    modeButton.layer.cornerRadius = 35;
    [modeButton addTarget:self action:@selector(modeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    modeButton.hidden = false;
    
    [self setupSound];
    [self setupMode];
    
    // Rotations
    rotationMenu = [Properties sharedProperties].uiMenuRotation;
    rotationRetry = -M_PI / 5;
    rotationShare = -M_PI / 15;
    rotationSound = M_PI / 7;
    rotationLeaderboard = 0.25;
    //rotationMode = -M_PI / 7;
    rotationMode = -0.8f;
    
    viewMenuScreen.transform = CGAffineTransformMakeRotation(rotationMenu);
    retryButton.transform = CGAffineTransformMakeRotation(rotationRetry);
    shareButton.transform = CGAffineTransformMakeRotation(rotationShare);
    soundButton.transform = CGAffineTransformMakeRotation(rotationSound);
    leaderBoardButton.transform = CGAffineTransformMakeRotation(rotationLeaderboard);
    modeButton.transform = CGAffineTransformMakeRotation(rotationMode);
}

- (void)handleTapOnMantroLogo:(UITapGestureRecognizer *)recognizer
{    
    NSURL *url = [NSURL URLWithString:@"http://www.mantro.net"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void)showMenuScreenWithText:(NSString*)text
{
    [self startAnimateMenu];
    
    if (!screenIsShown) {
        
        screenIsShown = true;
        
        menuNameLabel.text = text;
        [self saveBestScore];
        [self updateGameOverScreenValues];
        
        CGPoint menuCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth / 2 - viewMenuScreen.frame.size.width / 5 + [Properties sharedProperties].uiIPadOffsetX, [Properties sharedProperties].uiScreenLayerY + viewMenuScreen.frame.size.height / 2 + 10);
        
        CGPoint retryButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth / 2 + 40 + [Properties sharedProperties].uiIPadOffsetX, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight + 37);
        
        CGPoint shareButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth / 2 + 115 + [Properties sharedProperties].uiIPadOffsetX, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight - 40);
        
        CGPoint soundButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth - soundButton.frame.size.width / 2 + 17, soundButton.frame.size.height / 2 - 17);
        
        CGPoint pauseButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth + pauseButton.frame.size.width / 2 + 1, + pauseButton.frame.size.height / 2 - 15);
        
        CGPoint leaderBoardButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth / 2 - 61 + [Properties sharedProperties].uiIPadOffsetX, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight + 60);
        
        //CGPoint modeButtonCenterForAnimation = CGPointMake([Properties sharedProperties].globalGameWidth / 2 + 135 + [Properties sharedProperties].uiIPadOffsetX, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight - 195);

        [superview insertSubview:viewMenuScreen belowSubview:bannerView];
        [superview insertSubview:shareButton belowSubview:bannerView];
        
        if(![text isEqualToString:@"[ pause ]"])
            [viewMenuScreen insertSubview:modeButton belowSubview:bannerView];
        
        [superview insertSubview:leaderBoardButton belowSubview:bannerView];
        [superview insertSubview:retryButton belowSubview:bannerView];
        [superview insertSubview:soundButton belowSubview:bannerView];
                
        [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewMenuScreen.center = menuCenterForAnimation;
        }
        completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                retryButton.center = retryButtonCenterForAnimation;
                shareButton.center = shareButtonCenterForAnimation;
                soundButton.center = soundButtonCenterForAnimation;
                pauseButton.center = pauseButtonCenterForAnimation;
                leaderBoardButton.center = leaderBoardButtonCenterForAnimation;
                //modeButton.center = modeButtonCenterForAnimation;
            }
            completion:^(BOOL finished){
            }];
        }];
    }
}

- (void)showMenuScreen
{
    [self stopAnimateMenu];
    [self showMenuScreenWithText:[NSString stringWithFormat:@"[ welcome ]"]];
    [retryButton setTitle:[NSString stringWithFormat:@"start"] forState: UIControlStateNormal];
}

- (void)showGameOverScreen
{
    [self showMenuScreenWithText:[NSString stringWithFormat:@"[ game over ]"]];
    [retryButton setTitle:[NSString stringWithFormat:@"retry"] forState: UIControlStateNormal];
}

- (void)hideGameOverScreen
{
    screenIsShown = false;
    [viewMenuScreen removeFromSuperview];
    [retryButton removeFromSuperview];
    [shareButton removeFromSuperview];
    [soundButton removeFromSuperview];
    [modeButton removeFromSuperview];
    [leaderBoardButton removeFromSuperview];
}

- (void)bringToFront
{
    [superview bringSubviewToFront:viewCenter];
    [superview bringSubviewToFront:scoreLabel];
    [superview bringSubviewToFront:pauseButton];
    [superview bringSubviewToFront:bannerView];
    [superview bringSubviewToFront:modeButton];
    [superview bringSubviewToFront:superViewController.adBannerView];
    
    // DEBUGREASONS
    //[pauseButton setTitle:[NSString stringWithFormat:@"%i", superview.subviews.count] forState: UIControlStateNormal];
}

- (void)saveBestScore
{
    NSString *savedScore;
    
    BOOL mode = [Properties sharedProperties].globalGameMode;
    
    if (mode)
        savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreHard"];
    else
        savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreEasy"];
    
    if(savedScore) {
        if([savedScore integerValue] <= score) {
            if (mode) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", score] forKey:@"bestScoreHard"];
            }
            else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", score] forKey:@"bestScoreEasy"];
            }
            bestScore = score;
        }
        else
            bestScore = [savedScore integerValue];
    }
    else {
        if (mode) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", score] forKey:@"bestScoreHard"];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", score] forKey:@"bestScoreEasy"];
        }
        bestScore = score;
    }
    
    // GameCenter score
    [self.delegate submitScore:bestScore];
}

- (void)updateGameOverScreenValues
{
    NSString *savedScore;
    
    BOOL mode = [Properties sharedProperties].globalGameMode;
        
    if (mode)
        savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreHard"];
    else
        savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreEasy"];
    
    bestScore = [savedScore integerValue];

    if(bestScore == score && bestScore != 0)
        menuNameLabel.text = [NSString stringWithFormat:@"[ highscore! ]"];
    
    bestScoreLabel.text = [NSString stringWithFormat:@"best score: %i", bestScore];
    yourScoreLabel.text = [NSString stringWithFormat:@"your score: %i", score];
}

- (void)leaderBoardButtonPressed:(id)sender
{
    [self.delegate showLeaderboard];
}

- (void)okButtonPressed:(id)sender
{
    if ([retryButton.titleLabel.text isEqual:@"retry"]) {
        scoreLabel.text = @"0";
        score = 0;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
    viewCounter.transform = CGAffineTransformRotate(transform, 0);
    
    viewCounter.alpha = 0;
    [superview addSubview:viewCounter];
    [self.delegate stopGame];
    screenIsShown = false;
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
        viewCounter.transform = CGAffineTransformRotate(transform, 0);
        viewCounter.alpha = 1.0f;
        viewMenuScreen.center = CGPointMake(-viewMenuScreen.frame.size.width / 2 - 5, [Properties sharedProperties].uiScreenLayerY + viewMenuScreen.frame.size.height / 2);
        retryButton.center = CGPointMake(retryButton.center.x, [[UIScreen mainScreen] bounds].size.height + retryButton.frame.size.height);
        shareButton.center = CGPointMake([Properties sharedProperties].globalGameWidth + shareButton.frame.size.width / 2 + 10, [Properties sharedProperties].uiScreenLayerY + [Properties sharedProperties].uiScreenLayerHeight - 80);
        soundButton.center = CGPointMake([Properties sharedProperties].globalGameWidth - soundButton.frame.size.width / 2 + 20, - soundButton.frame.size.height / 2 - 15);
        leaderBoardButton.center = CGPointMake(-leaderBoardButton.frame.size.width / 2, [Properties sharedProperties].globalGameHeight + leaderBoardButton.frame.size.height / 2);
        //modeButton.center = CGPointMake(- modeButton.frame.size.width / 2 - 20, - modeButton.frame.size.height / 2 - 15);

        //counterLabel.hidden = true;
    }
    completion:^(BOOL finished)
    {
        [self stopAnimateMenu];

         if(!isCounting) {
             isCounting = true;
             
             [counterLabel setText:[NSString stringWithFormat:@"%i", countdown]];
             
             menuTimer = [NSTimer scheduledTimerWithTimeInterval:0.66f
                                                          target:self
                                                        selector:@selector(countdownToRestart)
                                                        userInfo:nil
                                                         repeats:YES];
         }
         else if(!isCounting) {
             [self.delegate stopGame];
         }
    }];
}

- (void)countdownToRestart
{
    [counterLabel setText:[NSString stringWithFormat:@"%i", --countdown]];
    
    if (countdown == 2) {
        [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewCounter.transform = CGAffineTransformMakeScale(0.66, 0.66);
        }
        completion:^(BOOL finished) {}];
    }
    else if (countdown == 1) {
        [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewCounter.transform = CGAffineTransformMakeScale(0.33, 0.33);
        }
        completion:^(BOOL finished) {}];
    }
    else if(countdown < 1) {
        [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewCounter.transform = CGAffineTransformMakeScale(0, 0);
            pauseButton.center = CGPointMake([Properties sharedProperties].globalGameWidth - pauseButton.frame.size.width / 2 + 15, + pauseButton.frame.size.height / 2 - 15);
        }
        completion:^(BOOL finished) {
            [viewCounter removeFromSuperview];
            [menuTimer invalidate];
            [self.delegate continueGame];
            menuTimer = nil;
            countdown = 3;
            counterLabel.text = @"3";
            isCounting = false;
            screenIsShown = false;
        }];
    }
}

- (void)countdownToRestartManual
{
    if(isCounting) {
        [menuTimer invalidate];
        menuTimer = nil;
        
        [counterLabel setText:[NSString stringWithFormat:@"%i", --countdown]];
        
        menuTimer = [NSTimer scheduledTimerWithTimeInterval:0.66f
                                                     target:self
                                                   selector:@selector(countdownToRestart)
                                                   userInfo:nil
                                                    repeats:YES];
        
        if (countdown == 2) {
            viewCounter.transform = CGAffineTransformMakeScale(0.66, 0.66);
        }
        else if (countdown == 1) {
            viewCounter.transform = CGAffineTransformMakeScale(0.33, 0.33);
        }
        else if(countdown < 1) {
            [UIView animateWithDuration:0.33f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                pauseButton.center = CGPointMake([Properties sharedProperties].globalGameWidth - pauseButton.frame.size.width / 2 + 15, + pauseButton.frame.size.height / 2 - 15);
            } completion:^(BOOL finished) {}];

            viewCounter.transform = CGAffineTransformMakeScale(0, 0);
            [viewCounter removeFromSuperview];
            [self.delegate continueGame];
            countdown = 3;
            counterLabel.text = @"3";
            isCounting = false;
            screenIsShown = false;
            [menuTimer invalidate];
            menuTimer = nil;
        }
    }
}

- (void)pauseButtonPressed:(id)sender
{
    if(!isCounting && !screenIsShown)
        [self pauseGame];
}

- (void)modeButtonPressed:(id)sender
{
    [self setMode];
}

- (void)setupMode
{
    if ([Properties sharedProperties].globalGameMode) {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            [modeButton setTitle:@"hard" forState:UIControlStateNormal];
            modeButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:0/255.0f blue:80/255.0f alpha:1];
            menuNameLabel.text = [NSString stringWithFormat:@"[ hard mode ]"];
        }
        completion:^(BOOL finished){}];
    }
    else {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [modeButton setTitle:@"easy" forState:UIControlStateNormal];
            modeButton.backgroundColor = [UIColor colorWithRed:20/255.0f green:180/255.0f blue:0/255.0f alpha:1];
            menuNameLabel.text = [NSString stringWithFormat:@"[ easy mode ]"];
        }
        completion:^(BOOL finished){}];
    }
}

- (void)setMode
{
    if ([Properties sharedProperties].globalGameMode) {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            [modeButton setTitle:@"easy" forState:UIControlStateNormal];
            modeButton.backgroundColor = [UIColor colorWithRed:20/255.0f green:180/255.0f blue:0/255.0f alpha:1];
            menuNameLabel.text = [NSString stringWithFormat:@"[ easy mode ]"];
        }
    completion:^(BOOL finished){}];
    }
    else {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            [modeButton setTitle:@"hard" forState:UIControlStateNormal];
            modeButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:0/255.0f blue:80/255.0f alpha:1];
            menuNameLabel.text = [NSString stringWithFormat:@"[ hard mode ]"];
        }
    completion:^(BOOL finished){}];
    }
    
    [self.delegate modeChanged];
    [self updateGameOverScreenValues];
    
    if ([Properties sharedProperties].globalGameMode) {
        yourScoreLabel.text = [NSString stringWithFormat:@"(O_O)"];
    }
    else {
        yourScoreLabel.text = [NSString stringWithFormat:@"(^_^)"];
    }
    score = 0;
    
    if ([Properties sharedProperties].globalGameMode) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", 1] forKey:@"mode"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", 0] forKey:@"mode"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)soundButtonPressed:(id)sender
{
    [Properties sharedProperties].globalSoundOn = ![Properties sharedProperties].globalSoundOn;
    
    if([Properties sharedProperties].globalSoundOn) {
        [soundButton setTitle: @"sound on" forState: UIControlStateNormal];
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", 1] forKey:@"sound"];
    }
    else {
        [soundButton setTitle: @"sound off" forState: UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", 0] forKey:@"sound"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSound:(BOOL)soundOn
{
    [Properties sharedProperties].globalSoundOn = soundOn;
    
    if([Properties sharedProperties].globalSoundOn)
        [soundButton setTitle: @"sound on" forState: UIControlStateNormal];
    else
        [soundButton setTitle: @"sound off" forState: UIControlStateNormal];
}

- (void)setupSound
{
    NSString *sound = [[NSUserDefaults standardUserDefaults] stringForKey:@"sound"];
    
    if(sound) {
        if([sound integerValue] == 0) {
            [self setSound:NO];
        }
        else {
            [self setSound:YES];
        }
    }
}

- (void)shareButtonPressed:(id)sender
{
    NSString *oldNameLabelValue = menuNameLabel.text;
    NSString *oldBestScoreLabelValue = bestScoreLabel.text;
    NSString *oldYourScoreLabelValue = yourScoreLabel.text;
    NSString *oldRetryLabelValue = retryButton.titleLabel.text;
    NSString *oldShareLabelValue = shareButton.titleLabel.text;
    NSString *oldLeaderboardLabelValue = leaderBoardButton.titleLabel.text;
    
    //shareButton.hidden = true;
    //retryButton.hidden = true;
    soundButton.hidden = true;
    scoreLabel.hidden = true;
    viewCenter.hidden = true;
    
    // change some things
    menuNameLabel.text = @"[ awesome! ]";
    bestScoreLabel.text = @"my score:";
    if(score != 0)
        yourScoreLabel.text = [NSString stringWithFormat:@"%i", score];
    else
        yourScoreLabel.text = [NSString stringWithFormat:@"%i", bestScore];
    
    BOOL hideModeButton = false;
    
    if(!modeButton.superview) {
        hideModeButton = true;
        [viewMenuScreen insertSubview:modeButton belowSubview:bannerView];
    }
    
    [retryButton setTitle:[NSString stringWithFormat:@"me"] forState: UIControlStateNormal];
    [retryButton setNeedsLayout];
    [shareButton setTitle:[NSString stringWithFormat:@";D"] forState: UIControlStateNormal];
    [shareButton setNeedsLayout];
    [leaderBoardButton setTitle:[NSString stringWithFormat:@"beat"] forState: UIControlStateNormal];
    [leaderBoardButton setNeedsLayout];
    
    CGSize contextSize = CGSizeMake(superview.frame.size.width, [Properties sharedProperties].globalGameHeight);
    UIGraphicsBeginImageContext(contextSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [superview.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *string;
    
    if(score != 0)
        string = [NSString stringWithFormat:@"look, I`ve made incredible %i points @bOOnGame!", score];
    else
        string = [NSString stringWithFormat:@"look, I`ve made incredible %i points @bOOnGame!", bestScore];
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/boon-game/id893392880?l=de&ls=1&mt=8"];
    
    NSArray *dataToShare = @[string, url, image];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypePrint, @"com.apple.UIKit.activity.AddToReadingList"];

    activityViewController.excludedActivityTypes = excludeActivities;
    
    [superViewController presentViewController:activityViewController animated:true completion:nil];
    
    [retryButton setTitle:oldRetryLabelValue forState: UIControlStateNormal];
    [shareButton setTitle:oldShareLabelValue forState: UIControlStateNormal];
    [leaderBoardButton setTitle:oldLeaderboardLabelValue forState: UIControlStateNormal];
    
    //shareButton.hidden = false;
    //retryButton.hidden = false;
    soundButton.hidden = false;
    scoreLabel.hidden = false;
    viewCenter.hidden = false;
    menuNameLabel.text = oldNameLabelValue;
    bestScoreLabel.text = oldBestScoreLabelValue;
    yourScoreLabel.text = oldYourScoreLabelValue;
    
    if(hideModeButton) {
        [modeButton removeFromSuperview];
    }
}

- (void)pauseGame
{
    if(!screenIsShown) {
        [menuTimer invalidate];
        menuTimer = nil;
        [viewCounter removeFromSuperview];
        countdown = 3;
        counterLabel.text = @"3";
        isCounting = false;
        [retryButton setTitle:[NSString stringWithFormat:@"start"] forState: UIControlStateNormal];
        [self showMenuScreenWithText:[NSString stringWithFormat:@"[ pause ]"]];
        [self.delegate stopGame];
    }
    else {
        [self stopAnimateMenu];
    }
}

- (void)reset
{
    [self hideGameOverScreen];
}

- (void)addToScore:(int)add
{
    score += add;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
}

- (void)addToScore:(int)add forView:(UIView*)view
{
    score += add;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    
    UILabel *scoreAddLabel  = [UILabel new];
    scoreAddLabel.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    scoreAddLabel.textAlignment = NSTextAlignmentCenter;
    scoreAddLabel.backgroundColor = [UIColor clearColor];
    scoreAddLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40.0f];
    scoreAddLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7f];
    scoreAddLabel.text = [NSString stringWithFormat:@"+%i", add];
    [view addSubview:scoreAddLabel];
}

- (void)startAnimateMenu
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        if (animateLeft) {
            viewMenuScreen.transform = CGAffineTransformMakeRotation(-rotation + rotationMenu);
            retryButton.transform = CGAffineTransformMakeRotation(-rotation * 2 + rotationRetry);
            shareButton.transform = CGAffineTransformMakeRotation(rotation * 2 + rotationShare);
            soundButton.transform = CGAffineTransformMakeRotation(rotation * 2 + rotationSound);
            leaderBoardButton.transform = CGAffineTransformMakeRotation(rotation * 2 + rotationLeaderboard);
            //modeButton.transform = CGAffineTransformMakeRotation(-rotation * 2 + rotationMode);
        }
        else {
            viewMenuScreen.transform = CGAffineTransformMakeRotation(rotation  + rotationMenu);
            retryButton.transform = CGAffineTransformMakeRotation(rotation * 2 + rotationRetry);
            shareButton.transform = CGAffineTransformMakeRotation(-rotation * 2 + rotationShare);
            soundButton.transform = CGAffineTransformMakeRotation(-rotation * 2 + rotationSound);
            leaderBoardButton.transform = CGAffineTransformMakeRotation(-rotation * 2 + rotationLeaderboard);
            //modeButton.transform = CGAffineTransformMakeRotation(rotation * 2 + rotationMode);
        }
    }
    completion:^(BOOL finished)
    {
        if(finished == YES) {
            animateLeft = !animateLeft;
            [self startAnimateMenu];
        }
    }];
}

- (void)stopAnimateMenu
{
    [viewMenuScreen.layer removeAllAnimations];
    [retryButton.layer removeAllAnimations];
    [shareButton.layer removeAllAnimations];
    [soundButton.layer removeAllAnimations];
    [leaderBoardButton.layer removeAllAnimations];
    [modeButton.layer removeAllAnimations];
    
    animateLeft = false;
    
    viewMenuScreen.transform = CGAffineTransformMakeRotation(rotationMenu);
    retryButton.transform = CGAffineTransformMakeRotation(rotationRetry);
    shareButton.transform = CGAffineTransformMakeRotation(rotationShare);
    soundButton.transform = CGAffineTransformMakeRotation(rotationSound);
    leaderBoardButton.transform = CGAffineTransformMakeRotation(rotationLeaderboard);
    //modeButton.transform = CGAffineTransformMakeRotation(rotationMode);
}

@end
