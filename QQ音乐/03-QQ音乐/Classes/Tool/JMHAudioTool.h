//
//  JMHAudioTool.h
//  03-播放音效
//
//  Created by Minghao on 16/9/30.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JMHAudioTool : NSObject

#pragma mark - 音效播放
// 播放声音文件soundName : 音效文件的名称
+ (void)playSoundWithSoundName:(NSString *)soundName;

#pragma mark - 播放音乐
// 获取播放器 musicName : 音乐的名称
+ (AVAudioPlayer *)playerWithMusicName:(NSString *)musicName;
// 播放音乐 musicName : 音乐的名称
+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName;
// 暂停音乐 musicName : 音乐的名称
+ (void)pauseMusicWithMusicName:(NSString *)musicName;
// 停止音乐 musicName : 音乐的名称
+ (void)stopMusicWithMusicName:(NSString *)musicName;




@end
