//
//  SettingsViewController.m
//  plan
//
//  Created by Fengzy on 15/9/1.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCache.h"
#import "ThreeSubView.h"
#import "SettingsViewController.h"
#import "SettingsSetTextViewController.h"

NSUInteger const kSettingsViewAlertTagForSetNickName = 932;
NSUInteger const kSettingsViewAlertTagForSetLife = 933;
NSUInteger const kSettingsViewPickerBgViewTag = 20141228;

NSUInteger const kSettingsViewEdgeInset = 10;
NSUInteger const kSettingsViewCellHeight = 44;
NSUInteger const kSettingsViewPickerHeight = 216;
NSUInteger const kSettingsViewToolBarHeight = 44;
NSUInteger const kSettingsViewRightEdgeInset = 8;
NSString * const kSettingsViewEdgeWhiteSpace = @"  ";


@interface SettingsViewController()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) ThreeSubView *nickThreeSubView;
@property (nonatomic, strong) ThreeSubView *sexThreeSubView;
@property (nonatomic, strong) ThreeSubView *birthThreeSubView;
@property (nonatomic, strong) ThreeSubView *lifeThreeSubView;
@property (nonatomic, strong) ThreeSubView *emailThreeSubView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = str_More_Settings;
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
    
    NSUInteger yOffset = kSettingsViewEdgeInset;
    
    {
        UIView *view = [self createSectionTwoView];
        [self.layerView addSubview:view];
        
        CGRect frame = view.frame;
        frame.origin.y = yOffset;
        view.frame = frame;
        
        yOffset = CGRectGetMaxY(view.frame) + kSettingsViewEdgeInset;
    }
}

- (UIView *)createSectionTwoView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kSettingsViewEdgeInset, 0, [self contentWidth], 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSUInteger yOffset = 0;
    
    {
        ThreeSubView *threeSubView = [self createAvatarView];
        [self addSeparatorForView:threeSubView];
        [view addSubview:threeSubView];
        
        CGRect frame = threeSubView.frame;
        frame.origin.y = yOffset;
        threeSubView.frame = frame;
        
        yOffset = CGRectGetMaxY(frame);
    }
    
    {
        ThreeSubView *threeSubView = [self createNickNameView];
        [self addSeparatorForView:threeSubView];
        [view addSubview:threeSubView];
        
        CGRect frame = threeSubView.frame;
        frame.origin.y = yOffset;
        threeSubView.frame = frame;
        
        yOffset = CGRectGetMaxY(frame);
    }
    
    {
        ThreeSubView *threeSubView = [self createGenderView];
        [self addSeparatorForView:threeSubView];
        [view addSubview:threeSubView];
        
        CGRect frame = threeSubView.frame;
        frame.origin.y = yOffset;
        threeSubView.frame = frame;
        
        yOffset = CGRectGetMaxY(frame);
    }
    
    {
        ThreeSubView *threeSubView = [self createBirthdayView];
        [self addSeparatorForView:threeSubView];
        [view addSubview:threeSubView];
        
        CGRect frame = threeSubView.frame;
        frame.origin.y = yOffset;
        threeSubView.frame = frame;
        
        yOffset = CGRectGetMaxY(frame);
    }
    
    {
        ThreeSubView *threeSubView = [self createLifespanView];
        [view addSubview:threeSubView];
        
        CGRect frame = threeSubView.frame;
        frame.origin.y = yOffset;
        threeSubView.frame = frame;
        
        yOffset = CGRectGetMaxY(frame);
    }
    
    CGRect frame = view.frame;
    frame.size.height = yOffset;
    view.frame = frame;
    
    [self configBorderForView:view];
    
    return view;
}

