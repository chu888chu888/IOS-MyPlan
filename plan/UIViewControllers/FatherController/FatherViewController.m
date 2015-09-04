//
//  FatherViewController.m
//  plan
//
//  Created by Fengzy on 15/8/30.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "FatherViewController.h"

@interface FatherViewController ()

@property (nonatomic, strong, readwrite) UIButton *backButton;

@end

@implementation FatherViewController

@synthesize isPush;

- (id)init {
    self = [super init];
    if (self) {
        self.isPush = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPush = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    self.view.backgroundColor = color_Background;

    UIImage *navigationBarBg = [UIImage imageNamed:@"Bg_NavigationBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBg forBarMetrics:UIBarMetricsDefault];
    //设置返回按钮文字颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //设置导航栏标题字体和颜色
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          font_Bold_20,UITextAttributeFont,
                          [UIColor whiteColor],UITextAttributeTextColor ,
                          [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)] , UITextAttributeTextShadowOffset ,
                          [UIColor whiteColor] ,UITextAttributeTextShadowColor ,
                          nil];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ dealloc", [self class]);
}

-(UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font selector:(SEL)selector
{
    CGFloat btnWidth = 50,btnHeight = 44;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(UIBarButtonItem *)createBarButtonItemWithNormalImageName:(NSString *)normalImageName selectedImageName:(NSString*)selectedImageName selector:(SEL)selector
{
    CGFloat width = 25;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, width);
    UIImage *imageNormal = [UIImage imageNamed:normalImageName];
    UIImage *imageSelected = [UIImage imageNamed:selectedImageName];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)willBack{}

- (void)backAction:(UIButton*)sender {
    [self willBack];
    if(isPush)
    {
        if (self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end


#import "AlertCenter.h"

@implementation FatherViewController (alert)

- (void)alertButtonMessage:(NSString *)message
{
    [AlertCenter alertButtonMessage:message];
}

- (void)alertToastMessage:(NSString *)message
{
    [AlertCenter alertToastMessage:message];
}

@end