//
//  SettingsSetTextViewController.m
//  plan
//
//  Created by Fengzy on 15/9/2.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "SettingsSetTextViewController.h"

NSUInteger const kSettingsSetTextViewEdgeInset = 10;

@interface SettingsSetTextViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@end

@implementation SettingsSetTextViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    {
        UIImage *image = [UIImage imageNamed:png_Btn_Save];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
        [button setAllImage:image];
        [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [rightBarButtonItems addObject:barButtonItem];
    }
    
    self.rightBarButtonItems = rightBarButtonItems;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.textField) {
        
        [self loadCustomView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)loadCustomView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSUInteger yOffset = kSettingsSetTextViewEdgeInset + 5;
    
    UIImage *image = [UIImage imageNamed:png_Bg_Input_Gray];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kSettingsSetTextViewEdgeInset, yOffset, [self contentWidth], 37)];
    textField.background = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    if (self.textFieldPlaceholder.length > 0) {
        textField.placeholder = self.textFieldPlaceholder;
    }
    
    if (self.setType == SetLife) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (self.setType == SetEmail){
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    
    self.textField = textField;
    
    yOffset = CGRectGetMaxY(textField.frame) + 15;
}

#pragma mark - funcs

- (NSUInteger)contentWidth{
    static NSUInteger contentWidth = 0;
    if (contentWidth == 0) {
        contentWidth = CGRectGetWidth(self.view.bounds) - kSettingsSetTextViewEdgeInset * 2;
    }
    return contentWidth;
}


#pragma mark - action
- (void)saveAction:(UIButton *)button{
    if (self.finishedBlock) {
        self.finishedBlock(self.textField.text);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIImage *image = [UIImage imageNamed:png_Bg_Input_Blue];
    textField.background = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIImage *image = [UIImage imageNamed:png_Bg_Input_Gray];
    textField.background = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
}


@end
