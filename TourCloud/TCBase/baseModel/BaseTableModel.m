//
//  BaseTableModel.m
//  GhostSpeed
//
//  Created by ghost on 16/4/22.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import "BaseTableModel.h"
#import "TCUrlDefineUntil.h"

@implementation BaseTableModel

- (id)init
{
    self = [super init];
    if (self) {
        self.parameter = [NSMutableDictionary dictionary];
//        self.pageupParameter   = [NSMutableDictionary dictionary];
//        self.pagedownParameter = [NSMutableDictionary dictionary];
        
        self.datas = [NSMutableDictionary dictionary];
        self.title = @"";
        self.items = [NSMutableArray array];
        self.canPageDown = NO;
    }
    return self;
}

//- (NSMutableDictionary *)parameterForRequestType:(EMTableRequestType)requestType
//{
//    NSMutableDictionary *param = nil;
//    switch (requestType) {
//        case EMTableRequestTypeDefault:
//            param = self.parameter;
//            break;
//        case EMTableRequestTypePageDown:
//            param = self.pagedownParameter;
//            break;
//        case EMTableRequestTypePageUp:
//            param = self.pageupParameter;
//            break;
//        default:
//            break;
//    }
//    
//    return param;
//}

- (NSString *)urlStringForRequestType:(EMTableRequestType)requestType
{
    NSString *urlString = self.URLString;
//    if (requestType == EMTableRequestTypePageDown && self.pageDownUrlString)
//    {
//        urlString = self.pageDownUrlString;
//    }
    return urlString;
}

- (void)requestWithType:(EMTableRequestType)requestType
            paramSetter:(EMTableRequestModelParamSetter)paramSetter
                 parser:(EMTableRequestModelParser)parser
             completion:(void (^)(MSHTTPResponse *response, BOOL success))completion
{
    NSString *urlString = [self urlStringForRequestType:requestType];
//    NSMutableDictionary *param = [self parameterForRequestType:requestType];
//    if (paramSetter)
//    {
//        paramSetter(param,requestType);
//    }
//    NSMutableDictionary *header = nil;
//    if (self.headerSetter)
//    {
//        header = [NSMutableDictionary dictionary];
//        self.headerSetter(header,requestType);
//    }
    
//    [self GET:urlString
//   parameters:param
// headerFields:header
//        block:^(MSHTTPResponse *response, NSURLSessionTask *task, BOOL success) {
//            
//            if (response.status == MSHTTPResponseStatusOK)
//            {
//                NSArray *items = parser(response);
//                if (response.status == MSHTTPResponseStatusOK)
//                {//兼容某些特殊包可能在parser中改变状态
//                    if (requestType == EMTableRequestTypeDefault) {
//                        [self defaultDatasource:items];
//                        [self parseParamOfDefaultResponse:response];
//                    }
//                    else if (requestType == EMTableRequestTypePageUp)
//                    {
//                        [self pageUpDatasource:items];
//                        [self parseParamOfPageUpResponse:response];
//                    }
//                    else if (requestType == EMTableRequestTypePageDown)
//                    {
//                        [self pageDownDatasource:items];
//                        [self parseParamOfPageDownResponse:response];
//                    }
//                }
//            }
//            else
//            {
//                success = NO;
//            }
//            
//            if (completion) {
//                completion(response,success);
//            }
//        }];
    [self POST:urlString parameters:self.parameter headerFields:nil block:^(MSHTTPResponse *response, NSURLSessionTask *task, BOOL success) {
        
        if (response.status == MSHTTPResponseStatusOK)
        {
            NSArray *items = parser(response);
            //兼容某些特殊包可能在parser中改变状态
            if (requestType == EMTableRequestTypeDefault) {
                [self defaultDatasource:items];
                [self parseParamOfDefaultResponse:response];
            }
            else if (requestType == EMTableRequestTypePageUp)
            {
                [self pageUpDatasource:items];
                [self parseParamOfPageUpResponse:response];
            }
            else if (requestType == EMTableRequestTypePageDown)
            {
                [self pageDownDatasource:items];
                [self parseParamOfPageDownResponse:response];
            }
        }

        else
        {
            success = NO;
        }
        
        if (completion) {
            completion(response,success);
        }

    }];
}

- (void)requestWithType:(EMTableRequestType)requestType
             completion:(void (^)(MSHTTPResponse *response, BOOL success))completion
{
    [self requestWithType:requestType
              paramSetter:self.paramSetter
                   parser:self.parser
               completion:completion];
}

- (void)parseParamOfDefaultResponse:(MSHTTPResponse *)response
{
    if ([response.originData isKindOfClass:[NSDictionary class]])
    {
        //parameter
        NSArray *datas = response.originData[@"data"];
        if (datas.count >= 5) {
            self.canPageDown = YES;
        }
        
    }
}

- (void)parseParamOfPageDownResponse:(MSHTTPResponse *)response
{
    if ([response.originData isKindOfClass:[NSDictionary class]])
    {
        //parameter
//        self.pageDownUrlString = response.originData[@"nextPage"];
//        self.canPageDown = [response.originData[@"hasNextPage"] boolValue];
//        self.pagedownParameter[@"lastid"] = response.originData[@"lastid"];
        
        NSArray *datas = response.originData[@"data"];
        if (datas.count < 5) {
            self.canPageDown = NO;
        }
    }
}

- (void)parseParamOfPageUpResponse:(MSHTTPResponse *)response
{
    if ([response.originData isKindOfClass:[NSDictionary class]])
    {
        //parameter
//        self.pageupParameter[@"topid"] = response.originData[@"topid"];
        
        NSArray *datas = response.originData[@"data"];
        if (datas.count >= 5) {
            self.canPageDown = YES;
        }
    }
}

- (void)defaultDatasource:(NSArray *)datas
{
    //datasource
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:datas];
    MSMutableDataSource *dataSource = [[MSMutableDataSource alloc] init];
    [dataSource addNewSection:self.title withItems:self.items];
    self.dataSource = dataSource;
    
}

- (void)pageDownDatasource:(NSArray *)datas
{
    //datasource
    if (datas && datas.count)
    {
        [self.items addObjectsFromArray:datas];
        NSInteger index = [self.dataSource.sections indexOfObject:self.title];
        [self.dataSource removeSection:index];
        [self.dataSource addNewSection:self.title withItems:self.items];
    }
    
}

- (void)pageUpDatasource:(NSArray *)datas
{
    //datasource
//    if(self.dataSource)
//    {
//        [self.items insertObjects:datas atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, datas.count)]];
//        NSInteger index = [self.dataSource.sections indexOfObject:self.title];
//        [self.dataSource removeSection:index];
//        [self.dataSource addNewSection:self.title withItems:self.items];
//    }
//    else
//    {
//        [[self items] removeAllObjects];
//        [self.items addObjectsFromArray:datas];
//        MSMutableDataSource *dataSource = [[MSMutableDataSource alloc] init];
//        [dataSource addNewSection:self.title withItems:self.items];
//        self.dataSource = dataSource;
//    }
    if (datas && datas.count) {
        
        [[self items] removeAllObjects];
        [self.items addObjectsFromArray:datas];
        MSMutableDataSource *dataSource = [[MSMutableDataSource alloc] init];
        [dataSource addNewSection:self.title withItems:self.items];
        self.dataSource = dataSource;

    }
    
}


- (void)dealloc
{
    self.paramSetter = nil;
    self.parser = nil;
    self.eventHandler = nil;
}

@end
