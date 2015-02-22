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
@property (nonatomic) NSInteger exerciseIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           exercise:(NSString *)exercise
           exerciseNum:(int) exerciseN;

- (void)layoutCellComponents;
@end
