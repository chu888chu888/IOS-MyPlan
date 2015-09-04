//
//  AboutViewController.m
//  plan
//
//  Created by Fengzy on 15/9/1.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController()

@property (strong, nonatomic) UIView *layerView;
@property (strong, nonatomic) UILabel *labelContent;
@property (strong, nonatomic) UILabel *labelCompany;
@property (strong, nonatomic) UILabel *labelQQGroup;
@property (strong, nonatomic) UILabel *labelWechat;
@property (assign, nonatomic) NSUInteger xMiddle;
@property (assign, nonatomic) NSUInteger yOffset;

@end

@implementation AboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = str_More_About;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.layerView) {
        
        [self loadCustomView];
    }
}

- (void)loadCustomView
{
    self.layerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    [self showLogo];
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTextColor:color_GrayDark];
        UIFont *font = font_Normal_16;
        [label setFont:font];
        [label setText:str_About_Content];
        //设置一个行高上限
        CGSize size = CGSizeMake(self.layerView.frame.size.width - 60,2000);
        //计算实际frame大小，并将label的frame变成实际大小
        CGFloat yLabel = self.yOffset;
        CGSize labelsize = [str_About_Content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(30, yLabel, labelsize.width, labelsize.height);
        [self.layerView addSubview:label];
        self.labelContent = label;
        
        self.yOffset += labelsize.height + 20;
    }
    {
        NSString *content = str_About_Copyright;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTextColor:color_GrayDark];
        UIFont *font = font_Normal_16;
        [label setFont:font];
        [label setText:content];
        CGSize size = CGSizeMake(self.layerView.frame.size.width - 60,2000);
        CGFloat yLabel = self.yOffset;
        CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(30, yLabel, labelsize.width, labelsize.height);
        [self.layerView addSubview:label];
        self.labelCompany = label;
        
        self.yOffset += labelsize.height + 10;
    }
//    {
//        NSString *content = @"讨论QQ群:217 103 389";
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//        [label setNumberOfLines:0];
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        [label setTextColor:color_GrayDark];
//        UIFont *font = font_Normal_16;
//        [label setFont:font];
//        [label setText:content];
//        CGSize size = CGSizeMake(self.layerView.frame.size.width - 60,2000);
//        CGFloat yLabel = self.yOffset;
//        CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//        label.frame = CGRectMake(30, yLabel, labelsize.width, labelsize.height);
//        [self.layerView addSubview:label];
//        self.labelQQGroup = label;
//        
//        self.yOffset += labelsize.height + 10;
//    }
    {
        NSString *content = str_About_Wechat;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTextColor:color_GrayDark];
        UIFont *font = font_Normal_16;
        [label setFont:font];
        [label setText:content];
        CGSize size = CGSizeMake(self.layerView.frame.size.width - 60,2000);
        CGFloat yLabel = self.yOffset;
        CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(30, yLabel, labelsize.width, labelsize.height);
        [self.layerView addSubview:label];
        self.labelWechat = label;
        
        self.yOffset += labelsize.height + 10;
    }
}

- (void)showLogo{
    
    NSUInteger logoSize = 88;
    self.xMiddle = self.view.bounds.size.width / 2;
    self.yOffset = 30;
    
    UIImage *logoImage = [UIImage imageNamed:png_Icon_Logo_512];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.xMiddle - logoSize / 2, self.yOffset, logoSize, logoSize)];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.image = logoImage;
    logoImageView.clipsToBounds = YES;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    
    self.yOffset = CGRectGetMaxY(logoImageView.frame) + 10;
    
    {
        NSString *version = [NSString stringWithFormat:@"%@%@", str_About_Version, [[Config shareInstance] appVersion]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTextColor:color_Blue];
        UIFont *font = font_Normal_16;
        [label setFont:font];
        [label setText:version];
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = CGSizeMake(self.layerView.frame.size.width - 60,2000);
        CGFloat yLabel = self.yOffset;
        CGSize labelsize = [version sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(self.xMiddle - labelsize.width/2, yLabel, labelsize.width, labelsize.height);
        [self.layerView addSubview:label];
        
        self.yOffset = CGRectGetMaxY(label.frame) + 30;
    }
}


@end
