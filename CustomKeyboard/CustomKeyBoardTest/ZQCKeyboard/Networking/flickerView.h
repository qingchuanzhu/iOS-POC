//
//  flickerView.h
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/17/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flickerView : UIView

- (void)updateViewWithImage:(UIImage *)image;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *imageHolder;

@end
