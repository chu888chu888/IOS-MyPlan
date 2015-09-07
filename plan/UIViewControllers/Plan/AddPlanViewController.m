//
//  AddPlanViewController.m
//  plan
//
//  Created by Fengzy on 15/8/30.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCache.h"
#import "AddPlanViewController.h"

NSUInteger const kEdgeInset = 10;

@interface AddPlanViewController ()<UITextFieldDelegate, UITextViewDelegate>{
    
    NSUInteger yOffset;
}

@property (strong, nonatomic) UITextField *textNoteTitle;
@property (strong, nonatomic) UITextView *textNoteDetail;

@end

@implementation AddPlanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.operationType == Add) {
        self.title = str_Plan_Add;
    } else {
        self.title = str_Plan_Edit;
    }
    
    [self showRightButtonView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadCustomView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showRightButtonView{
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    {
        UIImage *image = [UIImage imageNamed:png_Btn_Save];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
        [button setAllImage:image];
        [button addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [rightBarButtonItems addObject:barButtonItem];
    }
    
    self.rightBarButtonItems = rightBarButtonItems;
}

- (void)loadCustomView{
    yOffset = kEdgeInset;
    {
        UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(kEdgeInset, yOffset, WIDTH_FULL_SCREEN - kEdgeInset * 2, HEIGHT_FULL_SCREEN / 3)];
        detailTextView.backgroundColor = [UIColor clearColor];
        detailTextView.layer.borderWidth = 1;
        detailTextView.layer.borderColor = [color_GrayLight CGColor];
        detailTextView.layer.cornerRadius = 5;
        detailTextView.font = font_Normal_18;
        detailTextView.textColor = color_Black;
        detailTextView.delegate = self;
        [detailTextView becomeFirstResponder];
        
        [self.view addSubview:detailTextView];
        
        yOffset += HEIGHT_FULL_SCREEN / 3 + kEdgeInset;
        
        self.textNoteDetail = detailTextView;
    }
    
    {
        NSInteger labelWidth = 60;
        NSInteger labelHeight = 30;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeInset, yOffset, labelWidth, labelHeight)];
        label.text = str_Notify_Tips1;
        label.textColor = color_Black;
        label.font = font_Normal_18;
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kEdgeInset + labelWidth, yOffset, 20, labelHeight)];
        [switchButton setOn:NO];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:label];
        [self.view addSubview:switchButton];
    }
    
    if (self.operationType == Edit) {
        self.textNoteDetail.text = self.plan.content;
    }
}

#pragma mark - action
- (void)rightAction:(UIButton *)button{;
    NSString *title = [self.textNoteTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *detail = [self.textNoteDetail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (title.length == 0 && detail.length == 0) {
        [self alertButtonMessage:str_Plan_NoContent];
        return;
    }
    [self savePlan];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {

    }else {

    }
}

- (void)savePlan {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *timeNow = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter*idFormatter = [[NSDateFormatter alloc]init];//格式化
    [idFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* planid = [idFormatter stringFromDate:[NSDate date]];
    
    if (self.operationType == Add) {
        self.plan = [[Plan alloc]init];
        self.plan.planid = planid;
        self.plan.createtime = timeNow;
        self.plan.iscompleted = @"0";
    } else {
        self.plan.updatetime = timeNow;
    }
    
    self.plan.content = self.textNoteDetail.text;
    self.plan.plantype = self.planType == PlanEveryday ? @"1" : @"0";
    
    [PlanCache storePlan:self.plan];
    
    if (self.finishBlock) {
        self.finishBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
