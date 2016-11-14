//
//  JMHMusicTool.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/1.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "MJExtension.h"
#import "JMHMusic.h"

@implementation JMHMusicTool

static NSArray *_musics;
static JMHMusic *_playingMusic;

+ (void)initialize
{
    if (_musics == nil) {
        _musics = [JMHMusic objectArrayWithFilename:@"Musics.plist"];
    }
    
    if (_playingMusic == nil) {
        _playingMusic = _musics[1];
    }
}

+ (JMHMusic *)playingMusic
{
    return _playingMusic;
}

+ (JMHMusic *)previousMusic
{
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    if (currentIndex == 0) {
        currentIndex = _musics.count - 1;
    }else{
        currentIndex -= 1;
    }
    
    _playingMusic = _musics[currentIndex];
    return _playingMusic;
}
+ (JMHMusic *)nextMusic
{
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    if (currentIndex == (_musics.count - 1)) {
        currentIndex = 0;
    }else{
        currentIndex += 1;
    }
    
    _playingMusic = _musics[currentIndex];
    
    return _playingMusic;
}

@end
