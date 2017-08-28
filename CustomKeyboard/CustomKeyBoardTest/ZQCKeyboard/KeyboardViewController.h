//
//  KeyboardViewController.h
//  ZQCKeyboard
//
//  Created by Qingchuan Zhu on 3/16/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQCButton.h"
#import "flickerView.h"

@interface KeyboardViewController : UIInputViewController
// *********** next keyboard button *********
@property (weak, nonatomic) IBOutlet UIButton *nextKeyboardButton;

// *********** supporting outlests **********
@property (weak, nonatomic) IBOutlet UIView *iconHolderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraint;

// ************ 26 Regular alphabetic buttons *************//
// Row 1
@property (weak, nonatomic) IBOutlet ZQCButton *qButton;
@property (weak, nonatomic) IBOutlet ZQCButton *wButton;
@property (weak, nonatomic) IBOutlet ZQCButton *eButton;
@property (weak, nonatomic) IBOutlet ZQCButton *rButton;
@property (weak, nonatomic) IBOutlet ZQCButton *tButton;
@property (weak, nonatomic) IBOutlet ZQCButton *yButton;
@property (weak, nonatomic) IBOutlet ZQCButton *uButton;
@property (weak, nonatomic) IBOutlet ZQCButton *iButton;
@property (weak, nonatomic) IBOutlet ZQCButton *oButton;
@property (weak, nonatomic) IBOutlet ZQCButton *pButton;

// Row 2
@property (weak, nonatomic) IBOutlet ZQCButton *aButton;
@property (weak, nonatomic) IBOutlet ZQCButton *sButton;
@property (weak, nonatomic) IBOutlet ZQCButton *dButton;
@property (weak, nonatomic) IBOutlet ZQCButton *fButton;
@property (weak, nonatomic) IBOutlet ZQCButton *gButton;
@property (weak, nonatomic) IBOutlet ZQCButton *hButton;
@property (weak, nonatomic) IBOutlet ZQCButton *jButton;
@property (weak, nonatomic) IBOutlet ZQCButton *kButton;
@property (weak, nonatomic) IBOutlet ZQCButton *lButton;

// Row 3
@property (weak, nonatomic) IBOutlet ZQCButton *zButton;
@property (weak, nonatomic) IBOutlet ZQCButton *xButton;
@property (weak, nonatomic) IBOutlet ZQCButton *cButton;
@property (weak, nonatomic) IBOutlet ZQCButton *vButton;
@property (weak, nonatomic) IBOutlet ZQCButton *bButton;
@property (weak, nonatomic) IBOutlet ZQCButton *nButton;
@property (weak, nonatomic) IBOutlet ZQCButton *mButton;

// *********** functional buttons **************//
@property (weak, nonatomic) IBOutlet UIButton *flickrButton;
@property (weak, nonatomic) IBOutlet UIButton *deletButton;





@end
