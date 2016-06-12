//
//  LOLShareView.h
//  掌上英雄联盟
//
//  Created by 尚承教育 on 15/8/30.
//  Copyright (c) 2015年 尚承教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCShareView,TCShareBtn;
@protocol TCShareViewDelegate  <NSObject>

- (void)shareViewDidClickShareBtn:(TCShareView *)shareView selBtn:(TCShareBtn *)shareBtn;

@end

@interface TCShareView : UIImageView

- (void)startShareWithText:(NSString *)text image:(UIImage *)image;

@property (copy, nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImage;

@property (weak, nonatomic) id<TCShareViewDelegate> delegate;

@end
