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
  NSTimer *_t;
  NSDate *_start;
  UILabel *_activateLayer;
  
  id<CounterViewDelegate> _delegate;
  
  UILabel *currentLabel;
  UILabel *_workoutTypeLabel;
  UILabel *goalLabel;
}
//@property (nonatomic, strong) UILabel *exerciseLabel;
//@property (nonatomic, strong) UILabel *countLabel;
//@property (nonatomic, strong) UILabel *goalLabel;
@property (nonatomic, strong) NSString *exerciseString;
@property (nonatomic, strong) NSString *goalString;
@end


@implementation CounterView
- (id)initWithFrame:(CGRect)frame
           exercise:(NSString *)exercise
           delegate:(id<CounterViewDelegate>) delegate
{
  self = [super initWithFrame:frame];
  if (self) {
    self.exerciseString = exercise;
    self.isCounter = YES;
    _delegate = delegate;
    [self setUpView];
    
    int elapsedSeconds;
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
  _fillView.backgroundColor = [UIColor blackColor];

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
  
  //[self addSubview:_fillView];
  
  /*self.goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
  self.goalLabel.text = @"/--";
  self.goalLabel.font = [UIFont systemFontOfSize:70];
  self.goalLabel.textColor = [UIColor whiteColor];
  [self.goalLabel sizeToFit];
  CGRect goalFrame = self.goalLabel.frame;
  goalFrame.origin.x = self.frame.size.width - goalFrame.size.width - 20;
  goalFrame.origin.y = self.frame.size.height - goalFrame.size.height - 30;
  self.goalLabel.frame = goalFrame;
  [self addSubview:self.goalLabel];*/
  
  /*self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
  self.countLabel.text = @"0";
  self.countLabel.font = [UIFont systemFontOfSize:190];
  self.countLabel.textColor = [UIColor whiteColor];
  [self.countLabel sizeToFit];
  CGRect frame = self.countLabel.frame;
  frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width - 10, self.goalLabel.frame.size.height);
  self.countLabel.frame = frame;
  _originalFrame = frame;
  [self addSubview:self.countLabel];*/
  
  /*self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
  self.exerciseLabel.text = self.exerciseString;
  self.exerciseLabel.font = [UIFont systemFontOfSize:40];
  self.exerciseLabel.textColor = [UIColor whiteColor];
  [self.exerciseLabel sizeToFit];
  CGRect exerciseFrame = self.exerciseLabel.frame;
  exerciseFrame.origin.x = (self.frame.size.width - self.exerciseLabel.frame.size.width)/2;
  exerciseFrame.origin.y = self.countLabel.frame.origin.y - self.exerciseLabel.frame.size.height;
  self.exerciseLabel.frame = exerciseFrame;*/
 // self.backgroundColor = [UIColor redColor];
//  self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
  //self.layer.cornerRadius = 32.0f;
  //[self addSubview:self.exerciseLabel];

  _activateLayer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 20, self.frame.size.width, 30)];
  _activateLayer.text = @"Activate";
  _activateLayer.font = [UIFont systemFontOfSize:40];
  [_activateLayer sizeToFit];
  CGRect activateFrame = _activateLayer.frame;
  activateFrame.origin.x = (self.frame.size.width - _activateLayer.frame.size.width)/2;
  //activateFrame.origin.y =  _activateLayer.frame.size.height ;
  _activateLayer.frame = activateFrame;
  
  UIView * firstCircle = [[UIView alloc] initWithFrame:CGRectMake(10, 185, 250, 250 )];
  //firstCircle.backgroundColor = [UIColor greenColor];
  firstCircle.layer.cornerRadius = 125;
  //
  //firstCircle.layer.borderWidth = 2.0;
  firstCircle.layer.borderColor = [UIColor orangeColor].CGColor;
  [self addSubview:firstCircle];
  
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = firstCircle.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:1.0 green:.38 blue:.08 alpha:.5] CGColor], (id)[[UIColor colorWithRed:1.0 green:.07 blue:.03 alpha:.8] CGColor], nil];
  [firstCircle.layer insertSublayer:gradient atIndex:0];
  //A9E8E6
  // _separatorView.backgroundColor = [UIColor colorWithRed:(169/255.0) green:(232/255.0) blue:(230/255.0) alpha:.8];
  //   _separatorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(20/255.0) blue:(20/255.0) alpha:.8];
  [firstCircle.layer setCornerRadius:125.0f];
  [firstCircle.layer setMasksToBounds:YES];
  
  UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActivatePressed)];
  [firstCircle addGestureRecognizer:tap];
  
  _workoutTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 400, 400)];
  _workoutTypeLabel.font = [UIFont systemFontOfSize:60];
  _workoutTypeLabel.text = @"";
  _workoutTypeLabel.textColor = [UIColor lightGrayColor];
  [_workoutTypeLabel sizeToFit];
  CGRect workoutFrame = _workoutTypeLabel.frame;
  workoutFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - workoutFrame.size.width) / 2;
  _workoutTypeLabel.frame = workoutFrame;
  
  [self addSubview:_workoutTypeLabel];
  
  currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 170, 100, 100)];
    currentLabel.font = [UIFont systemFontOfSize:60];
  currentLabel.text = @"Activate";
  currentLabel.textColor = [UIColor whiteColor];
  [currentLabel sizeToFit];
  CGRect currFrame = currentLabel.frame;
  currFrame.origin.x = (250 - currFrame.size.width ) / 2 + 10;
  currFrame.origin.y = (250 - currFrame.size.height) / 2 + 185;
  currentLabel.frame = currFrame;
  [self addSubview:currentLabel];
  
  UILabel *slash = [[UILabel alloc] initWithFrame:CGRectMake(225, 270, 100, 100)];
  slash.text = @"/";
  slash.font = [UIFont systemFontOfSize:100];
  //[self addSubview:slash];
  
  UIView * secondCircle = [[UIView alloc] initWithFrame:CGRectMake(240, 400, 120, 120 )];
  //secondCircle.backgroundColor = [UIColor greenColor];
  secondCircle.layer.cornerRadius = 60;
  secondCircle.layer.borderWidth = 10.0;
  secondCircle.layer.borderColor = [UIColor orangeColor].CGColor;
  [self addSubview:secondCircle];
  
  goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 310, 100, 100)];
  goalLabel.text = @"Goal";
  goalLabel.font = [UIFont systemFontOfSize:30];
  goalLabel.textColor = [UIColor orangeColor];
  [goalLabel sizeToFit];
  CGRect goalFrameTwo = goalLabel.frame;
  goalFrameTwo.origin.x = (120 - goalFrameTwo.size.width ) / 2 + 240;
  goalFrameTwo.origin.y = (120 - goalFrameTwo.size.height) / 2 + 400;
  goalLabel.frame = goalFrameTwo;
  [self addSubview:goalLabel];
  
  //self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.5];
  //self.layer.cornerRadius = self.frame.size.width / 2;
  //self.layer.borderWidth = 1.0;
  //[self addSubview:_activateLayer];
  
  /*self.countLabel.alpha = 0.0;
  self.exerciseLabel.alpha = 0.0;
  self.goalLabel.alpha = 0.0;*/
}

