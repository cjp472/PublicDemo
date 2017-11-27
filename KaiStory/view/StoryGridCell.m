//
//  StoryGridCell.m
//  KaiStory
//
//  Created by yanzehua on 15/4/17.
//  Copyright (c) 2015年 gaoxinfei. All rights reserved.
//

#import "StoryGridCell.h"
#import "Tools.h"
#import "UIColor+HexStringToColor.h"
#import "AudioPlayManager.h"
#import "UIImageView+WebCache.h"

@implementation StoryGridCell

-(void) updatePlayBtnState: (NSInteger) inputId isPlay:(BOOL) playOrNot
{
    
    if([self.story.m_id integerValue
        ] == inputId && playOrNot)
    {
        [self updatePlayState: YES];
    }else
    {
        [self updatePlayState:NO];
    }
}

-(void) updatePlayState: (BOOL) playOrNot
{
    self.isPlaying = playOrNot;
    if(self.isPlaying)
    {
        [self.btnImgView setImage:[UIImage imageNamed:@"发现暂停.png"]];
    }else
    {
        [self.btnImgView setImage:[UIImage imageNamed:@"发现播放.png"]];
    }
}

- (void)clickEvent:(UITapGestureRecognizer *)gesture
{
    [self updatePlayState:!self.isPlaying];
    if(self.isPlaying)
    {
        [[AudioPlayManager sharedManager] playAItem:self.story addToListOrNot:YES];
    }else
    {
        [[AudioPlayManager sharedManager] pause];
    }
}


-(id) initWithFrame:(CGRect) rect withStoryItem:(StoryModel*) storyItem withMaskImg:(UIImage*) maskImg{
    if(self = [super initWithFrame:rect])
    {
        self.story = [[StoryModel alloc]init];
        self.userInteractionEnabled = YES;
        
        self.story = storyItem;
        
        UIImageView* baseCoverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
        [baseCoverImgView setImage:[UIImage imageNamed:@"defaultCoverSmall"]];
        [self addSubview:baseCoverImgView];
        
        UIImageView* coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
        [coverImgView sd_setImageWithURL:[NSURL URLWithString:storyItem.icon_url]];
        [self addSubview:coverImgView];
        
        UIImageView* maskImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
        [maskImgView setImage:maskImg];
        [self addSubview:maskImgView];
        
        self.btnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
        [self updatePlayState:NO];
        [self addSubview:self.btnImgView];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

@end