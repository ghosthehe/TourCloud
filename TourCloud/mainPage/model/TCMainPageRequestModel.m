//
//  TCMainPageModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMainPageRequestModel.h"
#import "NSString+URLEncoding.h"
#import "MSHTTPSessionManager.h"
#import "AFHTTPSessionManager.h"

@implementation TCMainPageRequestModel

- (instancetype)init
{
    if (self = [super init]) {
        
//        NSString *urlStr = @"http://cloud.tianxiayunyou.com/why-mobile/mobile/webservice";
//        self.URLString = [urlStr URLEncodedString];
//        
//        NSDictionary *dic = @{@"cmd":@"214",
//                              @"ver":@"1_4",
//                              @"customerCode":@"lyy",
//                              @"pageIndex":@"1",
//                              @"pageSize":@"5"};
//        
//        [self.parameter addEntriesFromDictionary:dic];
//        __weak typeof(self) weakSelf = self;
//        
//        self.parser = ^(MSHTTPResponse *response)
//        {
//            return [weakSelf itemsFromResponse:response];
//        };
        
        [self getHeadLine];

    }
    
    return self;
}

- (void)getHeadLine
{
    NSString *urlStr = @"http://cloud.tianxiayunyou.com/why-mobile/mobile/webservice";

    NSDictionary *dic = @{@"cmd":@"214",
                          @"ver":@"1_4",
                          @"customerCode":@"lyy",
                          @"pageIndex":@"1",
                          @"pageSize":@"5"};
    
    
//    MSHTTPSessionManager *manager = [MSHTTPSessionManager sharedManager];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSLog(@"%@", responseObject);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
    
//    [manager POST:[urlStr fixMe_URLEncodedString] parameters:dic headerFields:nil block:^(MSHTTPResponse *response, NSURLSessionTask *task, BOOL success) {
//        
//        if (success) {
//            
//        }
//    }];
}

- (NSArray *)itemsFromResponse:(MSHTTPResponse *)response
{
    NSDictionary *dictionary = response.originData;
    NSArray *comments = dictionary[@"data"];
    
    return [self parseDataWithComments:comments];
}

- (NSArray *)parseDataWithComments:(NSArray *)comments
{
//    NSArray *items = [EMInfoPageCailianPressItem parseArray:comments];
//    
//    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (EMInfoPageCailianPressItem *item in items) {
//        item.actionDelegate = self.actionDelegate;
//        
//        [datas addObject:item];
//        
//    }
    NSArray *items = nil;
    
    return items;
}

@end
