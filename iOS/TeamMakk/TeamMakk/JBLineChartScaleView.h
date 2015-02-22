//
//  JBLineChartScaleView.h
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBLineChartScaleView : UIView
@property (nonatomic, strong) UIColor *scaleSeparatorColor; // footer separator (default = white)
@property (nonatomic, assign) NSInteger sectionCount; // # of notches (default = 2 on each edge)
@property (nonatomic, readonly) UILabel *zeroLabel;
@property (nonatomic, readonly) NSMutableArray *labels;
@property (nonatomic, readonly) UILabel *topLabel;

- (void)setMaxValue:(NSNumber *)max;
@end
