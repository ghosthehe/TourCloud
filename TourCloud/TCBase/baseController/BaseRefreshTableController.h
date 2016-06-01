//
//  BaseRefreshTableController.h
//  GhostSpeed
//
//  Created by ghost on 16/4/22.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import "MSRefreshTableController.h"
#import "BaseTableModel.h"

typedef NS_ENUM(NSInteger , RefreshType)
{
    TableHeaderRefreshTypeIncreased,//新增
    TableHeaderRefreshTypeUpdate,
};
@interface BaseRefreshTableController : MSRefreshTableController
{
    NSMutableArray *_operationArray;
    BaseTableModel *_model;
    RefreshType _refreshType;// default is increased
}

@property (nonatomic, strong, readonly) BaseTableModel *model;
@property (nonatomic, assign) BOOL hasRefreshFooter;

/**
 * 加载model，默认是 EMTableRequestModel
 * 子类可通过复写方法生成自定义的model
 */
- (void)loadModel;

/**
 * 加载model后，调用modelDidLoad，设置paramSetter、parser
 * 默认设置pagesize 20
 */
- (void)modelDidLoad;

/**
 *请求结束时，更新footerview状态。
 *默认有翻页需求时，隐藏footerview，无翻页需求时，显示加载完毕
 *子类有特殊需求可通过复写这个方法自定义。
 */
- (void)updateFooterWhenRequestFinished;

- (void)responseWithModel:(id)model;

- (void)cancelTasks;

/**
 *  加载主题色，子视图如果不要主题色，可复写方法置空
 */
- (void)applyTheme;


@end


@interface MJRefreshGifHeader(EMRefreshTableViewController)

- (void)applyEMRefreshStyle;

@end
