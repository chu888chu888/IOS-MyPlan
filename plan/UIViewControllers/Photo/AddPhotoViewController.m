//
//  AddPhotoViewController.m
//  plan
//
//  Created by Fengzy on 15/10/6.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCache.h"
#import "PageScrollView.h"
#import "AddPhotoViewController.h"

NSUInteger const photoMax = 9;
NSUInteger const pageHeight = 148;
NSUInteger const pageWidth = 110;
NSUInteger const kAddPhotoViewPickerHeight = 216;
NSUInteger const kAddPhotoViewToolBarHeight = 44;
NSUInteger const kAddPhotoViewPickerBgViewTag = 20151006;
NSUInteger const kAddPhotoViewPhotoStartTag = 20151007;
NSUInteger const kAddPhotoViewPhotoDateTextFieldTag = 20151011;

@interface AddPhotoViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PageScrollViewDataSource, PageScrollViewDelegate>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, weak) PageScrollView *pageScrollView;
@property (nonatomic, weak) UILabel *tipsLabel;

@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.operationType == Add) {
        self.title = str_Photo_Add;
    } else {
        self.title = str_Photo_Edit;
    }
    
    self.photoArray = [NSMutableArray array];
    
    [self showRightButtonView];
    [self loadCustomView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self relocationPage];
    
}

- (void)showRightButtonView {
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:png_Btn_Save];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
    [button setAllImage:image];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [rightBarButtonItems addObject:barButtonItem];
    
    self.rightBarButtonItems = rightBarButtonItems;
}

- (void)loadCustomView {
    
    self.labelTime.text = str_Photo_Date;
    self.labelLocation.text = str_Photo_Location;
    //描述
    if (self.operationType == Edit
        && self.photo.content
        && self.photo.content.length > 0) {
        
        self.textViewContent.textColor = color_333333;
        self.textViewContent.text = self.photo.content;
        
    } else {
        
        self.textViewContent.textColor = color_8f8f8f;
        self.textViewContent.text = str_Photo_Add_Tips1;
    }
    self.textViewContent.inputAccessoryView = [self getInputAccessoryView];
    self.textViewContent.delegate = self;
    //时间
    if (self.photo.phototime
        && self.photo.phototime.length > 0) {
        
        self.textFieldTime.text = self.photo.phototime;
        
    } else {
        
        self.textFieldTime.text = [CommonFunction NSDateToNSString:[NSDate date] formatter:str_DateFormatter_yyyy_MM_dd];
        
    }
    [self.textFieldTime addTarget:self action:@selector(setPhotoTime) forControlEvents:UIControlEventTouchDown];
    self.textFieldTime.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.textFieldTime.delegate = self;
    //地点
    if (self.operationType == Edit
        && self.photo.location
        && self.photo.location.length > 0) {
        
        self.textFieldLocation.text = self.photo.location;
        
    }
    self.textFieldLocation.inputAccessoryView = [self getInputAccessoryView];
    self.textFieldLocation.placeholder = str_Photo_Add_Tips7;
    //照片
    UIImage *addImage = [UIImage imageNamed:png_Btn_AddPhoto];
    if (self.operationType == Edit) {
        
        self.photoArray = [NSMutableArray arrayWithArray:self.photo.photoArray];
        
        if (self.photoArray.count < photoMax) {
            
            [self.photoArray addObject:addImage];
        }
        
    } else {
        
        [self.photoArray addObject:addImage];
        
    }
    
    CGFloat tipsHeight = 30;
    CGFloat photoViewHeight = HEIGHT_FULL_SCREEN / 2;
    CGFloat yEdgeInset = (photoViewHeight - pageHeight - tipsHeight - 44) / 2;

    PageScrollView *pageScrollView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, yEdgeInset, WIDTH_FULL_SCREEN, pageHeight) pageWidth:pageWidth pageDistance:10];
    pageScrollView.holdPageCount = 5;
    pageScrollView.dataSource = self;
    pageScrollView.delegate = self;
    [self.viewPhoto addSubview:pageScrollView];
    self.pageScrollView = pageScrollView;
    
    CGFloat labelYOffset = CGRectGetMaxY(pageScrollView.frame);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelYOffset, WIDTH_FULL_SCREEN, tipsHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = font_Normal_16;
    label.textColor = color_8f8f8f;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str_Photo_Add_Tips4;
    [self.viewPhoto addSubview:label];
    self.tipsLabel = label;
    
}

