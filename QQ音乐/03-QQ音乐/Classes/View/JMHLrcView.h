//
//  JMHLrcView.h
//  03-QQ音乐
//
//  Created by Minghao on 16/10/2.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMHLrcLabel;
@interface JMHLrcView : UIScrollView

@property (assign, nonatomic) NSTimeInterval currentTime;


@property (nonatomic, copy) NSString *lrcName;

/** 外面歌词的Label */
@property (nonatomic, weak) JMHLrcLabel *lrcLabel;
/** 当前歌曲总长度 */
@property (assign, nonatomic) NSTimeInterval duration;

@end
