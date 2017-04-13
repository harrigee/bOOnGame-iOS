//
//  UI.h
//  Mumpiz
//
//  Created by Stefan Gregor on 29.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@protocol UIDelegate

- (void)stopGame;
- (void)continueGame;
- (void)submitScore:(int)score;
- (void)showLeaderboard;
- (void)modeChanged;

@end

@interface UI : NSObject

- (instancetype)initWithSuperview:(UIView*)superviewParam andSuperViewController:(ViewController*)superViewControllerParam;

- (void)showGameOverScreen;
- (void)showMenuScreen;
- (void)hideGameOverScreen;
- (void)bringToFront;
- (void)startAnimateMenu;
- (void)addToScore:(int)add;
- (void)addToScore:(int)add forView:(UIView*)view;
- (void)reset;
- (void)pauseGame;
- (void)countdownToRestartManual;
- (void)updateGameOverScreenValues;

@property (nonatomic, assign) id<UIDelegate>delegate;
@property __block int score;

@end
