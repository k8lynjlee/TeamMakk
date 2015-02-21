//
//  ExerciseCell.h
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBLineChartView.h"

@interface ExerciseCell : UITableViewCell <JBLineChartViewDataSource, JBLineChartViewDelegate>
@property (nonatomic, strong) UILabel *exerciseLabel;
@property (nonatomic, strong) NSString *exerciseString;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           exercise:(NSString *)exercise;
- (void)layoutCellComponents;
@end
