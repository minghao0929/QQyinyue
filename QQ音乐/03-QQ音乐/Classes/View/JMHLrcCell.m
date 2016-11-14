//
//  JMHLrcCell.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/6.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHLrcCell.h"
#import "JMHMusicTool.h"
#import "JMHLRCTool.h"
#import "JMHLRCLine.h"
#import "JMHLrcLabel.h"
#import "Masonry.h"

@implementation JMHLrcCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
     {
         JMHLrcLabel *lrcLabel = [[JMHLrcLabel alloc] init];
         lrcLabel.textColor = [UIColor whiteColor];
         lrcLabel.textAlignment = NSTextAlignmentCenter;
         lrcLabel.font = [UIFont systemFontOfSize:14.0];
         [self.contentView addSubview:lrcLabel];
         _lrcLabel = lrcLabel;
         
         lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
         [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.center.equalTo(self.contentView);
         }];

     }
    return self;
}
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lrcCell";
    JMHLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JMHLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

- (void)setLrcLine:(JMHLRCLine *)lrcLine
{
    _lrcLabel.text = lrcLine.lrcText;
}




@end
