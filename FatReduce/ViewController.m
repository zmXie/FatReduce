//
//  ViewController.m
//  FatReduce
//
//  Created by xzm on 2019/10/30.
//  Copyright © 2019 xzm. All rights reserved.
//

#import "ViewController.h"
#import "RecordTableViewController.h"
#import "ChartView.h"

@interface ViewController ()
{
    UIButton *_lastSelectBtn;
}

@property (nonatomic,strong) ChartView * chartView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    NSArray *array = @[@"重量",@"BMI",@"脂肪",@"肌肉",@"基础代谢率",@"水分",@"脂肪重量",@"蛋白质",@"骨量",@"去脂体重"];
    CGFloat s = 10, h = 35;
    CGFloat w = (W(self.view) - s*6)/5.f;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(s+(w+s)*(idx%5), s+(h+s)*(idx/5), w, h)];
        [btn setTitle:obj forState:0];
        [btn setTitleColor:RGB(102, 102, 102) forState:0];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.layer.cornerRadius = 5;
        [self.view addSubview:btn];
        btn.tag = idx+100;
        btn.backgroundColor = idx == 0 ? RGB(4, 179, 139) : RGB(245, 245, 245);
        btn.selected = idx == 0;
        if (idx == 0) {
            [self change:btn];
        }
    }];
    
    [self.view addSubview:self.chartView];
    
    NSArray *records = [[NSUserDefaults standardUserDefaults] objectForKey:RecordKey];
    if (records.count == 0) {
        [self pushRecord:NO editDic:nil];
    }
}

- (IBAction)addRecord:(id)sender
{
    [self pushRecord:YES editDic:nil];
}

- (void)pushRecord:(BOOL)animated editDic:(NSDictionary *)editDic
{
    RecordTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecordTableViewController"];
    vc.editDic = editDic;
    vc.refreshBlock = ^{
        [self refreshWithIndex:self->_lastSelectBtn.tag-100];
    };
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)change:(UIButton *)btn
{
    if (_lastSelectBtn != btn) {
        btn.selected = YES;
        btn.backgroundColor = RGB(4, 179, 139);
        _lastSelectBtn.selected = NO;
        _lastSelectBtn.backgroundColor = RGB(245, 245, 245);
        _lastSelectBtn = btn;
        [self refreshWithIndex:btn.tag - 100];
    }
}

- (void)refreshWithIndex:(NSInteger)index
{
    NSString *key,*type;
    switch (index) {
        case 0:
            key = @"weight";
            type = @"斤";
            break;
        case 1:
            key = @"BMI";
            type = @"";
            break;
        case 2:
            key = @"fat";
            type = @"%";
            break;
        case 3:
            key = @"muscle";
            type = @"%";
            break;
        case 4:
            key = @"meta";
            type = @"大卡/天";
            break;
        case 5:
            key = @"water";
            type = @"%";
            break;
        case 6:
            key = @"fatWeight";
            type = @"斤";
            break;
        case 7:
            key = @"protein";
            type = @"%";
            break;
        case 8:
            key = @"bone";
            type = @"%";
            break;
        case 9:
            key = @"degreaseWeight";
            type = @"斤";
            break;
            
        default:
            break;
    }
    NSMutableArray *dataArray = @[].mutableCopy;
    NSArray *records = [[NSUserDefaults standardUserDefaults] objectForKey:RecordKey];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    if (descriptor) {
        records = [records sortedArrayUsingDescriptors:@[descriptor]];
    }
    [records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setObject:obj[key] forKey:@"value"];
        [dic setObject:obj[@"date"] forKey:@"time"];
        [dic setObject:type forKey:@"type"];
        [dic setObject:obj forKey:@"origin"];
        [dataArray addObject:dic];
    }];
    [self.chartView setDataArray:dataArray];
}

- (ChartView *)chartView
{
    if (!_chartView) {
        _chartView = [[ChartView alloc]initWithFrame:CGRectMake(0, 130, W(self.view), 300)];
        __weak typeof(self)weakSelf = self;
        _chartView.clickFlagBlock = ^(NSDictionary * _Nonnull dataDic) {
            [weakSelf pushRecord:YES editDic:dataDic[@"origin"]];
        };
    }
    return _chartView;
}

@end