-(void)ActivatePressed
{
  [_delegate buttonPressedMessage:nil];
  [self userHasStarted];
}

-(int) getElapsedTime
{
  return _current;
}

- (void) startTimer {
  self.isCounter = NO;
  _current = 0;
  _start = [NSDate date];
  _t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTime) userInfo:nil repeats:YES];
}

-(void) resetLabels
{
  //currentLabel.font =[UIFont systemFontOfSize:110];
//  goalLabel.font =
}

-(void) userHasStarted
{
  /*self.countLabel.alpha = 1.0;
  self.exerciseLabel.alpha = 1.0;
  self.goalLabel.alpha = 1.0;
  _activateLayer.alpha = 0.0;
  self.backgroundColor = [UIColor redColor];*/
  
  currentLabel.text = @"0";
  currentLabel.font = [UIFont systemFontOfSize:210];
  _workoutTypeLabel.text = @"";
  goalLabel.text = @"--";
  
  [self centerLabels];
  //goalLabel;
}

-(void) centerLabels
{
  [currentLabel sizeToFit];
  CGRect currFrame = currentLabel.frame;
  currFrame.origin.x = (250 - currFrame.size.width ) / 2 + 10;
  currFrame.origin.y = (250 - currFrame.size.height) / 2 + 185;
  currentLabel.frame = currFrame;
  
  [goalLabel sizeToFit];
  CGRect goalFrameTwo = goalLabel.frame;
  goalFrameTwo.origin.x = (120 - goalFrameTwo.size.width ) / 2 + 240;
  goalFrameTwo.origin.y = (120 - goalFrameTwo.size.height) / 2 + 400;
  goalLabel.frame = goalFrameTwo;
  
  CGRect workoutFrame = _workoutTypeLabel.frame;
  workoutFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - workoutFrame.size.width) / 2;
  _workoutTypeLabel.frame = workoutFrame;
}

-(void) userHasFinished
{
  /*self.countLabel.alpha = 0.0;
  self.exerciseLabel.alpha = 0.0;
  self.goalLabel.alpha = 0.0;
  _activateLayer.alpha = 1.0;*/
  //self.backgroundColor = [UIColor colorWithRed:.6 green:.9 blue:0 alpha:.9];
  
  /*currentLabel.text = @"Activate";
  _workoutTypeLabel.text = @"";
  goalLabel.text = @"Goal";
  
  [self centerLabels];*/
  
  [_t invalidate];
  _t = nil;
  
  [self performSelector:@selector(endCooldownPeriod) withObject:nil afterDelay:5.0];
}

