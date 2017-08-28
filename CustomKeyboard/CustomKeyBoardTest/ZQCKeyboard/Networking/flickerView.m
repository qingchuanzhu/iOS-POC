//
//  flickerView.m
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/17/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import "flickerView.h"

@implementation flickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.indicatorView.hidesWhenStopped = YES;
    [self.indicatorView startAnimating];
}

- (void) layoutSubviews{
    [super layoutSubviews];
}

- (void)updateViewWithImage:(UIImage *)image{
    [self.indicatorView stopAnimating];
    [self.imageHolder setImage:image];
}
@end
