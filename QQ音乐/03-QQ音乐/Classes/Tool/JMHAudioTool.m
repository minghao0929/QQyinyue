//
//  JMHAudioTool.m
//  03-播放音效
//
//  Created by Minghao on 16/9/30.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHAudioTool.h"
#import <AVFoundation/AVFoundation.h>

static SystemSoundID sounID;

@implementation JMHAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;


+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

#pragma mark - 音效的播放
+ (void)playSoundWithSoundName:(NSString *)soundName
{
    SystemSoundID soundID = 0;
    
    // 2. 从字典中取出对应的soundID，如果取出是nil，表示之前没有存放字典
    soundID = [_soundIDs[soundName] unsignedIntValue];
    
    if (soundID == 0)
    {
        CFURLRef url = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:soundName withExtension:nil]);
        
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        [_soundIDs setObject:@(soundID) forKey:soundName];
        
    }
    
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - 音频文件的播放
+ (AVAudioPlayer *)playerWithMusicName:(NSString *)musicName
{
    // 1.定义播放器
    AVAudioPlayer *player = nil;
    
    // 2.从字典中取player,如果取出出来是空,则对应创建对应的播放器
    player = _players[musicName];
    
    if (player == nil) {
        
        // 2.1.获取对应音乐资源
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        if (url == nil)  return nil;
        
        // 2.2.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.3.将player存入字典中
        [_players setObject:player forKey:musicName];
        
        // 2.4.准备播放
        [player prepareToPlay];
    }

    return player;
}

+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName
{

    // 1.定义播放器
    AVAudioPlayer *player = nil;
    
    // 2.从字典中取player,如果取出出来是空,则对应创建对应的播放器
    player = _players[musicName];
    
    if (player == nil) {
        
        // 2.1.获取对应音乐资源
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        if (url == nil)  return nil;
        
        // 2.2.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.3.将player存入字典中
        [_players setObject:player forKey:musicName];
        
        // 2.4.准备播放
        [player prepareToPlay];
    }
    // 3.播放音乐
    [player play];
    
    return player;
}
+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    // 1.取出对应的播放
    AVAudioPlayer *player = _players[musicName];
    
    // 2.判断player是否nil
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    // 1.取出对应的播放
    AVAudioPlayer *player = _players[musicName];
    
    // 2.判断player是否nil
    if (player) {
        [player stop];
        [_players removeObjectForKey:musicName];
        player = nil;
    }
}
@end
