//
//  Background.h
//  Mumpiz
//
//  Created by Stefan Gregor on 30.04.14.
//  Copyright (c) 2014 Stefan Gregor All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Background : NSObject

- (instancetype)initWithSuperview:(UIView*)superviewParam withColorSet:(NSArray*)colorSetParam;

- (void)moveAreas;
- (void)removeOffscreenAreasAndCreateNewOnes;
- (void)changeColorSet:(NSArray*)colorSetParam;

@end
