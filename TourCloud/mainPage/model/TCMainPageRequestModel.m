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
        
        [self mainPageHotAndTypes];
        
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
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    TCMainPageParserItem *item = [[TCMainPageParserItem alloc] init];
    [items addObject:item];
    
    return items;
}

- (void)mainPageHotAndTypes
{
    MSMutableDataSource *ds = [[MSMutableDataSource alloc] init];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    TCMainPageParserItem *item = [[TCMainPageParserItem alloc] init];
    [items addObject:item];
    
    [ds addNewSection:@"" withItems:items];
    
    self.dataSource = ds;

}

@end
