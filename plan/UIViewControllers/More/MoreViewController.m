//
//  MoreViewController.m
//  plan
//
//  Created by Fengzy on 15/9/1.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"

NSUInteger const kMoreViewSectionShadowHeight = 1;
NSUInteger const kMoreViewEdgeInset = 15;
NSUInteger const kMoreViewCellHeight = 50;
NSUInteger const kMoreViewSectionButtonTag = 1000;

@interface MoreViewController()

@property (strong, nonatomic) UIView *layerView;

@end

@implementation MoreViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = str_More;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.layerView) {
        
        [self loadCustomView];
    }
}

- (void)loadCustomView{
    self.layerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    {
        NSArray *sectionTitles = @[str_More_Settings, str_More_Help, str_More_Like, str_More_Share, str_More_About];
        
        UIView *view = [self createSectionViewWithTitles:sectionTitles buttonAction:@selector(sectionButtonAction:)];
//        CGRect frame = view.frame;
//        view.frame = frame;
        [self.layerView addSubview:view];
    }
}

- (UIView *)createSectionViewWithTitles:(NSArray *)sectionTitles buttonAction:(SEL)action{
    UIView *sectionBackgroundView = [self createSectionBackgroundView];
    
    NSUInteger yOffset = kMoreViewSectionShadowHeight;
    {
        CGRect frame = CGRectZero;
        frame.origin.x = 0;
        frame.size.width = CGRectGetWidth(self.layerView.bounds);
        frame.size.height = kMoreViewCellHeight;
        
        for (NSString *title in sectionTitles) {
            
            frame.origin.y = yOffset;
            yOffset = CGRectGetMaxY(frame);
            
            NSUInteger index = [sectionTitles indexOfObject:title];
            
            UIButton *button = [self createButtonView];
            button.frame = frame;
            [button setAllTitle:title];
            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            button.tag = kMoreViewSectionButtonTag + index;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 25, 12.5, 16, 25)];
            [imageView setImage:[UIImage imageNamed:png_Icon_Arrow_Right]];
            [button addSubview:imageView];
            
            [sectionBackgroundView addSubview:button];
            if (index != sectionTitles.count - 1) {
                [self addLineForView:button];
            }
        }
    }
    
    CGRect frame = CGRectZero;
    frame.size.width = CGRectGetWidth(self.layerView.bounds);
    frame.size.height = yOffset + kMoreViewSectionShadowHeight;
    sectionBackgroundView.frame = frame;
    
    return sectionBackgroundView;
}

- (UIView *)createSectionBackgroundView{
    UIImage *image = [UIImage imageNamed:png_Bg_Cell_White];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    imageView.userInteractionEnabled = YES;
    
    return imageView;
}

- (UIButton *)createButtonView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.exclusiveTouch = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setAllTitleColor:color_GrayDark];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, kMoreViewEdgeInset, 0, 0)];
    [button setBackgroundImage:[UIImage imageForSelectedBlue] forState:UIControlStateHighlighted];
    
    return button;
}

- (void)addLineForView:(UIView *)view{
    CGRect frame = CGRectZero;
    frame.origin.x = kMoreViewEdgeInset;
    frame.origin.y = CGRectGetHeight(view.bounds) - 1;
    frame.size.width = CGRectGetWidth(view.bounds) - kMoreViewEdgeInset;
    frame.size.height = 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color_GrayLight;
    [view addSubview:lineView];
}

- (void)sectionButtonAction:(UIButton *)button
{
    switch (button.tag - kMoreViewSectionButtonTag) {
        case 0:
            [self toPersonSettingViewController];
            break;
        case 1:
            [self toHelpViewController];
            break;
        case 2:
            [self toLike];
            break;
        case 3:
            [self toShareViewController];
            break;
        case 4:
//            [self toFeedbackViewController];
//            break;
        case 5:
//            [self toCheckUpdateViewController];
//            break;
        case 6:
            [self toAboutViewController];
            break;
        case 7:
//            [self toWelcomeViewController];
        default:
            break;
    }
}

- (void)toPersonSettingViewController
{
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toHelpViewController
{
//    SetupCenter_UseHelpViewController *viewController = [[SetupCenter_UseHelpViewController alloc]init];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toLike
{
    /*
     *跳转到下载界面：http://itunes.apple.com/app/idxxxxxxxxx?mt=8
     *跳转到评分界面：itms-apps://http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=xxxxxxxxx&type=Purple+Software
    */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=983206049&type=Purple+Software"]];
}

- (void)toShareViewController
{
//    SetupCenter_ShareViewController *viewController = [[SetupCenter_ShareViewController alloc]init];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toFeedbackViewController
{
//    SetupCenter_FeedbackViewController *viewController = [[SetupCenter_FeedbackViewController alloc]init];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toCheckUpdateViewController
{
    //    SetupCenter_ShareViewController *viewController = [[SetupCenter_ShareViewController alloc]init];
    //
    //    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toAboutViewController
{
    AboutViewController *controller = [[AboutViewController alloc]init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toWelcomeViewController
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate showWelcomeView];
}


@end
