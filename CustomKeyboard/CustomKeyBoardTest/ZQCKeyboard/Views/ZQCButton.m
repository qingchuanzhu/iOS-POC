//
//  ZQCButton.m
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/16/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import "ZQCButton.h"

@implementation ZQCButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2.0;
}

@end
