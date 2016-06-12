//
//  LOLShareBtn.m
//  掌上英雄联盟
//
//  Created by 尚承教育 on 15/8/30.
//  Copyright (c) 2015年 尚承教育. All rights reserved.
//

#import "TCShareBtn.h"
#import "DefineUntil.h"
#import "MSUIKitCore.h"

@implementation TCShareBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
         self.titleLabel.font = leftFont;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelW = contentRect.size.width;
    CGFloat labelH = MSScreenWidth() * 0.053;
    CGFloat labelX = 0;
    CGFloat labelY = contentRect.size.height + 5;
    
    return CGRectMake(labelX, labelY, labelW, labelH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = imageH;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}



@end