- (ThreeSubView *)createAvatarView
{
    __weak typeof(self) weakSelf = self;
    ThreeSubView *threeSubView = [self getThreeSubViewForCenterBlock:^{
        [weakSelf setAvatar];
    } rightBlock:nil];
    [threeSubView.leftButton setAllTitle:[self addLeftWhiteSpaceForString:str_Settings_Avatar]];
    
    threeSubView.fixCenterWidth = [self contentWidth] - threeSubView.fixLeftWidth;
    
    [threeSubView autoLayout];
    
    
    NSUInteger yDistance = 2;
    UIImage *bgImage = [UIImage imageNamed:png_AvatarBg];
    CGFloat bgSize = kSettingsViewCellHeight - yDistance;
    UIImageView *avatarBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(threeSubView.centerButton.bounds) - kSettingsViewEdgeInset - bgSize, yDistance, bgSize, bgSize)];
    avatarBg.backgroundColor = [UIColor clearColor];
    avatarBg.image = bgImage;
    avatarBg.layer.cornerRadius = bgSize / 2;
    avatarBg.clipsToBounds = YES;
    avatarBg.userInteractionEnabled = YES;
    avatarBg.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *avatarImage = [[Config shareInstance] getAvatar];
    CGFloat avatarSize = bgSize - yDistance;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf((bgSize - avatarSize)/2), ceilf((bgSize - avatarSize)/2), avatarSize, avatarSize)];
    avatar.backgroundColor = [UIColor clearColor];
    avatar.image = avatarImage;
    avatar.layer.cornerRadius = avatarSize / 2;
    avatar.clipsToBounds = YES;
    avatar.contentMode = UIViewContentModeScaleAspectFit;
    avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAvatar)];
    [avatar addGestureRecognizer:singleTap];
    
    [avatarBg addSubview:avatar];
    
    [threeSubView.centerButton addSubview:avatarBg];
    
    self.avatarView = avatar;

    return threeSubView;
}

- (ThreeSubView *)createNickNameView
{
    __weak typeof(self) weakSelf = self;
    ThreeSubView *threeSubView = [self getThreeSubViewForCenterBlock:^{
        [weakSelf toSetNickNameViewController];
    } rightBlock:nil];
    [threeSubView.leftButton setAllTitle:[self addLeftWhiteSpaceForString:str_Settings_Nickname]];
    threeSubView.fixRightWidth = kSettingsViewRightEdgeInset;
    threeSubView.fixCenterWidth = [self contentWidth] - threeSubView.fixLeftWidth - threeSubView.fixRightWidth;
    
    NSString *userNickName = [Config shareInstance].settings.nickname;
    if (userNickName.length == 0) {
        userNickName = str_Settings_Nickname_Tips;
    }
    [threeSubView.centerButton setAllTitle:userNickName];
    
    [threeSubView autoLayout];
    
    self.nickThreeSubView = threeSubView;
    
    return threeSubView;
}

- (ThreeSubView *)createGenderView
{
    __weak typeof(self) weakSelf = self;
    
    ThreeSubView *threeSubView = [self getThreeSubViewForCenterBlock:^{
        [weakSelf setMale];
    } rightBlock:^{
        [weakSelf setFemale];
    }];
    
    threeSubView.fixCenterWidth = 55;
    [threeSubView.centerButton setImage:[UIImage imageNamed:png_Icon_Gender_M_Normal] forState:UIControlStateNormal];
    [threeSubView.centerButton setImage:[UIImage imageNamed:png_Icon_Gender_M_Selected] forState:UIControlStateSelected];
    [threeSubView.centerButton setAllTitle:str_Settings_Gender_M];
    
    threeSubView.fixRightWidth = 55;
    [threeSubView.rightButton setImage:[UIImage imageNamed:png_Icon_Gender_F_Normal] forState:UIControlStateNormal];
    [threeSubView.rightButton setImage:[UIImage imageNamed:png_Icon_Gender_F_Selected] forState:UIControlStateSelected];
    [threeSubView.rightButton setAllTitle:str_Settings_Gender_F];
    
    [threeSubView.leftButton setAllTitle:[self addLeftWhiteSpaceForString:str_Settings_Gender]];
    threeSubView.fixLeftWidth = [self contentWidth] - threeSubView.fixRightWidth - threeSubView.fixCenterWidth;
    
    threeSubView.centerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    threeSubView.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSString *gender = [Config shareInstance].settings.gender;
    if (gender) {
        if ([gender intValue] == 0) {
            
            threeSubView.rightButton.selected = YES;
            
        } else if ([gender intValue] == 1) {
            
            threeSubView.centerButton.selected = YES;
        }
    }
    
    self.sexThreeSubView = threeSubView;
    
    [threeSubView autoLayout];
    
    return threeSubView;
}

