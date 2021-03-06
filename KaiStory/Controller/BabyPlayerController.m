//
//  BabyPlayerController.m
//  KaiStory
//
//  Created by yanzehua on 15/4/21.
//  Copyright (c) 2015年 gaoxinfei. All rights reserved.
//

#import "BabyPlayerController.h"
#import "Tools.h"
#import "AFSoundManager.h"
#import "SqliteControl.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexStringToColor.h"
#import "PlayerListItemView.h"
#import "PlayerCoverView.h"
#import "AudioPlayManager.h"
#import "UserShareInfo.h"
#import "KSDownloader.h"
//#import "iToast.h"

@implementation BabyPlayerController
- (void) initTitleBar
{
    [self setTitleLabelText:@"播放器"];
    
    [self.backBtn setImage:[UIImage imageNamed:@"收起2.png"] forState:(UIControlStateNormal)];
    [self.backBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
   
    int const listMarginTop = 75;
    int const listMarginRight = 80;
    int const listWidth = 43;
    int const listHeight = 29;
    
    self.listBtn = [[UIButton alloc] initWithFrame:CGRectMake(FRAME_WIDTH - listMarginRight/2, listMarginTop/2, listWidth/2, listHeight/2)];
    [self.listBtn setImage:[UIImage imageNamed:@"菜单.png"] forState:(UIControlStateNormal)];
    [self.listBtn addTarget:self action:@selector(listBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.listBtn];
    
    [self.titleView setBackgroundColor:[UIColor clearColor]];
}

-(void)listBtnPressed:(id)sender
{
    [self.scrollView  scrollRectToVisible:CGRectMake(0, 300, FRAME_WIDTH, self.scrollView.frame.size.height) animated:NO];
    [self.pageController setCurrentPage:0];
}

-(void)backBtnAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

-(void)initInfoView
{
    int infoViewRegionHeight = 638;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, infoViewRegionHeight*RESIZE_RATIO)];
    //self.scrollView.backgroundColor = [UIColor ColorWithHexString:@"e4f2ee"];
    self.scrollView.contentSize = CGSizeMake(FRAME_WIDTH*3, infoViewRegionHeight*RESIZE_RATIO);
    self.scrollView.contentOffset = CGPointMake(FRAME_WIDTH, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled= YES;
    self.scrollView.delegate = self;
    [self.contentView addSubview:self.scrollView];
    
    self.coverView = [[PlayerCoverView alloc]initWithFrame:CGRectMake(FRAME_WIDTH, 0, FRAME_WIDTH, infoViewRegionHeight*RESIZE_RATIO)];
    [self.scrollView addSubview:self.coverView];
    
    self.detailView = [[PlayerDetailView alloc]initWithFrame:CGRectMake(FRAME_WIDTH*2, 0, FRAME_WIDTH, infoViewRegionHeight*RESIZE_RATIO)];
    [self.scrollView addSubview:self.detailView];
    
    self.playListContainerView = [[PlayerListView alloc]initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, infoViewRegionHeight*RESIZE_RATIO)];
    [self.scrollView addSubview:self.playListContainerView];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageController setCurrentPage:offset.x / bounds.size.width ];
}


-(void) initToolsView
{
    int infoViewRegionHeight = 638;
    int toolsViewRegionHeight = 120;
    self.toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, infoViewRegionHeight*RESIZE_RATIO, FRAME_WIDTH, toolsViewRegionHeight*RESIZE_RATIO)];
    [self.contentView addSubview:self.toolsView];
    //self.toolsView.backgroundColor = [UIColor ColorWithHexString:@"e4f2ee"];
    
    int marginLeft = 78;
    int marginTop = 30;
    int iconSize = 40;
    self.loveBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO, marginTop*RESIZE_RATIO, iconSize*RESIZE_RATIO, iconSize*RESIZE_RATIO)];
    [self.loveBtn setImage:[UIImage imageNamed:@"列表喜欢"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"列表已经喜欢"] forState:UIControlStateSelected];
    [self.loveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView addSubview:self.loveBtn];
    
    marginLeft += (52+iconSize);
    self.downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO, marginTop*RESIZE_RATIO, iconSize*RESIZE_RATIO, iconSize*RESIZE_RATIO)];
    [self.downloadBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [self.downloadBtn setImage:[UIImage imageNamed:@"已下载"] forState:UIControlStateSelected];
    [self.downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView addSubview:self.downloadBtn];
    
    
    marginLeft += (60+iconSize);
    marginTop = 40;
    self.pageController = [[pageController alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO, marginTop*RESIZE_RATIO, 80*RESIZE_RATIO, 30*RESIZE_RATIO)];
    self.pageController.numberOfPages = 3;
    [self.pageController setCurrentPage:1];
    [self.toolsView addSubview:self.pageController];
    
    marginTop = 30;
    marginLeft = 440;
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO, marginTop*RESIZE_RATIO, iconSize*RESIZE_RATIO, iconSize*RESIZE_RATIO)];
    [self.shareBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateSelected];
    [self.toolsView addSubview:self.shareBtn];
    
    marginLeft += (52+iconSize);
    self.commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO, marginTop*RESIZE_RATIO, iconSize*RESIZE_RATIO, iconSize*RESIZE_RATIO)];
    [self.commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateSelected];
    [self.toolsView addSubview:self.commentBtn];
    
}

