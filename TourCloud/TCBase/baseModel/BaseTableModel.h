//
//  BaseTableModel.h
//  GhostSpeed
//
//  Created by ghost on 16/4/22.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import "MSHTTPRequestModel.h"
#import "MSMutableDataSource.h"
#import "CellEventHandle.h"
#import "MSHTTPResponse.h"

typedef NS_ENUM(NSUInteger, EMTableRequestType) {
    EMTableRequestTypeDefault,//刷新数据
    EMTableRequestTypePageUp,//新增数据
    EMTableRequestTypePageDown,//翻页数据
};

typedef void (^EMTableRequestModelParamSetter)(NSMutableDictionary *param, EMTableRequestType requestType);
typedef void (^EMTableRequestModelHeaderSetter)(NSMutableDictionary *header, EMTableRequestType requestType);
typedef NSArray *(^EMTableRequestModelParser)(MSHTTPResponse *response);

@interface BaseTableModel : MSHTTPRequestModel<TableViewCellEventHandler>

@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSString *pageDownUrlString;

@property (nonatomic, strong) NSMutableDictionary *pageupParameter; //上翻页参数
@property (nonatomic, strong) NSMutableDictionary *pagedownParameter; //下翻页参数
@property (nonatomic, strong) NSMutableDictionary *parameter; //参数

@property (nonatomic, assign) BOOL canPageDown;//当前是否可以翻页

@property (nonatomic, strong) MSMutableDataSource *dataSource; //列表数据源
@property (nonatomic, strong) NSMutableArray *items; //所有请求到的原始数据

@property (nonatomic, copy) EMTableRequestModelParamSetter paramSetter;//默认为空
@property (nonatomic, copy) EMTableRequestModelHeaderSetter headerSetter;
@property (nonatomic, copy) EMTableRequestModelParser parser;//默认为空

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy)TableViewCellEventHandler eventHandler;

/**
 *  请求列表数据，分为三种 见EMTableRequestType 定义
 *
 *  @param requestType
 *  @param paramSetter 设置请求的自定义参数（通用参数）
 *  @param parser      解析器，将当前数据列表解析为视图模型列表
 *  @param completion  回调
 */
- (void)requestWithType:(EMTableRequestType)requestType
            paramSetter:(EMTableRequestModelParamSetter)paramSetter
                 parser:(EMTableRequestModelParser)parser
             completion:(void (^)(MSHTTPResponse *response, BOOL success))completion;


- (void)requestWithType:(EMTableRequestType)requestType
             completion:(void (^)(MSHTTPResponse *response, BOOL success))completion;

/**
 *解析多种请求后的参数、数据
 *parseParam  解析参数
 *parseDatasource 解析获得dataSource
 *列表视图如果数据结构跟默认不同的，可通过复写一下方法进行自定义
 */
#pragma mark -
#pragma mark parser

- (void)parseParamOfDefaultResponse:(MSHTTPResponse *)response;
- (void)parseParamOfPageDownResponse:(MSHTTPResponse *)response;
- (void)parseParamOfPageUpResponse:(MSHTTPResponse *)response;

- (void)defaultDatasource:(NSArray *)datas;
- (void)pageDownDatasource:(NSArray *)datas;
- (void)pageUpDatasource:(NSArray *)datas;

- (NSMutableDictionary *)parameterForRequestType:(EMTableRequestType)requestType;
- (NSString *)urlStringForRequestType:(EMTableRequestType)requestType;


@end