-(void) endCooldownPeriod
{
  _current = 0;
  
  currentLabel.text = @"Activate";
  currentLabel.font = [UIFont systemFontOfSize:60];
  
  goalLabel.text = @"Goal";
  
  [currentLabel sizeToFit];

  [self setTitle:@""];
  
  [self resetLabels];
}

- (void)startCounter {
  _current = 0;
  self.isCounter = YES;
}

- (void)increaseTime {
  _current++;
  NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:_start];
  
  if (_current > 10)
  {
    currentLabel.font = [UIFont systemFontOfSize:80];
  } else {
    currentLabel.font = [UIFont systemFontOfSize:120];
  }
  
    //self.countLabel.alpha = 0;
  [UIView animateWithDuration:0.5 animations:^{
  //self.countLabel.font = [UIFont systemFontOfSize:120];
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.allowedUnits = NSCalendarUnitMinute |  NSCalendarUnitSecond;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    NSString *string = [formatter stringFromTimeInterval:elapsed];
//    NSLog(@"%@", string);
    
    //self.countLabel.text = [NSString stringWithFormat:@"%@", string];
    
    currentLabel.text = [NSString stringWithFormat:@"%@", string];;
    
    NSLog(@"%@",currentLabel.text);
 /* [self.countLabel sizeToFit];
    CGRect frame = self.countLabel.frame;
    frame.origin.x = (self.frame.size.width - frame.size.width)/2;
    self.countLabel.frame = frame;
      self.countLabel.alpha = 1;*/
  }];
  
  [self centerLabels];
}

- (void)endTimer {
  [_t invalidate];
  _t = nil;
  
  //[UIView animateWithDuration:5 animations:^{
    
    /*[self.countLabel sizeToFit];
    CGRect frame = self.countLabel.frame;
    frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width - 6, _originalFrame.origin.y);
    self.countLabel.frame = frame;
    self.countLabel.alpha = 1;*/
  /*} completion:^(BOOL didComplete){
    currentLabel.text = @"";
  }];
  
  //ElapsedTime = elapsedSeconds
  [self centerLabels];*/
}

- (void)increaseCount {
  _current++;
  //self.countLabel.alpha = 0;
  
  [UIView animateWithDuration:0.5 animations:^{
    //self.countLabel.text = [NSString stringWithFormat:@"%d", _current];
    currentLabel.text =[NSString stringWithFormat:@"%d", _current];
    if (_current < 10) {
      currentLabel.font = [UIFont systemFontOfSize:210];
      //self.countLabel.font = [UIFont systemFontOfSize:210];
      //[self.countLabel sizeToFit];
      /*CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width - 6, _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;*/
    } else if (_current < 100) {
      currentLabel.font = [UIFont systemFontOfSize:190];
      /*self.countLabel.font = [UIFont systemFontOfSize:190];
      [self.countLabel sizeToFit];
      CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width,  _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;*/
    } else {
      currentLabel.font = [UIFont systemFontOfSize:140];
      /*self.countLabel.font = [UIFont systemFontOfSize:140];
      [self.countLabel sizeToFit];
      CGRect frame = self.countLabel.frame;
      frame.origin = CGPointMake(self.goalLabel.frame.origin.x - frame.size.width + 4, _originalFrame.origin.y);
      self.countLabel.frame = frame;
      self.countLabel.alpha = 1;*/
    }
    [self updateFill];
  }];
  [self centerLabels];
}

-(void) setTitle:(NSString *)newTitle
{
  /*self.exerciseLabel.text = newTitle;
  [self.exerciseLabel sizeToFit];
  CGRect positionFrame = self.exerciseLabel.frame;
  positionFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - positionFrame.size.width)/2;
  self.exerciseLabel.frame = positionFrame;*/
  
  _workoutTypeLabel.text = newTitle;
  [_workoutTypeLabel sizeToFit];
  //goalLabel;
  [self centerLabels];
}

-(void) setGoal:(int) newGoal
{
  if (newGoal == 0)
  {
    goalLabel.text = [NSString stringWithFormat:@"--"];
  } else {
    goalLabel.text = [NSString stringWithFormat:@"/%i", newGoal];
  }
  [self centerLabels];
}

- (void)updateFill {
  float progress = (float)_current/_goal;
//  CGFloat radius = 32.0;
  CGPoint startFill = CGPointMake(0, self.frame.size.height - progress*self.frame.size.height);
  CGRect frame = CGRectMake(startFill.x, startFill.y, self.frame.size.width, progress*self.frame.size.height);
  _fillView.frame = frame;
  
  // set the radius
  
  // set the mask frame, and increase the height by the
  // corner radius to hide bottom cornersda
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
