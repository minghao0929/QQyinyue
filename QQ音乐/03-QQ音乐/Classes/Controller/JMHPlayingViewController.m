//
//  JMHPlayingViewController.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/1.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHPlayingViewController.h"
#import "Masonry.h"
#import "JMHAudioTool.h"
#import "JMHMusicTool.h"
#import "MJExtension.h"
#import "JMHMusic.h"
#import "NSString+JMHTimeExtension.h"
#import "JMHLRCTool.h"
#import "JMHLrcView.h"
#import "JMHLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define JMHColor(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface JMHPlayingViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;

@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
@property (strong, nonatomic) JMHMusic *currentMusic;
@property (strong, nonatomic) AVAudioPlayer *currentPlayer;

/** 进度的Timer */
@property (strong, nonatomic) NSTimer *timer;
/** 歌词更新的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

@property (weak, nonatomic) IBOutlet JMHLrcView *lrcScrollView;
@property (weak, nonatomic) IBOutlet JMHLrcLabel *lrcLabel;


@end

@implementation JMHPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.1.添加毛玻璃效果
    [self setupBlurView];
    
    // 2.设置滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.展示界面的信息
    [self setupMusicInfo];
    
    // 4. 设置歌曲AlbumView动画
    [self setupAlbumViewAnimation];
    
    // 5. 设置歌词界面
    [self setupLrcScrollView];


    
}

- (void)viewWillLayoutSubviews
{
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 8.0;
    self.iconView.layer.borderColor = JMHColor(36, 36, 36).CGColor;
}

// 设置毛玻璃效果
- (void)setupBlurView
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlack];
    [self.albumView addSubview:toolbar];
//    toolbar.frame =self.albumView.frame;
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumView.mas_top);
        make.left.equalTo(self.albumView.mas_left);
        make.right.equalTo(self.albumView.mas_right);
        make.bottom.equalTo(self.albumView.mas_bottom);
    }];
}

// 设置播放歌曲信息
- (void)setupMusicInfo
{
    // 1. 设置歌曲基本信息
    JMHMusic *music = [JMHMusicTool playingMusic];

    self.iconView.image = [UIImage imageNamed:music.icon];
    self.songName.text = music.name;
    self.singerName.text = music.singer;

    self.currentMusic = music;
    
    self.lrcScrollView.lrcName = self.currentMusic.lrcname;
    self.lrcScrollView.lrcLabel = self.lrcLabel;


    // 2. 设置歌曲进度条信息
    [self setupProgressInfo];

}

// 设置歌曲AlbumView动画
- (void)setupAlbumViewAnimation
{
    // 1. 创建基本动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation.z";
    
    // 2. 设置基本动画属性
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2);
    anim.repeatCount = NSIntegerMax;
    anim.duration = 40;
    
    // 3. 添加动画到图层上
    [self.iconView.layer addAnimation:anim forKey:nil];
    
    
}

// 设置歌词界面
- (void)setupLrcScrollView
{
    self.lrcScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcScrollView.showsHorizontalScrollIndicator = NO;
    
}

// 设置歌曲进度条信息
- (void)setupProgressInfo
{
    self.currentPlayer = [JMHAudioTool playerWithMusicName:self.currentMusic.filename];

    self.currentTime.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.totalTime.text = [NSString stringWithTime:self.currentPlayer.duration];
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;

    self.lrcScrollView.duration = self.currentPlayer.duration ;
    [self setupLockScreenInfo];
    
    [self.progressSlider addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(progressSliderClick:)]];
    

    [self removeProgressTimer];
    [self addProgressTimer];
    
    
    [self removeLrcTimer];
    [self addLrcTimer];
    

    
}

#pragma mark - 更新歌曲进度条
- (void)updateProgressInfo
{
    self.currentTime.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
    
}

- (void)addProgressTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 更新歌词
- (void)updateLrc
{
    self.lrcScrollView.currentTime = self.currentPlayer.currentTime;
}

- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

- (void)progressSliderClick:(UITapGestureRecognizer *)sender
{
//    [self.timer invalidate];
    CGFloat x = [sender locationInView:self.progressSlider].x;
    CGFloat ratio = x / self.progressSlider.bounds.size.width;
    
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    
    [self updateProgressInfo];
    
}
- (IBAction)startSlide:(id)sender {
    
    [self removeProgressTimer];
}
- (IBAction)sliderValueChange:(id)sender {
    
    // 设置当前播放的时间Label
    self.currentTime.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}
- (IBAction)endSlide:(id)sender {
    
    // 1.设置歌曲的播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    [self updateProgressInfo];
    
    // 2.
    [self addProgressTimer];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - 音乐播放功能 
- (IBAction)previousSong:(id)sender {
    
    // 1. 取出上一首歌
    JMHMusic *previousMusic = [JMHMusicTool previousMusic];
    
    // 2. 播放上一首歌
    [self playingMusicWithMusic:previousMusic];

    
}

- (IBAction)playOrPause:(id)sender {
    
    self.playOrPause.selected = !self.playOrPause.isSelected;
    
    JMHMusic *currentMusic = self.currentMusic;
    
    if (self.playOrPause.isSelected) {
        
        [self.currentPlayer play];
        
    }else{
        [JMHAudioTool pauseMusicWithMusicName:currentMusic.filename];
    }
}

- (IBAction)nextSong:(id)sender {
 
    // 1.取出下一首歌曲
    JMHMusic *nextMusic = [JMHMusicTool nextMusic];
   
    // 2. 播放下一首歌
    [self playingMusicWithMusic:nextMusic];
}

- (void)playingMusicWithMusic:(JMHMusic *)music
{
    // 停止当前播放器
    [JMHAudioTool stopMusicWithMusicName:self.currentMusic.filename];
    
    // 更新界面musci信息
    [self setupMusicInfo];
    self.playOrPause.selected = YES;
    
    // 更新当前播放器
    self.currentPlayer = [JMHAudioTool playMusicWithMusicName:music.filename];
    self.currentPlayer.delegate = self;

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    CGFloat ratio = 1 - point.x / self.lrcScrollView.bounds.size.width;
    
    self.iconView.alpha = ratio;
    self.lrcLabel.alpha = ratio;
}

#pragma mark - <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextSong:nil];
    }
}
#pragma mark - 设置锁屏界面的信息
- (void)setupLockScreenInfo
{

    
    // 1.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2. 设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    [playingInfo setObject:self.currentMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:self.currentMusic.singer forKey:MPMediaItemPropertyArtist];
    
    
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.currentMusic.icon]];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    
    [playingInfo setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [playingInfo setObject:@(self.currentPlayer.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    playingInfoCenter.nowPlayingInfo = playingInfo;
    
    // 3. 让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

// 监听远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause:nil];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextSong:nil];
            
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousSong:nil];
            
            break;
        default:
            break;
    }
}
@end
