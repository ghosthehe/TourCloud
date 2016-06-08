//
//  TCHeadlineRequestModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCHeadlineRequestModel.h"
#import "TCUrlDefineUntil.h"
#import "TCHeadlineItem.h"
#import "TCHeadlineCellModel.h"

@implementation TCHeadlineRequestModel

- (instancetype)init
{
    if (self = [super init]) {
        
        __weak typeof(self) weakSelf = self;
        
        self.parser = ^(MSHTTPResponse *response)
        {
            return [weakSelf itemsFromResponse:response];
        };

    }
    
    return self;
}

- (NSArray *)itemsFromResponse:(MSHTTPResponse *)response
{
    NSDictionary *dictionary = response.originData;
    NSArray *comments = dictionary[@"data"];
    
    return [self parseDataWithComments:comments];
}

- (NSArray *)parseDataWithComments:(NSArray *)comments
{
    NSArray *items = [TCHeadlineItem parseArray:comments];

    self.headlineItems = items;
    
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:0];

    for (TCHeadlineItem *item in items) {

        TCHeadlineCellModel *cellModel = [[TCHeadlineCellModel alloc] init];
        
        [cellModel parseItem:item];
        
        [datas addObject:cellModel];

    }
    
    return datas;
}

- (void)getHeadlineData
{
    self.datas[@"customerCode"] = @"lyy";
    self.datas[pageIndex] = @(1);
    self.datas[pageSize] = @(5);
    self.URLString = Url;
    self.parameter[cmd] = @"214";
    self.parameter[ver] = @"1_4";
    self.parameter[@"data"] = self.datas;
    
    
    [self POST:self.URLString param:self.parameter block:^(MSHTTPResponse *response, NSURLSessionTask *task, BOOL success) {
        
        
        NSArray *items = [TCHeadlineItem parseArray:response.originData[@"data"]];
        
        NSDictionary *dic = @{@"heanlineData":items};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"heanlineData" object:nil userInfo:dic];
        
    }];
    
}

@end