- (void)setPhotoTime {
    
    [self.textFieldTime resignFirstResponder];
    
    UIView *pickerView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerView.backgroundColor = [UIColor clearColor];
    
    {
        UIView *bgView = [[UIView alloc] initWithFrame:pickerView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        [pickerView addSubview:bgView];
    }
    {
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.height - kAddPhotoViewPickerHeight - kAddPhotoViewToolBarHeight, CGRectGetWidth(pickerView.bounds), kAddPhotoViewToolBarHeight)];
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
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.height - kAddPhotoViewPickerHeight, CGRectGetWidth(pickerView.bounds), kAddPhotoViewPickerHeight)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.locale = [NSLocale currentLocale];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.maximumDate = [NSDate date];
        NSDateComponents *defaultComponents = [CommonFunction getDateTime:[NSDate date]];
        NSDate *minDate = [CommonFunction NSStringDateToNSDate:[NSString stringWithFormat:@"%zd-%zd-%zd",
                                                                defaultComponents.year - 100,
                                                                defaultComponents.month,
                                                                defaultComponents.day]
                                                     formatter:str_DateFormatter_yyyy_MM_dd];
        
        picker.minimumDate = minDate;
        [pickerView addSubview:picker];
        self.datePicker = picker;
        
        NSString *photoDate = self.textFieldTime.text;
        
        if (photoDate) {
            
            NSDate *date = [CommonFunction NSStringDateToNSDate:photoDate formatter:str_DateFormatter_yyyy_MM_dd];
            if (date) {
                
                [self.datePicker setDate:date animated:YES];
            }
            
        } else {
            
            NSDate *defaultDate = [CommonFunction NSStringDateToNSDate:[NSString stringWithFormat:@"%zd-%zd-%zd",
                                                                        defaultComponents.year,
                                                                        defaultComponents.month,
                                                                        defaultComponents.day]
                                                             formatter:str_DateFormatter_yyyy_MM_dd];
            self.datePicker.date = defaultDate;
        }
    }
    
    pickerView.tag = kAddPhotoViewPickerBgViewTag;
    [self.view addSubview:pickerView];
}

- (void)onPickerCertainBtn {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:str_DateFormatter_yyyy_MM_dd];
    NSString *photoTime = [dateFormatter stringFromDate:self.datePicker.date];

    self.textFieldTime.text = photoTime;

    UIView *pickerView = [self.view viewWithTag:kAddPhotoViewPickerBgViewTag];
    [pickerView removeFromSuperview];
    
}

- (void)onPickerCancelBtn {
    
    UIView *pickerView = [self.view viewWithTag:kAddPhotoViewPickerBgViewTag];
    [pickerView removeFromSuperview];
    
}

#pragma mark - action
- (void)saveAction:(UIButton *)button {
    
    if (self.photoArray.count < 2) {
        
        [self alertButtonMessage:str_Photo_Add_Tips5];
        return;
    }
    
    NSString *timeNow = [CommonFunction getTimeNowString];
    NSString* photoid = [CommonFunction NSDateToNSString:[NSDate date] formatter:str_DateFormatter_yyyyMMddHHmmss];
    
    if (self.operationType == Add) {
        
        self.photo = [[Photo alloc] init];
        self.photo.photoid = photoid;
        self.photo.createtime = timeNow;

    } else {
        
        self.photo.updatetime = timeNow;
    }
    if (![self.textViewContent.text isEqualToString:str_Photo_Add_Tips1]) {
        
        self.photo.content = self.textViewContent.text;
        
    }
    self.photo.phototime = self.textFieldTime.text;
    if (self.textFieldLocation.text.length > 0) {
        
        self.photo.location = self.textFieldLocation.text;
        
    }
    //去掉那张新增按钮图
    [self.photoArray removeObjectAtIndex:self.photoArray.count - 1];
    self.photo.photoArray = self.photoArray;
    
    BOOL result = [PlanCache storePhoto:self.photo];
    if (result) {
        
        [self alertToastMessage:str_Save_Success];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self alertButtonMessage:str_Save_Fail];
    }

}

