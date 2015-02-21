//
//  GoalsTableViewCell.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "GoalsTableViewCell.h"

#import "YLProgressBar.h"

@implementation GoalsTableViewCell
{
  NSString * exerciseString;
  UILabel * _exerciseLabel;
  YLProgressBar *progressBar;
  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           exercise:(NSString *)exercise
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    exerciseString = exercise;
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    progressBar = [[YLProgressBar alloc] initWithFrame:CGRectMake(0, 20, bounds.size.width, 40)];
    
    NSArray *tintColors = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                            [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                            [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                            [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                            [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                            [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                            [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                            [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                            [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];
    
    progressBar.progressTintColors       = tintColors;
    progressBar.stripesOrientation       = YLProgressBarStripesOrientationLeft;
    progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    progressBar.indicatorTextLabel.font  = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    
    [progressBar setProgress:0.5 animated:YES];
    //progressBar.frame = CGRectMake(0, 0, 100, 100);
    [self addSubview:progressBar];
    
    
    _exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _exerciseLabel.text = exerciseString;
    [_exerciseLabel sizeToFit];
    [self addSubview:_exerciseLabel];
  }
  return self;
}

- (void)layoutCellComponents
{
 
}

@end
