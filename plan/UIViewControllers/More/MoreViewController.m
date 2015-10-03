//
//  MoreViewController.m
//  plan
//
//  Created by Fengzy on 15/9/1.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "HelpViewController.h"
#import "MoreViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"


@implementation MoreViewController {

    NSArray *rowTitles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = str_More;
    
    UIView *footer = [[UIView alloc] init];
    self.tableView.tableFooterView = footer;
    
    rowTitles = @[str_More_Settings, str_More_Help, str_More_Like, str_More_About];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            [self toAboutViewController];
            break;
        default:
            break;
    }
}

- (void)toPersonSettingViewController {
    
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toHelpViewController {
    
    HelpViewController *controller = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toLike {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id983206049?mt=8"]];
}

- (void)toAboutViewController {
    
    AboutViewController *controller = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