- (ThreeSubView *)createBirthdayView
{
    __weak typeof(self) weakSelf = self;
    ThreeSubView *threeSubView = [self getThreeSubViewForCenterBlock:^{
        [weakSelf setBirthday];
    } rightBlock:nil];
    [threeSubView.leftButton setAllTitle:[self addLeftWhiteSpaceForString:str_Settings_Birthday]];
    threeSubView.fixRightWidth = kSettingsViewRightEdgeInset;
    threeSubView.fixCenterWidth = [self contentWidth] - threeSubView.fixLeftWidth - threeSubView.fixRightWidth;
    
    NSString *birthday = [Config shareInstance].settings.birthday;
    if (birthday.length == 0) {
        birthday = str_Settings_Birthday_Tips;
    }
    [threeSubView.centerButton setAllTitle:birthday];
    
    self.birthThreeSubView = threeSubView;
    
    [threeSubView autoLayout];
    
    return threeSubView;
}

- (ThreeSubView *)createLifespanView
{
    __weak typeof(self) weakSelf = self;
    ThreeSubView *threeSubView = [self getThreeSubViewForCenterBlock:^{
        [weakSelf toSetLifeViewController];
    } rightBlock:nil];
    [threeSubView.leftButton setAllTitle:[self addLeftWhiteSpaceForString:str_Settings_Lifespan]];
    threeSubView.fixRightWidth = kSettingsViewRightEdgeInset;
    threeSubView.fixCenterWidth = [self contentWidth] - threeSubView.fixLeftWidth - threeSubView.fixRightWidth;
    
    NSString *lifetime = [Config shareInstance].settings.lifespan;
    if (lifetime.length == 0) {
        lifetime = str_Settings_Lifespan_Tips;
    }
    [threeSubView.centerButton setAllTitle:lifetime];
    
    [threeSubView autoLayout];
    
    self.lifeThreeSubView = threeSubView;
    
    return threeSubView;
}

- (ThreeSubView *)getThreeSubViewForCenterBlock:(ButtonSelectBlock)centerBlock rightBlock:(ButtonSelectBlock)rightBlock
{
    CGRect frame = CGRectZero;
    frame.size = [self cellSize];
    
    ThreeSubView *threeSubView = [[ThreeSubView alloc] initWithFrame:frame leftButtonSelectBlock:nil centerButtonSelectBlock:centerBlock rightButtonSelectBlock:rightBlock];
    
    threeSubView.backgroundColor = [UIColor clearColor];
    
    threeSubView.fixLeftWidth = 100;
    threeSubView.leftButton.titleLabel.font = font_Normal_14;
    threeSubView.centerButton.titleLabel.font = font_Normal_16;
    threeSubView.rightButton.titleLabel.font = font_Normal_16;
    
    [threeSubView.leftButton setAllTitleColor:color_GrayDark];
    [threeSubView.centerButton setAllTitleColor:color_GrayDark];
    [threeSubView.rightButton setAllTitleColor:color_GrayDark];
    
    [threeSubView.leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [threeSubView.centerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [threeSubView.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    return threeSubView;
}

- (void)configBorderForView:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [color_GrayLight CGColor];
    view.layer.cornerRadius = 2;
}

- (void)addSeparatorForView:(UIView *)view
{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.bounds) - 1, CGRectGetWidth(view.bounds) - 1, 1)];
    separator.backgroundColor = color_GrayLight;
    [view addSubview:separator];
}

