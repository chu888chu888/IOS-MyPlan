//
//  PhotoCell.m
//  plan
//
//  Created by Fengzy on 15/10/6.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

+ (PhotoCell *)cellView:(Photo *)photo {
    
    PhotoCell *cell = [[PhotoCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_FULL_SCREEN, 300)];
    
    CGFloat xMargins = 12;
    CGFloat yMargins = 5;
    CGFloat xOffset = xMargins;
    CGFloat yOffset = yMargins;
    CGFloat dateWidth = 50;
    CGFloat labelHeight = 30;
    
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, dateWidth, labelHeight)];
    labelDate.textAlignment = NSTextAlignmentCenter;
    labelDate.font = font_Normal_16;
    labelDate.text = @"2015-10-08";
    [cell addSubview:labelDate];
    
    xOffset += dateWidth;
    UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, WIDTH_FULL_SCREEN - dateWidth - xMargins * 2, labelHeight * 3)];
    labelContent.textAlignment = NSTextAlignmentLeft;
    labelContent.font = font_Normal_16;
    labelContent.numberOfLines = 3;
    labelContent.text = @"测试是事实是时候死hi搜狐和搜狐哦啊红花山东宏撒谎昂首撒谎哦哈SOHO大红啊还是都好好都好少等候阿迪后阿萨德哈时候啥都安宏达";
    [cell addSubview:labelContent];
    
    CGFloat imageSpace = 10;
    CGFloat imageWidth = (WIDTH_FULL_SCREEN - dateWidth - imageSpace * 2 - xMargins * 2) / 3; //WIDTH_FULL_SCREEN - 62 - 12
    CGFloat imageHeight = 200;
    
    yOffset += labelHeight * 3;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, imageWidth, imageHeight)];
    imageView.image = [UIImage imageNamed:png_ImageDefault];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    xOffset += imageWidth + imageSpace;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, imageWidth, imageHeight)];
    imageView1.image = [UIImage imageNamed:png_ImageDefault];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    [cell addSubview:imageView1];
    
    xOffset += imageWidth + imageSpace;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, imageWidth, imageHeight)];
    imageView2.image = [UIImage imageNamed:png_ImageDefault];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    [cell addSubview:imageView2];
    
    return cell;
    
}

@end