- (void)relocationPage {
    
    NSUInteger addIndex = self.photoArray.count > 1 ? self.photoArray.count - 2 : self.photoArray.count - 1;
    [self.pageScrollView scrollToPage:addIndex animated:YES];
    
}

- (UIView *)getInputAccessoryView {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    NSMutableArray *items = [NSMutableArray array];
    {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:barButtonItem];
    }
    
    {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endInputAction:)];
        [items addObject:barButtonItem];
    }
    
    toolBar.items = items;
    
    return toolBar;
}

- (void)endInputAction:(UIBarButtonItem *)barButtonItem {
    
    [self.view endEditing:YES];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text isEqualToString:str_Photo_Add_Tips1]) {
        textView.text = @"";
        textView.textColor = color_333333;
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        textView.text = str_Photo_Add_Tips1;
        textView.textColor = color_8f8f8f;
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.textViewContent resignFirstResponder];
    [self.textFieldLocation resignFirstResponder];
    return NO;
    
}

- (void)tapAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    NSInteger index = tapGestureRecognizer.view.tag - kAddPhotoViewPhotoStartTag;
    
    if (index != self.pageScrollView.currentPage) {
        
        [self.pageScrollView scrollToPage:index animated:YES];

    }
    
    if (index == self.photoArray.count - 1
        && index < photoMax) {
        
        [self addPhoto];
        
    }
}

- (NSUInteger)numberOfPagesInPageScrollView:(PageScrollView *)pageScrollView {

    return self.photoArray.count;
    
}

- (UIView *)pageScrollView:(PageScrollView *)pageScrollView cellForPageIndex:(NSUInteger)index {
    
    UIImage *photo = self.photoArray[index];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.tag = kAddPhotoViewPhotoStartTag + index;
    imageView.image = photo;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    if (index != (self.photoArray.count - 1)) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor = color_ff0000_06;
        btn.frame = CGRectMake((pageWidth - 30) / 2, pageHeight - 30 - 5, 30, 30);
        btn.layer.cornerRadius = 15;
        btn.tag = index;
        [btn setBackgroundImage:[UIImage imageNamed:png_Btn_Photo_Delete] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btn];

    }
    
    return imageView;
}

- (void)pageScrollView:(PageScrollView *)pageScrollView didScrollToPage:(NSInteger)pageNumber {

    if (self.photoArray.count == 1) {
        
        self.tipsLabel.text = str_Photo_Add_Tips4;
        
    } else if (self.photoArray.count > 1) {
    
        long selectedCount = self.photoArray.count - 1;
        long canSelectCount = photoMax - selectedCount;
        self.tipsLabel.text = [NSString stringWithFormat:str_Photo_Add_Tips6, selectedCount, canSelectCount];
        
    }
    
}

- (void)addPhoto {

    //从相册选择
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    } else {
        
        [self alertButtonMessage:str_Common_Tips1];
        
    }
}

- (void)deletePhoto:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    [self.photoArray removeObjectAtIndex:index];
    
    UIImage *addImage = [UIImage imageNamed:png_Btn_AddPhoto];
    NSInteger count = self.photoArray.count;
    self.photoArray[count - 1] = addImage;
    
    [self.pageScrollView reloadData];
    [self relocationPage];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.photoArray.count < (photoMax -1)) {
        
        [self.photoArray insertObject:image atIndex:self.photoArray.count - 1];
        
    } else {
        
        self.photoArray[photoMax - 1] = image;
        
    }

    [self.pageScrollView reloadData];
}

@end
