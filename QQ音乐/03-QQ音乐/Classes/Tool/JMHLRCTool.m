//
//  JMHLRCTool.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/6.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHLRCTool.h"
#import "JMHLRCLine.h"

@implementation JMHLRCTool

+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    // 1.拿到歌词文件的路径
    NSString *lrcPath =  [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    // 2.读取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    
    // 3.拿到歌词的数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    
    // 4.遍历每一句歌词,转成模型
    
    NSMutableArray *temArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArray) {
        
        // 拿到每一句歌词
        /*
         [ti:心碎了无痕]
         [ar:张学友]
         [al:]
         */
        // 过滤不需要的歌词的行
        if ([lrcLineString hasPrefix:@"[ti:"] || [lrcLineString hasPrefix:@"[ar:"] || [lrcLineString hasPrefix:@"[al:"] || ![lrcLineString hasPrefix:@"["])  {
            continue;
        }
        
        // 将歌词转成模型
        JMHLRCLine *lrcLine = [JMHLRCLine lrcLineWithLrcLineString:lrcLineString];
        [temArray addObject:lrcLine];
    }
    
    return temArray;
}
@end
