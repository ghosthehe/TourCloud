//
//  TCMainPageModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMainPageRequestModel.h"
#import "TCMainPageParserItem.h"
#import "TCMainPageCellModel.h"

@implementation TCMainPageRequestModel

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
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *items = [TCMainPageParserItem parseArray:comments];
    
    for (TCMainPageParserItem *item in items) {
        TCMainPageCellModel *cellModel = [[TCMainPageCellModel alloc] init];
        [cellModel parseItem:item];
        
        [datas addObject:cellModel];
    }
    
    return datas;
}

- (void)defaultDatasource:(NSArray *)datas
{
    //datasource
    MSMutableDataSource *dataSource = [[MSMutableDataSource alloc] init];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    TCMainPageParserItem *item = [[TCMainPageParserItem alloc] init];
    [items addObject:item];
    [dataSource addNewSection:@"" withItems:items];
    
    [dataSource addNewSection:@"最新活动" withItems:datas];
    self.dataSource = dataSource;
    
}

- (void)pageDownDatasource:(NSArray *)datas
{
    //datasource
    if (datas && datas.count)
    {
        [self.dataSource appendItems:datas atSectionTitle:@"最新活动"];
    }
    
}

- (void)pageUpDatasource:(NSArray *)datas
{
    if (datas && datas.count) {
        
        MSMutableDataSource *dataSource = [[MSMutableDataSource alloc] init];
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
        TCMainPageParserItem *item = [[TCMainPageParserItem alloc] init];
        [items addObject:item];
        [dataSource addNewSection:@"" withItems:items];
        
        [dataSource addNewSection:@"最新活动" withItems:datas];
        self.dataSource = dataSource;
        
    }
    
}

@end
