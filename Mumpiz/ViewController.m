//
//  ViewController.m
//  Mumpiz
//
//  Created by Stefan Gregor on 19.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "ViewController.h"
#import "Gravity.h"
#import "Player.h"
#import "World.h"
#import "CollisionDetector.h"
#import "UI.h"
#import "Properties.h"

@interface ViewController ()

@property GameLogic *gameLogic;
@property GKLocalPlayer *localPlayer;
@property AchievementsViewController *achievementsViewController;
@property Player *player;
@property UI *ui;
@property World *world;
@property Gravity *gravity;
@property GKLeaderboard *boardHard;
@property GKLeaderboard *boardEasy;


@end

@implementation ViewController

@synthesize gameLogic, adBannerView, localPlayer, boardHard, boardEasy, achievementsViewController, player, ui, world, gravity;

# pragma mark setup game mechanics

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // initialize mode
    [Properties sharedProperties].globalGameMode = true;
    [[Properties sharedProperties] setup];
    
    // iAd
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adBannerView.center = CGPointMake([Properties sharedProperties].globalGameWidth / 2, [[UIScreen mainScreen] bounds].size.height - adBannerView.frame.size.height / 2);
    adBannerView.hidden = true;
    [self.view addSubview:adBannerView];
    
    // GameCenter
    [self showGameCenter];
    
    // Achievements
    achievementsViewController = [AchievementsViewController new];
    
    // create new player
    player = [[Player alloc] initAtCGPoint:CGPointMake(50 * [Properties sharedProperties].globalWidthRatio, [Properties sharedProperties].globalScreenHeight / 2) intoView:self.view];
    
    // create new world
    world = [[World alloc] initWithSuperview:self.view];
    
    // sets the gravity
    gravity = [Gravity new];
    
    // create the UI
    ui = [[UI alloc] initWithSuperview:self.view andSuperViewController:self];
    
    // create game logic
    gameLogic = [[GameLogic alloc] initWithPlayer:player andWorld:world andGravity:gravity andUI:ui andBannerView:adBannerView andSuperViewController:self];
    gameLogic.delegate = self;
    
    // starts the loop
    [self startUpdate];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // start in menu
    [ui showMenuScreen];
}

- (World*)getWorld {
    return self.world;
}

# pragma mark GameCenter

- (void)showGameCenter
{
    localPlayer = [GKLocalPlayer localPlayer];
    __weak typeof(self) weakSelf = self;
    __weak typeof(UI*) weakUI = ui;
    
    localPlayer.authenticateHandler = ^(UIViewController *loginVC, NSError *error)
    {
        if([GKLocalPlayer localPlayer].isAuthenticated)
        {
            NSLog(@"GameCenter authenticated!");
            [weakSelf loadLeaderboardInfo];
            [weakSelf loadAchievements];
        }
        else if(loginVC)
        {
            [weakUI pauseGame];
            [weakSelf presentViewController:loginVC animated:YES completion:^ {
                NSLog(@"GameCenter login shown");
            }];
        }
        else if(error != nil)
        {
            NSLog(@"GameCenter ERROR: %@",error);
        }
        else {
            NSLog(@"GameCenter ERROR: nothing happened");
        }
    };
}

- (void)loadLeaderboardInfo
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboardsParam, NSError *error) {
        
        if ([((GKLeaderboard*)[leaderboardsParam objectAtIndex:0]).identifier isEqualToString:@"bOOnLeaderboard1"]) {
            boardHard = (GKLeaderboard*)[leaderboardsParam objectAtIndex:0];
        }
        if ([((GKLeaderboard*)[leaderboardsParam objectAtIndex:1]).identifier isEqualToString:@"bOOnLeaderboard2"]) {
            boardEasy = (GKLeaderboard*)[leaderboardsParam objectAtIndex:1];
        }
        
        // Load Scores
        GKLeaderboard *leaderboardRequest1 = [[GKLeaderboard alloc] init];
        leaderboardRequest1.identifier = boardHard.category;
        [leaderboardRequest1 loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if (error) {
                NSLog(@"Error getting Score: %@", error);
            } else if (scores) {
                GKScore *localPlayerScore = leaderboardRequest1.localPlayerScore;
                NSLog(@"Local player's score hard: %lld", localPlayerScore.value);
                [self saveBestScoreHard:(int)localPlayerScore.value];
                [ui updateGameOverScreenValues];
            }
        }];
        
        GKLeaderboard *leaderboardRequest2 = [[GKLeaderboard alloc] init];
        leaderboardRequest2.identifier = boardEasy.category;
        [leaderboardRequest2 loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if (error) {
                NSLog(@"Error getting Score: %@", error);
            } else if (scores) {
                GKScore *localPlayerScore = leaderboardRequest2.localPlayerScore;
                NSLog(@"Local player's score easy: %lld", localPlayerScore.value);
                [self saveBestScoreEasy:(int)localPlayerScore.value];
                [ui updateGameOverScreenValues];
            }
        }];
    }];
}

