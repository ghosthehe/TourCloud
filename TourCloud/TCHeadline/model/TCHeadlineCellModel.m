//
//  TCHeanlineCellModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCHeadlineCellModel.h"
#import "TCHeadlineCell.h"

@implementation TCHeadlineCellModel

- (void)parseItem:(TCHeadlineItem *)item
{
    
    _item = item;
    
    self.reuseIdentify = @"TCHeadlineCell";
    self.height = 85;
    self.Class = [TCHeadlineCell class];
    self.isRegisterByClass = NO;
    
    self.title = [self titleAttributedString];
    self.timeAndAccessNum = [self timeAndAccessNumAttributedString];
}

- (NSAttributedString *)titleAttributedString
{
    if ([_item.newstitle length] > 0) {
        NSMutableAttributedString *titleSting = [[NSMutableAttributedString alloc] initWithString:_item.newstitle attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:5];
        [titleSting addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleSting.length)];
        
        return titleSting;
    }else{
        return nil;
    }
    
}

- (NSAttributedString *)timeAndAccessNumAttributedString
{
    NSString *str = [NSString stringWithFormat:@"%@   %@: %ld",_item.lastupdateddatetime,@"浏览",(long)_item.scannum];
    
    NSMutableAttributedString *timeAndAccessNumAtt = [[NSMutableAttributedString alloc] initWithString:str];
    
    [timeAndAccessNumAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, str.length)];
    
    
    return timeAndAccessNumAtt;
    
}


@end
