//
//  PhotoDetailViewController.m
//  plan
//
//  Created by Fengzy on 15/10/8.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PagedFlowView.h"
#import "AddPhotoViewController.h"
#import "PhotoDetailViewController.h"
#import "FullScreenImageViewController.h"

@interface PhotoDetailViewController () <PagedFlowViewDataSource, PagedFlowViewDelegate> {
    
    CGFloat xMargins;
    CGFloat yMargins;
    CGFloat yOffset;
    NSMutableArray *photoArray;
    UILabel *labelCurrentPage;
    PagedFlowView *pageFlowView;
    
}

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = str_Photo_Detail;
    self.view.backgroundColor = color_eeeeee;
    
    photoArray = [NSMutableArray array];
    
    [self showRightButtonView];
    [self initVariables];
    [self loadCustomView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)showRightButtonView {
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:png_Btn_Edit];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
    [button setAllImage:image];
    [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [rightBarButtonItems addObject:barButtonItem];
    
    self.rightBarButtonItems = rightBarButtonItems;
}

- (void)initVariables {
    
    xMargins = 12;
    yMargins = 30;
    yOffset = HEIGHT_FULL_SCREEN - yMargins - 64;
    
}

- (void)loadCustomView {
    
    UIImage *addImage = [UIImage imageNamed:@"LaunchImage"];
    [photoArray addObject:addImage];
    
    [self createTextViewContent];
    [self createLabelTimeAndLocation];
    [self createLabelCurrentPage];
    [self createPagedFlowView];
    
}

- (void)createTextViewContent {
    
    NSString *content = @"测试内容的是";
    
    if (content && content.length > 0) {
        
        CGSize size = [content sizeWithFont:font_Normal_16 constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat contentHeight = size.height + 10;//获取自适应文本内容高度
        contentHeight = contentHeight > 108 ? 108 : contentHeight;//content高度不能超过108
        
        yOffset -= contentHeight;
        UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(xMargins, yOffset, WIDTH_FULL_SCREEN - xMargins * 2, contentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.font = font_Normal_16;
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.textColor = color_333333;
        contentView.text = content;
        contentView.editable = NO;
        if (contentHeight < 30) {
            
            contentView.textAlignment = NSTextAlignmentCenter;
            
        } else {
            
            contentView.textAlignment = NSTextAlignmentLeft;
            
        }
        
        [self.view addSubview:contentView];
        
    }
}

- (void)createLabelTimeAndLocation {
    
    yOffset -= 30;
    UILabel *labelTimeAndLocation = [[UILabel alloc] initWithFrame:CGRectMake(xMargins, yOffset, WIDTH_FULL_SCREEN - xMargins * 2, 30)];
    labelTimeAndLocation.font = font_Normal_18;
    labelTimeAndLocation.textColor = color_666666;
    labelTimeAndLocation.textAlignment = NSTextAlignmentCenter;
    labelTimeAndLocation.text = @"时间：2015-10-08   地点：广州";
    
    [self.view addSubview:labelTimeAndLocation];
    
}

- (void)createLabelCurrentPage {
    
    yOffset -= 30;
    UILabel *labelPage = [[UILabel alloc] initWithFrame:CGRectMake(xMargins, yOffset, WIDTH_FULL_SCREEN - xMargins * 2, 30)];
    labelPage.font = font_Bold_18;
    labelPage.textColor = color_Blue;
    labelPage.textAlignment = NSTextAlignmentCenter;
    labelPage.text = [NSString stringWithFormat:@"1 / %ld", (long)photoArray.count];
    
    labelCurrentPage = labelPage;
    [self.view addSubview:labelPage];
    
}

- (void)createPagedFlowView {
    
    pageFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_FULL_SCREEN, yOffset)];
    pageFlowView.backgroundColor = color_e9eff1;
    pageFlowView.minimumPageAlpha = 0.7;
    pageFlowView.minimumPageScale = 0.9;
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    
    [self.view addSubview:pageFlowView];

}

#pragma mark - action
- (void)editAction:(UIButton *)button {
    
    AddPhotoViewController *controller = [[AddPhotoViewController alloc] init];
    controller.operationType = Edit;
    controller.photo = self.photo;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    
    return photoArray.count;
    
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    [flowView dequeueReusableCell]; //必须要调用否则会内存泄漏
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = photoArray[index];
    
    
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    
    CGFloat width = yOffset * 185.4 / 300;
    
    return CGSizeMake(width, yOffset);
    
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
    
    long current = index + 1;
    long total = photoArray.count;
    labelCurrentPage.text = [NSString stringWithFormat:@"%ld / %ld", current, total];

}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
    
    FullScreenImageViewController *controller = [[FullScreenImageViewController alloc] init];
    controller.image = photoArray[index];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
