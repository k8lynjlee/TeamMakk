//
//  ExerciseCell.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "ExerciseCell.h"
@interface ExerciseCell () {
  
}
@property (nonatomic, strong) UILabel *exerciseLabel;
@end

@implementation ExerciseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self layoutCellComponents];
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 200);
  }
  return self;
}

- (void)layoutCellComponents
{
  self.exerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, self.frame.size.width, 20)];
  self.exerciseLabel.text = @"Label";
  self.exerciseLabel.font = [UIFont systemFontOfSize:16];
  [self.exerciseLabel sizeToFit];
  [self addSubview:self.exerciseLabel];
}

@end
