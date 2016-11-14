//
//  JMHMusicTool.h
//  03-QQ音乐
//
//  Created by Minghao on 16/10/1.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMHMusic;
@interface JMHMusicTool : NSObject

@property (strong, nonatomic) JMHMusic *music;

+ (JMHMusic *)playingMusic;
+ (JMHMusic *)previousMusic;
+ (JMHMusic *)nextMusic;
@end
