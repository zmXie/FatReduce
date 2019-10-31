//
//  RecordTableViewController.h
//  FatReduce
//
//  Created by xzm on 2019/10/30.
//  Copyright © 2019 xzm. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RecordKey @"RecordKey"

NS_ASSUME_NONNULL_BEGIN

@interface RecordTableViewController : UITableViewController

@property (nonatomic,strong) NSDictionary *editDic;
@property (nonatomic,strong) dispatch_block_t refreshBlock;

@end

NS_ASSUME_NONNULL_END
