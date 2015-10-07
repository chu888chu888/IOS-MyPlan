//
//  ThreeViewController.m
//  plan
//
//  Created by Fengzy on 15/10/6.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "ThreeViewController.h"
#import "AddPhotoViewController.h"

@interface ThreeViewController ()

@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = str_ViewTitle_3;
    self.tabBarItem.title = str_ViewTitle_3;
    
    [self showRightButtonView];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIView *footer = [[UIView alloc] init];
    self.tableView.tableFooterView = footer;
    
    self.photoArray = [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -添加导航栏按钮
- (void)showRightButtonView {
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:png_Btn_Add];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
    [button setAllImage:image];
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [rightBarButtonItems addObject:barButtonItem];
    
    self.rightBarButtonItems = rightBarButtonItems;
}

#pragma mark - action
- (void)addAction:(UIButton *)button {
    
    AddPhotoViewController *controller = [[AddPhotoViewController alloc] init];
    controller.operationType = Add;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.photoArray.count > 0) {
        
        return self.photoArray.count;
        
    } else {
        
        return 5;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.photoArray.count) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        return cell;
        
    } else {
        
        static NSString *noticeCellIdentifier = @"noPhotoCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noticeCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"";
            cell.textLabel.frame = cell.contentView.bounds;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = font_Bold_16;
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = str_Photo_Tips1;
        } else {
            cell.textLabel.text = nil;
        }
        
        return cell;
    }
}

@end
