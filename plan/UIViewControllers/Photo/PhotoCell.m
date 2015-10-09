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
    
    CGFloat xMargins = 8;
    CGFloat yMargins = 5;
    CGFloat xOffset = xMargins;
    CGFloat yOffset = yMargins;
    CGFloat dateWidth = 50;
    CGFloat labelHeight = 30;
    CGFloat btnAgeSize = 45;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + btnAgeSize / 2 - 1, 0, 2, 300)];
    lineView.backgroundColor = color_ff9900;
    [cell addSubview:lineView];
    
    UIButton *btnAge = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, btnAgeSize, btnAgeSize)];
    btnAge.backgroundColor = color_ff9900;
    btnAge.layer.cornerRadius = btnAgeSize / 2;
    btnAge.titleLabel.font = font_Bold_20;
    btnAge.tintColor = [UIColor whiteColor];
    [btnAge setTitle:@"28" forState:UIControlStateNormal];
    [btnAge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell addSubview:btnAge];
    
    xOffset += btnAgeSize;
    
    UILabel *labelYear = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, dateWidth, labelHeight)];
    labelYear.textAlignment = NSTextAlignmentCenter;
    labelYear.font = font_Normal_16;
    labelYear.textColor = color_Blue;
    labelYear.text = @"2015";
    [cell addSubview:labelYear];
    
    UILabel *labelMonthAndDay = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset + labelHeight / 2, dateWidth, labelHeight)];
    labelMonthAndDay.textAlignment = NSTextAlignmentCenter;
    labelMonthAndDay.font = font_Normal_12;
    labelMonthAndDay.textColor = color_Blue;
    labelMonthAndDay.text = @"10/08";
    [cell addSubview:labelMonthAndDay];
    
//    xOffset += dateWidth;
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + btnAgeSize / 2 - 1, 0, 2, cell.bounds.size.height)];
//    lineView.backgroundColor = color_ff9900;
//    [cell addSubview:lineView];
//    
//    UIButton *btnAge = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, btnAgeSize, btnAgeSize)];
//    btnAge.backgroundColor = color_ff9900;
//    btnAge.layer.cornerRadius = btnAgeSize / 2;
//    btnAge.titleLabel.font = font_Bold_20;
//    btnAge.tintColor = [UIColor whiteColor];
//    [btnAge setTitle:@"28" forState:UIControlStateNormal];
//    [btnAge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cell addSubview:btnAge];
    
    
//    xOffset = xMargins * 3;
    yOffset += labelHeight + yMargins;
    
    NSString *content = @"测试是事实是时候死hi搜狐和搜狐哦啊红花山东宏撒谎昂首撒谎哦哈SOHO大红啊还是都好好都好少等候阿迪后阿萨德哈时候啥都安宏达";
    if (content && content.length > 0) {

        UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, WIDTH_FULL_SCREEN - xOffset * 2, labelHeight * 3)];
        labelContent.textAlignment = NSTextAlignmentLeft;
        labelContent.font = font_Normal_16;
        labelContent.numberOfLines = 3;
        labelContent.text = content;
        [cell addSubview:labelContent];
        
        yOffset = CGRectGetMaxY(labelContent.frame);
        
    } else {
        
        yOffset = CGRectGetMaxY(btnAge.frame) + yMargins;
    
    }
    CGFloat imageSpace = 10;
    CGFloat photoWidth = WIDTH_FULL_SCREEN - xOffset * 2;
    CGFloat imageWidth = (photoWidth - imageSpace * 2) / 3;
    CGFloat photoHeight = 155;

    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yOffset, photoWidth, photoHeight)];
    photoView.backgroundColor = color_e9eff1;
    [cell addSubview:photoView];
    
    CGFloat pXOffset = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(pXOffset, 0, imageWidth, photoHeight)];
    imageView.image = [UIImage imageNamed:@"ImageTest"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [photoView addSubview:imageView];
    
    pXOffset += imageWidth + imageSpace;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(pXOffset, 0, imageWidth, photoHeight)];
    imageView1.image = [UIImage imageNamed:png_Bg_LaunchImage];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    [photoView addSubview:imageView1];
    
    pXOffset += imageWidth + imageSpace;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(pXOffset, 0, imageWidth, photoHeight)];
    imageView2.image = [UIImage imageNamed:@"ImageTest"];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    [photoView addSubview:imageView2];
    
    return cell;
    
}

@end
