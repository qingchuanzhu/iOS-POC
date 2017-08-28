//
//  KeyboardViewController.m
//  ZQCKeyboard
//
//  Created by Qingchuan Zhu on 3/16/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@property (nonatomic, strong) UIView *keyboardView;
@property (nonatomic, assign) BOOL flickerPannelShown;
@property (nonatomic, strong) NSLayoutConstraint *iconHolderPannelHeight;
@property (nonatomic, strong) NSLayoutConstraint *iconTopConstraintCopy;
@property (nonatomic, strong) flickerView *flickerView;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.keyboardView = [[[UINib nibWithNibName:@"ZQCKeyboard" bundle:[NSBundle bundleForClass:[self class]]] instantiateWithOwner:self options:nil] firstObject];
    
    self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.view addSubview:self.keyboardView];
    
    [self.keyboardView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.keyboardView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.keyboardView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.keyboardView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    
    self.flickerPannelShown = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.iconHolderPannelHeight = [NSLayoutConstraint constraintWithItem:self.iconHolderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:350.0f];
}

// Button action for 26 input chars
- (IBAction)charButtonAction:(UIButton*)sender {
    NSString *inputChar = sender.titleLabel.text;
    [self.textDocumentProxy insertText:inputChar];
}

// Delete Button Action
- (IBAction)deleteButtonAction:(UIButton *)sender {
    [self.textDocumentProxy deleteBackward];
}

// Flickr Button Action
- (IBAction)flickrButton:(UIButton *)sender {
    if (self.flickerPannelShown) {
        [self hideFlickerPannel];
        self.flickerPannelShown = NO;
    }else{
        [self showFlickerPannel];
        self.flickerPannelShown = YES;
    }
}

- (void)showFlickerPannel{
    self.iconTopConstraintCopy = self.iconTopConstraint;
    [self.iconHolderView removeConstraint:self.iconTopConstraint];
    [self.iconHolderView addConstraint:self.iconHolderPannelHeight];
    if (!self.flickerView) {
        [self generateFlickerView];
    }
    [self.iconHolderView addSubview:self.flickerView];
    [self positionFlickerView];
    [self.iconHolderView setNeedsLayout];
}

- (void)hideFlickerPannel{
    [self.flickerView removeFromSuperview];
    self.iconTopConstraint = self.iconTopConstraintCopy;
    [self.iconHolderView removeConstraint:self.iconHolderPannelHeight];
    [self.iconHolderView addConstraint:self.iconTopConstraint];
    [self.iconHolderView setNeedsLayout];
}

- (void)generateFlickerView{
    self.flickerView = [[[UINib nibWithNibName:@"flickerView" bundle:[NSBundle bundleForClass:[self class]]] instantiateWithOwner:nil options:nil] firstObject];
}

- (void)positionFlickerView{
    if (self.flickerView && self.flickerView.superview) {
        [self.flickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *topCons = [NSLayoutConstraint constraintWithItem:self.flickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconHolderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0f];
        NSLayoutConstraint *leadingCons = [NSLayoutConstraint constraintWithItem:self.flickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconHolderView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5.0f];
        NSLayoutConstraint *trailingCons = [NSLayoutConstraint constraintWithItem:self.flickerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconHolderView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5.0f];
        NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:self.flickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.flickrButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0f];
        [self.iconHolderView addConstraints:@[topCons, leadingCons, trailingCons, bottomCons]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