- (NSUInteger)contentWidth
{
    static NSUInteger contentWidth = 0;
    if (contentWidth == 0) {
        contentWidth = CGRectGetWidth(self.layerView.bounds) - kSettingsViewEdgeInset * 2;
    }
    return contentWidth;
}

- (CGSize)cellSize
{
    static CGSize cellSize = {0, 0};
    if (CGSizeEqualToSize(cellSize, CGSizeZero)) {
        cellSize = CGSizeMake([self contentWidth], kSettingsViewCellHeight);
    }
    return cellSize;
}

- (NSString *)addLeftWhiteSpaceForString:(NSString *)string
{
    return [NSString stringWithFormat:@"%@%@", kSettingsViewEdgeWhiteSpace, string];
}

- (void)setAvatar
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:str_Settings_SetAvatar_Tips1
                                                                 delegate:self
                                                        cancelButtonTitle:str_Cancel
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:str_Settings_SetAvatar_Camera, str_Settings_SetAvatar_Album, nil];
        [actionSheet showInView:self.view];
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:str_Settings_SetAvatar_Tips2
                                                                 delegate:self
                                                        cancelButtonTitle:str_Cancel
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:str_Settings_SetAvatar_Album, nil];
        [actionSheet showInView:self.view];
    }else {
        //不支持相片选取
    }
}

