//
//  CounterView.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "CounterView.h"

@interface CounterView () {
  int _current;
  int _goal;
  CGRect _originalFrame;
  CALayer *_fillLayer;
  UIView *_fillView;
  UILabel *_activateLayer;
}
@property (nonatomic, strong) UILabel *exerciseLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *goalLabel;
@property (nonatomic, strong) NSString *exerciseString;
@property (nonatomic, strong) NSString *goalString;
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
  _current = 0;
  _goal = 30;
//  _fillLayer = [[CALayer alloc] init];
//  _fillLayer.frame = self.frame;
//  _fillLayer.backgroundColor = (__bridge CGColorRef)([UIColor blueColor]);
//  [self.layer addSublayer:_fillLayer];
  float progress = (float)_current/_goal;
  CGPoint startFill = CGPointMake(0, self.frame.size.height - progress*self.frame.size.height);
  CGRect frameFill = CGRectMake(startFill.x, startFill.y, self.frame.size.width, progress*self.frame.size.height);
  
  _fillView = [[UIView alloc] initWithFrame:frameFill];
  _fillView.backgroundColor = [UIColor yellowColor];

//  _fillView.frame = frameFill;
//  [self updateFill];
  
  // set the radius
//  CGFloat radius = 32.0;
  // set the mask frame, and increase the height by the
  // corner radius to hide bottom corners
//  CGRect maskFrame = frameFill;
//  maskFrame.size.height -= radius;
  // create the mask layer
//  CALayer *maskLayer = [CALayer layer];
//  maskLayer.cornerRadius = radius;
//  maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//  maskLayer.frame = maskFrame;
  
  // set the mask
//  _fillView.layer.mask = maskLayer;
//
//  // Add a backaground color just to check if it works
//  self.view.backgroundColor = [UIColor redColor];
//  // Add a test view to verify the correct mask clipping
//  UIView *testView = [[UIView alloc] initWithFrame:CGRectMake( 0.0, 0.0, 50.0, 50.0 )];
//  testView.backgroundColor = [UIColor blueColor];
//
  
  [self addSubview:_fillView];
  
  self.goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
  self.goalLabel.text = @"/--";
  self.goalLabel.font = [UIFont systemFontOfSize:70];
  [self.goalLabel sizeToFit];
  CGRect goalFrame = self.goalLabel.frame;
  goalFrame.origin.x = self.frame.size.width - goalFrame.size.width - 20;
  goalFrame.origin.y = self.frame.size.height - goalFrame.size.height - 30;
  self.goalLabel.frame = goalFrame;
  [self addSubview:self.goalLabel];
  
  self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
  self.countLabel.text = @"0";
  self.countLabel.font = [UIFont systemFontOfSize:190];
  [self.countLabel sizeToFit];
  CGRect frame = self.countLabel.frame;
  frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width - 10, self.goalLabel.frame.size.height);
  self.countLabel.frame = frame;
  _originalFrame = frame;
  [self addSubview:self.countLabel];
  
  self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
  self.exerciseLabel.text = self.exerciseString;
  self.exerciseLabel.font = [UIFont systemFontOfSize:40];
  [self.exerciseLabel sizeToFit];
  CGRect exerciseFrame = self.exerciseLabel.frame;
  exerciseFrame.origin.x = (self.frame.size.width - self.exerciseLabel.frame.size.width)/2;
  exerciseFrame.origin.y = self.countLabel.frame.origin.y - self.exerciseLabel.frame.size.height;
  self.exerciseLabel.frame = exerciseFrame;
  self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
  self.layer.cornerRadius = 32.0f;
  [self addSubview:self.exerciseLabel];
  
  _activateLayer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 20, self.frame.size.width, 30)];
  _activateLayer.text = @"Activate";
  _activateLayer.font = [UIFont systemFontOfSize:40];
  [_activateLayer sizeToFit];
  CGRect activateFrame = _activateLayer.frame;
  activateFrame.origin.x = (self.frame.size.width - _activateLayer.frame.size.width)/2;
  //activateFrame.origin.y =  _activateLayer.frame.size.height ;
  _activateLayer.frame = activateFrame;
  self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
  self.layer.cornerRadius = 32.0f;
  [self addSubview:_activateLayer];
  
  self.countLabel.alpha = 0.0;
  self.exerciseLabel.alpha = 0.0;
  self.goalLabel.alpha = 0.0;
}

