//
//  JMHLRCLine.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/6.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHLRCLine.h"

@implementation JMHLRCLine

+ (instancetype)lrcLineWithLrcLineString:(NSString *)lrcLineString
{
    JMHLRCLine *lrcLine = [[JMHLRCLine alloc]init];
    
    NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
    
    // 设置lrc的歌词
    lrcLine.lrcText = lrcArray[1];
    
    // 设置lrc的时间
    NSString *timeString = lrcArray[0];

    lrcLine.lrcTime = [lrcLine timeIntervalWithTimeString:[timeString substringFromIndex:1]];

    return lrcLine;
}

- (NSTimeInterval)timeIntervalWithTimeString:(NSString *)timeString
{
    // 01:05.43
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger second = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger haomiao = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return (min * 60 + second + haomiao * 0.01);

}
@end
