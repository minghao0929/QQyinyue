//
//  JMHLRCLine.h
//  03-QQ音乐
//
//  Created by Minghao on 16/10/6.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHLRCLine : NSObject

@property (copy, nonatomic) NSString *lrcText;
@property (assign, nonatomic) NSTimeInterval lrcTime;

+ (instancetype)lrcLineWithLrcLineString:(NSString *)lrcLineString;
@end