-(void) userHasStarted
{
  self.countLabel.alpha = 1.0;
  self.exerciseLabel.alpha = 1.0;
  self.goalLabel.alpha = 1.0;
  _activateLayer.alpha = 0.0;
  self.backgroundColor = [UIColor redColor];
}

-(void) userHasFinished
{
  self.countLabel.alpha = 0.0;
  self.exerciseLabel.alpha = 0.0;
  self.goalLabel.alpha = 0.0;
  _activateLayer.alpha = 1.0;
  self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
}

- (void)increaseCount
{
  _current++;
  self.countLabel.alpha = 0;
  
  [UIView animateWithDuration:0.5 animations:^{
    self.countLabel.text = [NSString stringWithFormat:@"%d", _current];
    if (_current < 10) {
      self.countLabel.font = [UIFont systemFontOfSize:210];
      [self.countLabel sizeToFit];
      CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width - 6, _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;
    } else if (_current < 100) {
      self.countLabel.font = [UIFont systemFontOfSize:190];
      [self.countLabel sizeToFit];
      CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width,  _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;
    } else {
      self.countLabel.font = [UIFont systemFontOfSize:140];
      [self.countLabel sizeToFit];
      CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width + 4, _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;
    }
    [self updateFill];
  }];

}

-(void) setTitle:(NSString *)newTitle
{
  self.exerciseLabel.text = newTitle;
  [self.exerciseLabel sizeToFit];
  CGRect positionFrame = self.exerciseLabel.frame;
  positionFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - positionFrame.size.width)/2;
  self.exerciseLabel.frame = positionFrame;
}

-(void) setGoal:(int) newGoal
{
  if (newGoal == 0)
  {
    self.goalLabel.text = [NSString stringWithFormat:@"--"];
  } else {
    self.goalLabel.text = [NSString stringWithFormat:@"/%i", newGoal];
  }
}

- (void)updateFill {
  float progress = (float)_current/_goal;
  CGFloat radius = 32.0;
  CGPoint startFill = CGPointMake(0, self.frame.size.height - progress*self.frame.size.height);
  CGRect frame = CGRectMake(startFill.x, startFill.y, self.frame.size.width, progress*self.frame.size.height);
  _fillView.frame = frame;
  
  // set the radius
  
  // set the mask frame, and increase the height by the
  // corner radius to hide bottom corners
//  CGRect maskFrame = self.bounds;// CGRectMake(0, frame.origin.y, 100, 100);

  // create the mask layer
//  CALayer *maskLayer = [CALayer layer];
//  maskLayer.cornerRadius = radius;
//  maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//  maskLayer.frame = maskFrame;
  
  // set the mask
//  _fillView.layer.mask = maskLayer;
  
  
//  [_fillLayer removeFromSuperlayer];
//    float progress = (float)_current/_goal;
//    CGPoint startFill = CGPointMake(0, self.frame.size.height - progress*self.frame.size.height);
//  CGRect frame = CGRectMake(startFill.x, startFill.y, self.frame.size.width, progress*self.frame.size.height);
//  _fillLayer.frame = frame;
//  _fillLayer.backgroundColor = (__bridge CGColorRef)([UIColor cyanColor]);
//  [self.layer addSublayer:_fillLayer];
  
//  [self setNeedsLayout];
  //  CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
  ////  CGPoint start = [pointVal CGPointValue];
  //  CGContextFillRect(context, CGRectMake(start.x, start.y, self.frame.size.width, progress*self.frame.size.height));
  //}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  NSLog(@"DRAWING");
//  
////  CGContextClearRect(context, rect);
//  float progress = _current/_goal;
//  CGPoint start = CGPointMake(0, self.frame.size.height - progress*self.frame.size.height);
//  
//  CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
////  CGPoint start = [pointVal CGPointValue];
//  CGContextFillRect(context, CGRectMake(start.x, start.y, self.frame.size.width, progress*self.frame.size.height));
//}


@end