- (void)toSetNickNameViewController
{
    __weak typeof(self) weakSelf = self;
    SettingsSetTextViewController *controller = [[SettingsSetTextViewController alloc] init];
    controller.title = str_Set_Nickname;
    controller.textFieldPlaceholder = str_Set_Nickname_Tips1;
    controller.setType = SetNickName;
    controller.finishedBlock = ^(NSString *text){
        
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (text.length > 10) {
            [weakSelf alertButtonMessage:str_Set_Nickname_Tips2];
            return;
        }
        
        if (text.length == 0) {
            [weakSelf alertButtonMessage:str_Set_Nickname_Tips1];
            return;
        }

        [Config shareInstance].settings.nickname = text;
        [PlanCache storePersonalSettings:[Config shareInstance].settings];
        
        [weakSelf.nickThreeSubView.centerButton setAllTitle:text];
        [self alertToastMessage:str_Save_Success];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toSetLifeViewController
{
    __weak typeof(self) weakSelf = self;
    SettingsSetTextViewController *controller = [[SettingsSetTextViewController alloc] init];
    controller.title = str_Set_Lifespan;
    controller.textFieldPlaceholder = str_Set_Lifespan_Tips1;
    controller.setType = SetLife;
    controller.finishedBlock = ^(NSString *text){
        
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (text.length == 0) {
            [weakSelf alertButtonMessage:str_Set_Lifespan_Tips2];
            return;
        }
        
        if ([text intValue]> 130) {
            [weakSelf alertButtonMessage:str_Set_Lifespan_Tips3];
            return;
        }

        [Config shareInstance].settings.lifespan = text;
        [PlanCache storePersonalSettings:[Config shareInstance].settings];

        [weakSelf.lifeThreeSubView.centerButton setAllTitle:text];
        [self alertToastMessage:str_Save_Success];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setMale
{
    self.sexThreeSubView.centerButton.selected = YES;
    self.sexThreeSubView.rightButton.selected = NO;
    
    [Config shareInstance].settings.gender = @"1";
    
    [PlanCache storePersonalSettings:[Config shareInstance].settings];}

- (void)setFemale
{
    self.sexThreeSubView.centerButton.selected = NO;
    self.sexThreeSubView.rightButton.selected = YES;
    
    [Config shareInstance].settings.gender = @"0";
    
    [PlanCache storePersonalSettings:[Config shareInstance].settings];
}

- (void)setBirthday
{
    UIView *pickerView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerView.backgroundColor = [UIColor clearColor];
    
    {
        UIView *bgView = [[UIView alloc] initWithFrame:pickerView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        [pickerView addSubview:bgView];
    }
    
    {
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.height - kSettingsViewPickerHeight - kSettingsViewToolBarHeight, CGRectGetWidth(pickerView.bounds), kSettingsViewToolBarHeight)];
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.translucent = YES;
        UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithTitle:str_OK style:UIBarButtonItemStylePlain target:nil action:@selector(onPickerCertainBtn)];
        UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem* item3 = [[UIBarButtonItem alloc] initWithTitle:str_Cancel style:UIBarButtonItemStylePlain target:nil action:@selector(onPickerCancelBtn)];
        NSArray* toolbarItems = [NSArray arrayWithObjects:item3, item2, item1, nil];
        [toolbar setItems:toolbarItems];
        [pickerView addSubview:toolbar];
    }
    
    {
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.height - kSettingsViewPickerHeight, CGRectGetWidth(pickerView.bounds), kSettingsViewPickerHeight)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.locale = [NSLocale currentLocale];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.maximumDate = [NSDate date];
        NSDateComponents *defaultComponents = [CommonFunction getDateTime:[NSDate date]];
        NSDate *minDate = [CommonFunction NSStringDateToNSDate:[NSString stringWithFormat:@"%zd-%zd-%zd",
                                                                 defaultComponents.year - 100,
                                                                 defaultComponents.month,
                                                                 defaultComponents.day]
                                                      formatter:@"yyyy-MM-dd"];

        picker.minimumDate = minDate;
        [pickerView addSubview:picker];
        self.datePicker = picker;
        
        NSString *birthday = [Config shareInstance].settings.birthday;
        
        if (birthday) {
            NSDate *date = [CommonFunction NSStringDateToNSDate:birthday formatter:@"yyyy-MM-dd"];
            if (date) {
                [self.datePicker setDate:date animated:YES];
            }
        } else {
            NSDate *defaultDate = [CommonFunction NSStringDateToNSDate:[NSString stringWithFormat:@"%zd-%zd-%zd",
                                                                         defaultComponents.year - 20,
                                                                         defaultComponents.month,
                                                                         defaultComponents.day]
                                                              formatter:@"yyyy-MM-dd"];
            self.datePicker.date = defaultDate;
        }
    }
    
    pickerView.tag = kSettingsViewPickerBgViewTag;
    [self.view addSubview:pickerView];
}

- (void)onPickerCertainBtn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *birthday = [dateFormatter stringFromDate:self.datePicker.date];
    
    [Config shareInstance].settings.birthday = birthday;
    
    if (birthday.length == 0) {
        birthday = str_Settings_Birthday_Tips;
    }
    [self.birthThreeSubView.centerButton setAllTitle:birthday];
    
    UIView *pickerView = [self.view viewWithTag:kSettingsViewPickerBgViewTag];
    [pickerView removeFromSuperview];
    
    [Config shareInstance].settings.birthday = birthday;
    
    [PlanCache storePersonalSettings:[Config shareInstance].settings];
}

- (void)onPickerCancelBtn
{
    UIView *pickerView = [self.view viewWithTag:kSettingsViewPickerBgViewTag];
    [pickerView removeFromSuperview];
}

- (void)saveAvatar:(UIImage *)icon
{
    if (icon == nil) {
        return;
    }
    
    self.avatarView.image = icon;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFit;

    [[Config shareInstance] saveAvatar:icon];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kSettingsViewAlertTagForSetNickName) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (alertView.tag == kSettingsViewAlertTagForSetLife){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==[actionSheet cancelButtonIndex]) {
        
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:str_Settings_SetAvatar_Camera]) {
        //拍照
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:str_Settings_SetAvatar_Album]) {
        //从相册选择
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self saveAvatar:image];
}


@end