-(void) downloadBtnClick:(id)sender
{
    AudioPlayItem* playItem = [AudioPlayManager sharedManager].currentPlayItem;
    if(nil != playItem)
    {
        StoryModel* model = playItem.story;
        DownloadItem* downloadItem =[[DownloadItem alloc]initWithBaseInfo:model.m_id  withSrcUrl:model.media_url  withMd5sum:@""];
        [[KSDownloader shareInstance] addADownloadItem:downloadItem];
        self.downloadBtn.selected = YES;
    }else
    {
//        [[[iToast makeText:NSLocalizedString(@"当前无正在播放故事", @"")] setGravity:iToastGravityBottom ] show];
    }
}

-(void) loveBtnClick:(id)sender
{
    AudioPlayItem* playItem = [AudioPlayManager sharedManager].currentPlayItem;
    if(nil != playItem)
    {
        if(self.loveBtn.selected)
        {
            [[UserShareInfo sharedSingleton] removeLoveStory:playItem.story.m_id];
        }else
        {
            [[UserShareInfo sharedSingleton] addLoveStory:playItem.story];
        }
        self.loveBtn.selected = ! self.loveBtn.selected;
    }else
    {
//        [[[iToast makeText:NSLocalizedString(@"当前无正在播放故事", @"")] setGravity:iToastGravityBottom ] show];
    }
}

-(void) initPlayerView
{
    int infoViewRegionHeight = 638;
    int toolsViewRegionHeight = 120;
    int playerViewRegionHeight = 250;
    
    self.playerBtnView = [[PlayerBtnView alloc]initWithFrame:CGRectMake(0, (infoViewRegionHeight+toolsViewRegionHeight)*RESIZE_RATIO, FRAME_WIDTH, playerViewRegionHeight*RESIZE_RATIO)];
    [self.contentView addSubview:self.playerBtnView];
    //self.playerBtnView.backgroundColor = [UIColor ColorWithHexString:@"e4f2ee"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initTitleBar];
    
    self.contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,FRAME_WIDTH,FRAME_HEIGHT-64)];
    //TODO 当屏幕高度不够的时候，设定scrollview的高度
    if(FRAME_HEIGHT - 64 < 1000*RESIZE_RATIO)
    {
        self.contentView.contentSize = CGSizeMake(FRAME_WIDTH, 1000*RESIZE_RATIO);
    }
    [self.view addSubview:self.contentView];
    [self initInfoView];
    [self initToolsView];
    [self initPlayerView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //读取故事
    if(nil != [AudioPlayManager sharedManager].currentPlayItem)
    {
        StoryModel* story =[AudioPlayManager sharedManager].currentPlayItem.story;
      [self setTitleLabelText:story.name];
        self.coverView.authorLabel.text = story.author;
        [self.coverView.coverImgView sd_setImageWithURL:[NSURL URLWithString:story.cover_url]];
        self.detailView.detailAuthorLabel.text =story.author;
        self.detailView.detailPublishLabel.text = story.publisher;
        self.detailView.detailAbstractLabel.text = story.summary;
        [self.detailView.detailAbstractLabel sizeToFit];
        //TODO 缺少故事简介的信息
        
        if([[UserShareInfo sharedSingleton].lovedStoryArray containsObject:story.m_id])
        {
            self.loveBtn.selected = YES;
        }
        else
        {
            self.loveBtn.selected = NO;
        }
        
        NSInteger indexOfItem = [[KSDownloader shareInstance] itemIndexOf:[story.m_id integerValue]];
        //如果不包含该key值，说明此操作出现异常
        if( -1 == indexOfItem )
        {
            self.downloadBtn.selected = NO;
        }else
        {
            self.downloadBtn.selected = YES;
        }
    }
    //读取播放列表
    [self.playListContainerView.tableView reloadData];
    [self.playerBtnView regObserver];
    [self.coverView regObserver];
    [self.detailView regObserver];
    [self.playListContainerView regObserver];
    [self.playerBtnView updatePlayerBtnViewState];
    
    [self regObserver];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playerBtnView unRegObserver];
    [self.coverView unRegObserver];
    [self.detailView unRegObserver];
    [self.playListContainerView unRegObserver];
    [self unRegObserver];
}

-(void) updateTitleLabel:(NSNotification*) notification
{
    if(nil != [AudioPlayManager sharedManager].currentPlayItem)
    {
        StoryModel* story =[AudioPlayManager sharedManager].currentPlayItem.story;
        [self setTitleLabelText:story.name];
    }
}

-(void)regObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTitleLabel:)  name:@"CURRENT_PLAY_ID" object:nil];
}

-(void) unRegObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
