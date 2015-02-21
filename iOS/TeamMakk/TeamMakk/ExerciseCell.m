//
//  ExerciseCell.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "ExerciseCell.h"
//#import "JBLineChartView.h"

@interface ExerciseCell () {
  UIView *_separatorView;
}

@end

@implementation ExerciseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGRect frame = self.frame;
    [self layoutCellComponents];
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           exercise:(NSString *)exercise {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.exerciseString = exercise;
//    [self layoutCellComponents];
  }
  return self;
}

- (void)layoutCellComponents
{
  _separatorView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, self.frame.size.height)];
  self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, self.frame.size.width, 20)];
  self.exerciseLabel.text = self.exerciseString;
  self.exerciseLabel.font = [UIFont systemFontOfSize:16];
  [self.exerciseLabel sizeToFit];

  [_separatorView addSubview:self.exerciseLabel];

  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = _separatorView.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:.31 green:.49 blue:.74 alpha:.5] CGColor], (id)[[UIColor colorWithRed:.64 green:.74 blue:.98 alpha:.8] CGColor], nil];
  [_separatorView.layer insertSublayer:gradient atIndex:0];
  
  [_separatorView.layer setCornerRadius:8.0f];
  [_separatorView.layer setMasksToBounds:YES];
  
  CGRect frame = CGRectMake(20, 40, self.frame.size.width - 40, 100);
  JBLineChartView *lineChartView = [[JBLineChartView alloc] initWithFrame:frame];
  lineChartView.dataSource = self;
  lineChartView.delegate = self;
  
  [_separatorView addSubview:lineChartView];
  [lineChartView reloadData];
  
  [self addSubview:_separatorView];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
  return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
  return 5; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  return rand() % 5; // y-position (y-axis) of point at horizontalIndex (x-axis)
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
  return 2; // width of line in chart
}

@end
