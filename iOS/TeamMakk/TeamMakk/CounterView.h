//
//  CounterView.h
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterView : UIView
@property (nonatomic) BOOL isCounter;
- (id)initWithFrame:(CGRect)frame
           exercise:(NSString *)exercise;

- (void)increaseCount;

- (void) setTitle:(NSString *)newTitle;

- (void) setGoal:(int) newGoal;

- (void) startTimer;

@end
