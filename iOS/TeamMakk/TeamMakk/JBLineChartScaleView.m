//
//  JBLineChartScaleView.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "JBLineChartScaleView.h"
CGFloat const kJBLineChartScaleViewSeparatorWidth = 0.5f;


@interface JBLineChartScaleView () {
  int _numSections;
  NSMutableArray *labels;
}
@property (nonatomic, strong) UIView *topSeparatorView;
@end

@implementation JBLineChartScaleView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    _labels = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    
    _topSeparatorView = [[UIView alloc] init];
    _topSeparatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topSeparatorView];
    
    _numSections = 3;
    _zeroLabel = [[UILabel alloc] init];
    _zeroLabel.adjustsFontSizeToFitWidth = YES;
    _zeroLabel.font = [UIFont systemFontOfSize:9];
    _zeroLabel.textAlignment = NSTextAlignmentRight;
    _zeroLabel.textColor = [UIColor whiteColor];
    _zeroLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_zeroLabel];
    
    _topLabel = [[UILabel alloc] init];
    _topLabel.adjustsFontSizeToFitWidth = YES;
    _topLabel.font = [UIFont systemFontOfSize:9];
    _topLabel.textAlignment = NSTextAlignmentRight;
    _topLabel.textColor = [UIColor whiteColor];
    _topLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_topLabel];
    [self layoutSubviews];
  }
  return self;
}

- (void)layoutSubviews {
  [_topLabel sizeToFit];
  [_zeroLabel sizeToFit];
  CGRect topFrame = _topLabel.frame;
  topFrame.origin = CGPointMake(0, 0);
  _topLabel.frame = topFrame;
  _zeroLabel.frame = CGRectMake(self.frame.size.width - _zeroLabel.frame.size.width - 2, self.frame.size.height - _zeroLabel.frame.size.height/2, _zeroLabel.frame.size.width, _zeroLabel.frame.size.height);
}

- (void)setMaxValue:(NSNumber *)max
{
  labels = [[NSMutableArray alloc] init];
  int maxInt = max.intValue;
  if (maxInt < 6) {
    float interval = self.frame.size.height / (maxInt-1);
    for (int i = 1; i < maxInt; i++) {
      UILabel *numLabel = [[UILabel alloc] init];
      numLabel.adjustsFontSizeToFitWidth = YES;
      numLabel.font = [UIFont systemFontOfSize:9];
      numLabel.textAlignment = NSTextAlignmentRight;
      numLabel.textColor = [UIColor whiteColor];
      numLabel.backgroundColor = [UIColor clearColor];
      numLabel.text = [NSString stringWithFormat:@"%d", i];
      [numLabel sizeToFit];
      CGRect numFrame = numLabel.frame;
      numFrame.origin.x = self.frame.size.width - numFrame.size.width - 2;
      numFrame.origin.y = _zeroLabel.frame.origin.y - interval*i;
      numLabel.frame = numFrame;
      [self addSubview:numLabel];
    }
  } else if (maxInt < 21) {
    float interval = self.frame.size.height / (maxInt);
    for (int i = 4; i < maxInt+3; i=i+4) {
      UILabel *numLabel = [[UILabel alloc] init];
      numLabel.adjustsFontSizeToFitWidth = YES;
      numLabel.font = [UIFont systemFontOfSize:9];
      numLabel.textAlignment = NSTextAlignmentRight;
      numLabel.textColor = [UIColor whiteColor];
      numLabel.backgroundColor = [UIColor clearColor];
      numLabel.text = [NSString stringWithFormat:@"%d", i];
      [numLabel sizeToFit];
      CGRect numFrame = numLabel.frame;
      numFrame.origin.x = self.frame.size.width - numFrame.size.width - 2;
      numFrame.origin.y = _zeroLabel.frame.origin.y - interval*i;
      numLabel.frame = numFrame;
      [self addSubview:numLabel];
    }
  } else {
    float interval = self.frame.size.height / (maxInt);
    for (int i = 10; i < maxInt+8; i=i+10) {
      UILabel *numLabel = [[UILabel alloc] init];
      numLabel.adjustsFontSizeToFitWidth = YES;
      numLabel.font = [UIFont systemFontOfSize:9];
      numLabel.textAlignment = NSTextAlignmentRight;
      numLabel.textColor = [UIColor whiteColor];
      numLabel.backgroundColor = [UIColor clearColor];
      numLabel.text = [NSString stringWithFormat:@"%d", i];
      [numLabel sizeToFit];
      CGRect numFrame = numLabel.frame;
      numFrame.origin.x = self.frame.size.width - numFrame.size.width - 2;
      numFrame.origin.y = _zeroLabel.frame.origin.y - interval*i;
      numLabel.frame = numFrame;
      if (CGRectGetMinY(numLabel.frame) >= self.frame.origin.y) {
        [self addSubview:numLabel];
      }
    }
  }
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextSetLineWidth(context, 0.5);
  CGContextSetShouldAntialias(context, YES);
  
  for (int i=0; i<_numSections; i++)
  {
    CGContextSaveGState(context);
    {
      CGContextMoveToPoint(context, self.frame.size.width - (kJBLineChartScaleViewSeparatorWidth * 0.5), 0);
      CGContextAddLineToPoint(context, self.frame.size.width -  (kJBLineChartScaleViewSeparatorWidth * 0.5), self.frame.size.height);
      CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
  }
}

@end
