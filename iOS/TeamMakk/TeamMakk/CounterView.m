//
//  CounterView.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "CounterView.h"

@interface CounterView ()
@property (nonatomic, strong) UILabel *exerciseLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *goalLabel;
@property (nonatomic, strong) NSString *exerciseString;
@property (nonatomic, strong) NSString *goalString;
@property (nonatomic, strong) NSNumber *count;

@end


@implementation CounterView
- (id)initWithFrame:(CGRect)frame
           exercise:(NSString *)exercise
{
  self = [super initWithFrame:frame];
  if (self) {
    self.exerciseString = exercise;
    [self setUpView];
  }
  return self;
}

- (void)setUpView {
  self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
  self.exerciseLabel.text = self.exerciseString;
  self.exerciseLabel.font = [UIFont systemFontOfSize:20];
  [self.exerciseLabel sizeToFit];
  self.exerciseLabel.frame = CGRectMake((self.frame.size.width - self.exerciseLabel.frame.size.width)/2, 16, self.exerciseLabel.frame.size.width, self.exerciseLabel.frame.size.height);
  self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
  self.layer.cornerRadius = 26.0f;
  [self addSubview:self.exerciseLabel];
  
  
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