- (void)reportScore:(int64_t)score
{
    BOOL mode = [Properties sharedProperties].globalGameMode;
    
    if (mode) {
        if(boardHard) {
            GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: boardHard.category];
            scoreReporter.value = score;
            scoreReporter.context = 0;
            
            NSArray *scores = @[scoreReporter];
            
            [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
                if(error)
                    NSLog(@"error: %@", error);
                else {
                    NSLog(@"score submitted: %lld", score);
                }
            }];
        }
    }
    else {
        if(boardEasy) {
            GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: boardEasy.category];
            scoreReporter.value = score;
            scoreReporter.context = 0;
            
            NSArray *scores = @[scoreReporter];
            
            [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
                if(error)
                    NSLog(@"error: %@", error);
                else {
                    NSLog(@"score submitted: %lld", score);
                }
            }];
        }
    }
}

- (void)showLeaderboard
{
    /*BOOL mode = [Properties sharedProperties].globalGameMode;
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        if (mode)
            leaderboardController.category = boardHard.category;
        else
            leaderboardController.category = boardEasy.category;

        leaderboardController.leaderboardDelegate = self;
        [self presentViewController:leaderboardController animated:YES completion:^ {
            NSLog(@"Leaderboard shown");
        }];
    }*/
    
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc]init];
    if(gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gameCenterController animated:true completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:true completion:nil];
}

- (void)loadAchievements
{
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *achievements, NSError *error){
        if(error != nil) {
            
        }
        if(achievements != nil) {
            NSLog(@"achievements: %@", achievements);
        }
    }];
}

#pragma mark save best score

- (void)saveBestScoreEasy:(int)bestScore
{
    NSString *savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreEasy"];
    
    if(savedScore) {
        if([savedScore integerValue] < bestScore) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", bestScore] forKey:@"bestScoreEasy"];
        }
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", bestScore] forKey:@"bestScoreEasy"];
    }
}

- (void)saveBestScoreHard:(int)bestScore
{
    NSString *savedScore = [[NSUserDefaults standardUserDefaults] stringForKey:@"bestScoreHard"];
    
    if(savedScore) {
        if([savedScore integerValue] < bestScore) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", bestScore] forKey:@"bestScoreHard"];
        }
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", bestScore] forKey:@"bestScoreHard"];
    }
}

# pragma mark update mechanics

// implements the gamelogic aka gameloop
- (void)update
{
    [gameLogic update];
    
    [self.view bringSubviewToFront:adBannerView];
}

# pragma touch controlling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView: self.view];
    
    if(touchLocation.y <= [[UIScreen mainScreen] bounds].size.height - adBannerView.frame.size.height / 2)
        [gameLogic touchesBegan];
}

# pragma mark start timer

// starts the gameloop
- (void)startUpdate
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

# pragma mark startMenuAnimation

- (void)startMenuAnimation
{
    [self.view bringSubviewToFront:adBannerView];
    [ui stopAnimateMenu];
    [ui startAnimateMenu];
}

# pragma mark pauseGame

- (void)pauseGame
{
    if(![gameLogic dead])
        [ui pauseGame];
}

# pragma mark system stuff

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark Achievements Delegate

- (void)reportAchievement:(AchievementType)type
{
    [achievementsViewController showAchievement:type];
}


@end
