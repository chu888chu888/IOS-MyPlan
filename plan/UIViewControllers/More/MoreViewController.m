//
//  MoreViewController.m
//  plan
//
//  Created by Fengzy on 15/9/1.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "ShareCenter.h"
#import "HelpViewController.h"
#import "MoreViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"


@implementation MoreViewController{

    NSArray *rowTitles;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = str_More;
    
    UIView *footer = [[UIView alloc] init];
    self.tableView.tableFooterView = footer;
    
    rowTitles = @[str_More_Settings, str_More_Help, str_More_Like, str_More_Share, str_More_About];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row >= rowTitles.count) {
        return cell;
    }
    
    cell.detailTextLabel.text = rowTitles[indexPath.row];
    cell.detailTextLabel.textColor = color_GrayDark;
    cell.detailTextLabel.font = font_Normal_18;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
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
            [self toAboutViewController];
            break;
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
    HelpViewController *controller = [[HelpViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
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
    [ShareCenter showShareActionSheet:self.view title:str_App_Title content:str_Share_Content shareUrl:str_Website_URL sharedImageURL:@""];
}

- (void)toAboutViewController
{
    AboutViewController *controller = [[AboutViewController alloc]init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
