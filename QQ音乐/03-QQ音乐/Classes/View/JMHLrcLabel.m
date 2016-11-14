//
//  JMHLrcLabel.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/9.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHLrcLabel.h"

@implementation JMHLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1. 获取需要画的区域
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
    // 2. 设置颜色
    [[UIColor redColor] set];
    
    // 3. 添加区域
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}
@end
