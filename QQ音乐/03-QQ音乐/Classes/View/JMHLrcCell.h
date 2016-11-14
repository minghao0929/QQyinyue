//
//  JMHLrcCell.h
//  03-QQ音乐
//
//  Created by Minghao on 16/10/6.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMHLRCLine;
@class JMHLrcLabel;
@interface JMHLrcCell : UITableViewCell

@property (nonatomic, strong) JMHLRCLine *lrcLine;
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak, readonly) JMHLrcLabel *lrcLabel;

@end
