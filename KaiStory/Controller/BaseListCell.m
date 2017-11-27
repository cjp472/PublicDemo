//
//  BaseListCell.m
//  KaiStory
//
//  Created by yanzehua on 15/4/27.
//  Copyright (c) 2015年 gaoxinfei. All rights reserved.
//

#import "BaseListCell.h"
#import "Tools.h"
#import "UIColor+HexStringToColor.h"
#import "UIImageView+WebCache.h"

@implementation BaseListCell


-(void)initLayout:(CGRect)frame
{
    int marginLeft = 2;
    int marginTop = 2;
    int imgWidth = 140;
    int height = self.bounds.size.height;
    self.baseImgView =[[UIImageView alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO,marginTop*RESIZE_RATIO ,imgWidth*RESIZE_RATIO,height-marginTop*RESIZE_RATIO)];
    self.baseImgView.image = [UIImage imageNamed:@"defaultCoverSmall.jpg"];
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO,marginTop*RESIZE_RATIO ,imgWidth*RESIZE_RATIO,height-marginTop*RESIZE_RATIO)];
    [self addSubview:self.baseImgView];
    [self addSubview:self.coverImgView];
    
    marginLeft = 160;
    marginTop = 50;
    int fontSize = 24;
    int lableWidth = 300;
    self.mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO,marginTop*RESIZE_RATIO,lableWidth*RESIZE_RATIO,fontSize*RESIZE_RATIO)];
    self.mainLabel.text = @"标题";
    self.mainLabel.font = [UIFont systemFontOfSize:fontSize*RESIZE_RATIO];
    self.mainLabel.textColor = [UIColor ColorWithHexString:@"656565"];
    [self addSubview:self.mainLabel];
    
    marginTop = 80;
    fontSize = 14;
    self.subLabel=[[UILabel alloc]initWithFrame:CGRectMake(marginLeft*RESIZE_RATIO,marginTop*RESIZE_RATIO,200*RESIZE_RATIO,fontSize*RESIZE_RATIO)];
    self.subLabel.text = @"简介";
    self.subLabel.font = [UIFont systemFontOfSize:fontSize*RESIZE_RATIO];
    self.subLabel.textColor = [UIColor ColorWithHexString:@"4ab19a"];
    [self addSubview:self.subLabel];

    int marginRight = 30;
    int btnWidth = 46;
    int btnHeight = 10;
    self.optionBtn = [[UIButton alloc]initWithFrame:CGRectMake(FRAME_WIDTH-(marginRight+btnWidth)*RESIZE_RATIO,marginTop*RESIZE_RATIO,btnWidth*RESIZE_RATIO,btnHeight*RESIZE_RATIO)];
    [self.optionBtn setImage:[UIImage imageNamed:@"更多.png"] forState:UIControlStateNormal];
    [self.optionBtn setImage:[UIImage imageNamed:@"更多.png"] forState:UIControlStateSelected];
    self.optionBtnExtA = [[UIButton alloc]initWithFrame:CGRectMake(FRAME_WIDTH-(marginRight+btnWidth)*RESIZE_RATIO,0,(marginRight+btnWidth)*RESIZE_RATIO,height)];
    //[self.optionBtnExtA setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.optionBtn];
    [self addSubview:self.optionBtnExtA];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)setModel:(id)inputData
{
    NSLog(@"Need Overwrite");
}

@end