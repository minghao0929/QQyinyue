//
//  NSString+JMHTimeExtension.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/2.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "NSString+JMHTimeExtension.h"

@implementation NSString (JMHTimeExtension)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger second = (int)time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",min,second];
}
@end
