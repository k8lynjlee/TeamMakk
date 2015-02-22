//
//  ExerciseCell.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "ExerciseCell.h"
#import "JBLineChartFooterView.h"
#import "JBLineChartScaleView.h"
#import "DatabaseManager.h"

const float JBCellPadding = 20.0f;

typedef NS_ENUM(NSInteger, JBLineChartLine){
  JBLineChartLineSolid,
  JBLineChartLineDashed,
  JBLineChartLineCount
};

@interface ExerciseCell () {
  UIView *_separatorView;
  int exerciseNum;
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
    [self layoutCellComponents];
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           exercise:(NSString *)exercise
           exerciseNum:(int) exerciseN {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.exerciseString = exercise;
    exerciseNum =exerciseN;
//    [self layoutCellComponents];
  }
  return self;
}

- (void)layoutCellComponents
{
  _separatorView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, self.frame.size.height)];
  self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(JBCellPadding, 16, self.frame.size.width, JBCellPadding)];
  self.exerciseLabel.text = self.exerciseString;
  self.exerciseLabel.font = [UIFont systemFontOfSize:16];
  self.exerciseLabel.textColor = [UIColor whiteColor];
  [self.exerciseLabel sizeToFit];

  [_separatorView addSubview:self.exerciseLabel];

  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = _separatorView.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:1.0 green:.38 blue:.08 alpha:.5] CGColor], (id)[[UIColor colorWithRed:1.0 green:.07 blue:.03 alpha:.8] CGColor], nil];
  [_separatorView.layer insertSublayer:gradient atIndex:0];
  //A9E8E6
 // _separatorView.backgroundColor = [UIColor colorWithRed:(169/255.0) green:(232/255.0) blue:(230/255.0) alpha:.8];
//   _separatorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(20/255.0) blue:(20/255.0) alpha:.8];
  [_separatorView.layer setCornerRadius:8.0f];
  [_separatorView.layer setMasksToBounds:YES];
  
  CGRect frame = CGRectMake(JBCellPadding, (self.frame.size.height - 120 + JBCellPadding)/2 - CGRectGetMaxY(self.exerciseLabel.frame) + JBCellPadding, self.frame.size.width - JBCellPadding*2, (self.frame.size.height - CGRectGetMaxY(self.exerciseLabel.frame) - JBCellPadding*2));
  
  JBLineChartView *lineChartView = [[JBLineChartView alloc] initWithFrame:frame];
  lineChartView.dataSource = self;
  lineChartView.delegate = self;
//  lineChartView.backgroundColor = [UIColor whiteColor];
  
  float footerHeight = self.frame.size.height - CGRectGetMaxY(frame);
  
  JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(JBCellPadding, ceil(self.bounds.size.height * 0.5) - ceil(footerHeight * 0.5), self.bounds.size.width, footerHeight)];
  footerView.backgroundColor = [UIColor clearColor];
  
  unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSMutableArray *dayNumbers = [[NSMutableArray alloc] init];
  
  for (int i = 7; i >=0 ; i--) {
    NSTimeInterval secondsBefore = -60*60*24*i;
    NSDate *before = [[NSDate alloc] init];
    before = [NSDate dateWithTimeIntervalSinceNow:secondsBefore];
    NSDateComponents *dayComponents = [calendar components:units fromDate:before];
    NSInteger dayFound = [dayComponents day];
    [dayNumbers addObject:[NSNumber numberWithInteger:dayFound].stringValue];
  }
  [footerView addLabelTitles:dayNumbers];
  
  NSDate *now = [NSDate date]; //
  NSDateComponents *components = [calendar components:units fromDate:now];
  NSInteger today = [components day]; // day
  
  footerView.rightLabel.text = [NSNumber numberWithInteger:today].stringValue;
  footerView.rightLabel.textColor = [UIColor whiteColor];
  footerView.footerSeparatorColor = [UIColor whiteColor];
  footerView.sectionCount = 7;
  lineChartView.footerView = footerView;
  
  JBLineChartScaleView *scaleView = [[JBLineChartScaleView alloc] initWithFrame:CGRectMake(lineChartView.frame.origin.x - 14, lineChartView.frame.origin.y, 14, lineChartView.frame.size.height - 29)];
  scaleView.zeroLabel.text = @"0";
  [scaleView setMaxValue:[NSNumber numberWithFloat:[lineChartView maximumValue]]];
//  scaleView.topLabel.text = [NSString stringWithFormat:@"%i", (int)[lineChartView maximumValue]];

  [_separatorView addSubview:scaleView];
  
  [_separatorView addSubview:lineChartView];
  [lineChartView reloadData];
  
  [self addSubview:_separatorView];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView horizontalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
  return [UIColor whiteColor];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
  return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
  return 7; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  if (horizontalIndex == 6)
  {
    //Get the actual data from today from the database manager
    return [[DatabaseManager getSharedInstance] getCurrentActivityWithWorkoutIndex: exerciseNum];
  }
  return rand() % 22; // y-position (y-axis) of point at horizontalIndex (x-axis)
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
  return 2; // width of line in chart
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  return [UIColor whiteColor];//[UIColor colorWithRed:71/255.0 green:62/255.0 blue:63/255.0 alpha:1];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex {
  return [UIColor whiteColor];//[UIColor colorWithRed:71/255.0 green:62/255.0 blue:63/255.0 alpha:1];
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
  return JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
  return YES;
}


@end
