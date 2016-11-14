//
//  JMHLrcView.m
//  03-QQ音乐
//
//  Created by Minghao on 16/10/2.
//  Copyright © 2016年 Minghao. All rights reserved.
//

#import "JMHLrcView.h"
#import "JMHMusicTool.h"
#import "JMHLRCTool.h"
#import "JMHLrcCell.h"
#import "JMHMusic.h"
#import "JMHLRCLine.h"
#import "JMHLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface JMHLrcView()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** lrcArray */
@property (nonatomic, strong) NSArray *lrcLineArray;

/** lrcLine */
@property (nonatomic, strong) JMHLRCLine *lrcLine;

/** 当前播放的歌词的下标 */
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation JMHLrcView


#pragma mark - 重写setLrcName方法
- (void)setLrcName:(NSString *)lrcName
{
    // 0.重置保存的当前位置的下标
    self.currentIndex = 0;
    
    // 1.保存歌词名称
    _lrcName = [lrcName copy];
    
    // 2.解析歌词
    self.lrcLineArray = [JMHLRCTool lrcToolWithLrcName:lrcName];
    
    // 3.刷新表格
    [self.tableView reloadData];
}

#pragma mark - 重写setCurrentTime方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    NSInteger count = self.lrcLineArray.count;
    

    for (int i = 0; i < count; i++) {
        
        // 1.获取一行歌词内容和时间
        JMHLRCLine *curretnLrcLine = self.lrcLineArray[i];

        // 2.拿到下一句的歌词
        NSInteger nextIndex = i + 1;
        JMHLRCLine *nextLrcLine = nil;
        if (nextIndex < count) {
            nextLrcLine = self.lrcLineArray[nextIndex];
        }
        
        // 3. 用当前的时间和i位置的歌词比较,并且和下一句比较,如果大于i位置的时间,并且小于下一句歌词的时间,那么显示当前的歌词
        if (self.currentIndex != i && curretnLrcLine.lrcTime <= currentTime && currentTime < nextLrcLine.lrcTime){
            
            // 1.获取需要刷新的行号
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            // 2.记录当前i的行号
            self.currentIndex = i;
  
            // 3.刷新当前的行,和上一行
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            // 4.显示对应句的歌词
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 5.设置外面歌词的Label的显示歌词
            self.lrcLabel.text = curretnLrcLine.lrcText;
            
            // 6.生成锁屏界面的图片
            [self generatorLockImage];
            
        }
        
        // 4.根据进度,显示label画多少
        if (self.currentIndex == i) {
            // 4.1.拿到i位置的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            JMHLrcCell *cell = (JMHLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // 4.2.更新label的进度
            CGFloat progress = (currentTime - curretnLrcLine.lrcTime) / (nextLrcLine.lrcTime - curretnLrcLine.lrcTime);
            cell.lrcLabel.progress = progress;
            self.lrcLabel.progress = progress;
        }
    }


}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
        self.pagingEnabled = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
    }
    return self;
}
// 不要在- (instancetype)initWithFrame:(CGRect)frame和- (instancetype)initWithCoder:(NSCoder *)aDecoder 初始化子控件属性。http://www.jianshu.com/p/7e47da62899c
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35;
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView = tableView;

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    

    // 设置tableView多出的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMHLrcCell *cell = [JMHLrcCell lrcCellWithTableView:tableView];

    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:18];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14.0];
        cell.lrcLabel.progress = 0;
    }
    
    JMHLRCLine *lrcLine = self.lrcLineArray[indexPath.row];

    cell.lrcLine = lrcLine;
    
    return cell;
}

#pragma mark - 生成锁屏界面的图片
- (void)generatorLockImage
{
    // 1.拿到当前歌曲的图片
    JMHMusic *playingMusic = [JMHMusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusic.icon];
    
    // 2.拿到三句歌词
    // 2.1.获取当前的歌词
    JMHLRCLine *currentLrcLine = self.lrcLineArray[self.currentIndex];
    
    // 2.2.上一句歌词
    NSInteger previousIndex = self.currentIndex - 1;
    JMHLRCLine *previousLrcLine = nil;
    if (previousLrcLine >= 0) {
        previousLrcLine = self.lrcLineArray[previousIndex];
    }
    
    // 2.3.下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    JMHLRCLine *nextLrcLine = nil;
    if (nextIndex < self.lrcLineArray.count) {
        nextLrcLine = self.lrcLineArray[nextIndex];
    }
    
    // 3.生成水印图片
    // 3.1.获取上下文
    UIGraphicsBeginImageContext(currentImage.size);
    
    // 3.2.将图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    // 3.3.将歌词画到图片上
    CGFloat titleH = 25;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attributes1 = [NSMutableDictionary dictionary];
    attributes1[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    attributes1[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attributes1[NSParagraphStyleAttributeName] = style;
    
    [previousLrcLine.lrcText drawInRect:CGRectMake(0, currentImage.size.height - titleH * 3, currentImage.size.width, titleH) withAttributes:attributes1];
    [nextLrcLine.lrcText drawInRect:CGRectMake(0, currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSParagraphStyleAttributeName : style};
    [currentLrcLine.lrcText drawInRect:CGRectMake(0, currentImage.size.height - titleH * 2, currentImage.size.width, titleH) withAttributes:attributes2];
    
    // 4.生成图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.设置锁屏信息
    [self setupLockScreenInfoWithLockImage:lockImage];

    // 6.关闭
    UIGraphicsEndImageContext();
    
}

#pragma mark - 设置锁屏界面的信息
- (void)setupLockScreenInfoWithLockImage:(UIImage *)image
{
    // MPMediaItemPropertyAlbumTitle
    // MPMediaItemPropertyAlbumTrackCount
    // MPMediaItemPropertyAlbumTrackNumber
    // MPMediaItemPropertyArtist
    // MPMediaItemPropertyArtwork
    // MPMediaItemPropertyComposer
    // MPMediaItemPropertyDiscCount
    // MPMediaItemPropertyDiscNumber
    // MPMediaItemPropertyGenre
    // MPMediaItemPropertyPersistentID
    // MPMediaItemPropertyPlaybackDuration
    // MPMediaItemPropertyTitle
    JMHMusic *cuttentMusic = [JMHMusicTool playingMusic];
    
    // 1.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2. 设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    [playingInfo setObject:cuttentMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:cuttentMusic.singer forKey:MPMediaItemPropertyArtist];
    
        
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:image];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
   
    [playingInfo setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [playingInfo setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    playingInfoCenter.nowPlayingInfo = playingInfo;
    
    // 3. 让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
@end
