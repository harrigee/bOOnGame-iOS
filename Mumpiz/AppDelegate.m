//
//  AppDelegate.m
//  Mumpiz
//
//  Created by Stefan Gregor on 19.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <GameKit/GameKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!"
                                                    message:@"bOOn has been developed by a single developer and his creative and awesome girlfriend. There is no commercial background, so we are asking you to please tell your friends about bOOn and rate us on the App Store :)"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"I want to rate!", @"I promise to tell my friends", @"I just want to play... ಠ_ಠ" , nil];
    
    if(![[[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"] isEqualToString:@"1"]) {
        [alert show];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    ViewController* mainController = (ViewController*) self.window.rootViewController;
    [mainController pauseGame];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ViewController* mainController = (ViewController*) self.window.rootViewController;
    [mainController pauseGame];
    
    NSLog(@"now background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"now foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    ViewController* mainController = (ViewController*) self.window.rootViewController;
    [mainController pauseGame];
    [mainController startMenuAnimation];

    NSLog(@"now active");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSLog(@"friends");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else  if (buttonIndex == 0) {
        NSLog(@"rate");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self goToRating];
    }
    else  if (buttonIndex == 2) {
        NSLog(@"play");
    }
}

- (void)goToRating
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=893392880&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"now terminated");
}

@end
