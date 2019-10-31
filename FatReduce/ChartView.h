//
//  ChartView.h
//  FatReduce
//
//  Created by xzm on 2019/10/30.
//  Copyright © 2019 xzm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define W(x) CGRectGetWidth(x.bounds)
#define H(x) CGRectGetHeight(x.bounds)

NS_ASSUME_NONNULL_BEGIN

@interface ChartView : UIView

@property (nonatomic,strong) void(^clickFlagBlock)(NSDictionary *dataDic);

- (void)setDataArray:(NSArray *)dataArray;
- (void)selectLastPoint;

@end

NS_ASSUME_NONNULL_END
