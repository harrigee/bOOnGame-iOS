//
//  World.h
//  Mumpiz
//
//  Created by Stefan Gregor on 23.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorldDelegate

- (void)newAreasCreated;

@end

@interface World : NSObject

- (instancetype)initWithSuperview:(UIView*)superview;

- (void)reset;
- (void)move;
- (void)moveBackgroundWithoutWorld;
- (void)removeArea:(UIView*)area;

- (NSMutableArray*)getAreas;
- (NSMutableArray*)getColors;
- (int)getHowManyAreasLeft;

- (void)fadeOutElement:(UIView*)element withCompletionHandler:(void (^) (void))handler;
- (void)fadeOutElement:(UIView*)element;

@property (nonatomic, assign) id<WorldDelegate>delegate;

@end
