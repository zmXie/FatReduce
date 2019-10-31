//
//  RecordTableViewController.m
//  FatReduce
//
//  Created by xzm on 2019/10/30.
//  Copyright © 2019 xzm. All rights reserved.
//

#import "RecordTableViewController.h"
#import "UIView+DCKit.h"
#import "UIView+DatePicker.h"

@interface RecordTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dateTf;
@property (weak, nonatomic) IBOutlet UITextField *weightTf;
@property (weak, nonatomic) IBOutlet UITextField *BMITf;
@property (weak, nonatomic) IBOutlet UITextField *fatTf;
@property (weak, nonatomic) IBOutlet UITextField *muscleTf;
@property (weak, nonatomic) IBOutlet UITextField *metaTf;
@property (weak, nonatomic) IBOutlet UITextField *waterTf;
@property (weak, nonatomic) IBOutlet UITextField *fatWeightTf;
@property (weak, nonatomic) IBOutlet UITextField *proteinTf;
@property (weak, nonatomic) IBOutlet UITextField *boneTf;
@property (weak, nonatomic) IBOutlet UITextField *degreaseWeightTf;

@end

@implementation RecordTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.allowsSelection = NO;

    self.dateTf.delegate = self;
    self.dateTf.text = [self stringForDate:[NSDate date]];
    
    if (self.editDic) {
        self.dateTf.text = _editDic[@"date"];
        self.weightTf.text = _editDic[@"weight"];
        self.BMITf.text = _editDic[@"BMI"];
        self.fatTf.text = _editDic[@"fat"];
        self.muscleTf.text = _editDic[@"muscle"];
        self.metaTf.text = _editDic[@"meta"];
        self.waterTf.text = _editDic[@"water"];
        self.fatWeightTf.text = _editDic[@"fatWeight"];
        self.proteinTf.text = _editDic[@"protein"];
        self.boneTf.text = _editDic[@"bone"];
        self.degreaseWeightTf.text = _editDic[@"degreaseWeight"];
    }
}

- (IBAction)completeClick:(id)sender
{
    if (self.dateTf.text.length == 0) {
        [self showToast:self.dateTf.placeholder];
    } else if (self.weightTf.text.length == 0) {
        [self showToast:self.weightTf.placeholder];
    } else if (self.BMITf.text.length == 0) {
        [self showToast:self.BMITf.placeholder];
    } else if (self.fatTf.text.length == 0) {
        [self showToast:self.fatTf.placeholder];
    } else if (self.muscleTf.text.length == 0) {
        [self showToast:self.muscleTf.placeholder];
    } else if (self.metaTf.text.length == 0) {
        [self showToast:self.metaTf.placeholder];
    } else if (self.waterTf.text.length == 0) {
        [self showToast:self.waterTf.placeholder];
    } else if (self.fatWeightTf.text.length == 0) {
        [self showToast:self.fatWeightTf.placeholder];
    } else if (self.proteinTf.text.length == 0) {
        [self showToast:self.proteinTf.placeholder];
    } else if (self.boneTf.text.length == 0) {
        [self showToast:self.boneTf.placeholder];
    } else if (self.degreaseWeightTf.text.length == 0) {
        [self showToast:self.degreaseWeightTf.placeholder];
    } else {
        NSMutableArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:RecordKey];
        if (recordArray) {
            recordArray = recordArray.mutableCopy;
        } else {
            recordArray = @[].mutableCopy;
        }
        if (_editDic) { //编辑
            [recordArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"id"] isEqualToValue:self.editDic[@"id"]]) {
                    [recordArray replaceObjectAtIndex:idx withObject:[self createDataDicWithId:obj[@"id"]]];
                    *stop = YES;
                }
            }];
        } else { //新增
            [recordArray addObject:[self createDataDicWithId:@([[NSDate date] timeIntervalSince1970])]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:recordArray forKey:RecordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        
        !_refreshBlock ?: _refreshBlock();
    }
}

- (NSDictionary *)createDataDicWithId:(NSValue *)valueId
{
    return @{@"id":valueId,
             @"date":self.dateTf.text,
             @"weight":self.weightTf.text,
             @"BMI":self.BMITf.text,
             @"fat":self.fatTf.text,
             @"muscle":self.muscleTf.text,
             @"meta":self.metaTf.text,
             @"water":self.waterTf.text,
             @"fatWeight":self.fatWeightTf.text,
             @"protein":self.proteinTf.text,
             @"bone":self.boneTf.text,
             @"degreaseWeight":self.degreaseWeightTf.text};
}

- (void)showToast:(NSString *)text
{
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:view];

    UILabel *label = [UILabel new];
    label.alpha = 0;
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.text = text;
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.backgroundColor = [UIColor blackColor];
    label.height += 20;
    label.width += 20;
    label.center = view.center;
    [view addSubview:label];

    [UIView animateWithDuration:0.2 animations:^{
        label.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    __weak typeof(self)weakSelf = self;
    [self.view showDatePickerWithFinishBlock:^(NSDate *date) {
        weakSelf.dateTf.text = [weakSelf stringForDate:date];
    }];
    return NO;
}

- (NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    [dateFormatter setLocale:usLocale];
    return [dateFormatter stringFromDate:date];
}

@end
