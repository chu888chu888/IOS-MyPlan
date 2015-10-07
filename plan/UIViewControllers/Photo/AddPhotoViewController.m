//
//  AddPhotoViewController.m
//  plan
//
//  Created by Fengzy on 15/10/6.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PageScrollView.h"
#import "AddPhotoViewController.h"

NSUInteger const kAddPhotoViewPickerHeight = 216;
NSUInteger const kAddPhotoViewToolBarHeight = 44;
NSUInteger const kAddPhotoViewPickerBgViewTag = 20151006;
NSUInteger const kAddPhotoViewPhotoStartTag = 20151007;

@interface AddPhotoViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PageScrollViewDataSource, PageScrollViewDelegate>

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
    
    UIImage *addImage = [UIImage imageNamed:@"LaunchImage"];
    
    [self.photoArray addObject:addImage];
    
    self.textViewContent.textColor = color_8f8f8f;
    self.textViewContent.text = str_Photo_Add_Tips1;
    self.textViewContent.inputAccessoryView = [self getInputAccessoryView];
    self.textViewContent.delegate = self;
    [self.textFieldTime addTarget:self action:@selector(setPhotoTime) forControlEvents:UIControlEventTouchDown];
    self.textFieldLocation.inputAccessoryView = [self getInputAccessoryView];

    CGFloat yEdgeInset = 5;
    CGFloat tipsHeight = 30;
    CGFloat photoViewHeight = HEIGHT_FULL_SCREEN / 2;//self.viewPhoto.frame.size.height;
    CGFloat pageHeight = photoViewHeight - yEdgeInset * 3 - tipsHeight;
    CGFloat pageWidth = pageHeight * 0.382;
    PageScrollView *pageScrollView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, yEdgeInset, WIDTH_FULL_SCREEN, pageHeight) pageWidth:pageWidth pageDistance:10];
    pageScrollView.holdPageCount = 5;
    pageScrollView.dataSource = self;
    pageScrollView.delegate = self;
    [self.viewPhoto addSubview:pageScrollView];
    self.pageScrollView = pageScrollView;
    
    CGFloat labelYOffset = CGRectGetMaxY(pageScrollView.frame);// + yEdgeInset;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelYOffset, WIDTH_FULL_SCREEN, tipsHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = font_Normal_16;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"还可以选择9张";
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
        
//        NSString *birthday = [Config shareInstance].settings.birthday;
//        
//        if (birthday) {
//            NSDate *date = [CommonFunction NSStringDateToNSDate:birthday formatter:str_DateFormatter_yyyy_MM_dd];
//            if (date) {
//                [self.datePicker setDate:date animated:YES];
//            }
//        } else {
//            NSDate *defaultDate = [CommonFunction NSStringDateToNSDate:[NSString stringWithFormat:@"%zd-%zd-%zd",
//                                                                        defaultComponents.year - 20,
//                                                                        defaultComponents.month,
//                                                                        defaultComponents.day]
//                                                             formatter:str_DateFormatter_yyyy_MM_dd];
//            self.datePicker.date = defaultDate;
//        }
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
    
//    NSString *title = [self.textNoteTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *detail = [self.textNoteDetail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (title.length == 0 && detail.length == 0) {
//        [self alertButtonMessage:str_Plan_NoContent];
//        return;
//    }
//    [self savePlan];
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
        textView.textColor = [UIColor blackColor];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        textView.text = str_Photo_Add_Tips1;
        textView.textColor = color_8f8f8f;
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    NSInteger index = tapGestureRecognizer.view.tag - kAddPhotoViewPhotoStartTag;
    
    if (index != self.pageScrollView.currentPage) {
        
        [self.pageScrollView scrollToPage:index animated:YES];

    }
    
    if (index == self.photoArray.count - 1) {
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
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    return imageView;
}

- (void)pageScrollView:(PageScrollView *)pageScrollView didScrollToPage:(NSInteger)pageNumber {

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
        
        //不支持相片选取，请去设置里面赋予权限
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.photoArray addObject:image];
}

@end
