//
//  EMCycleScrollView.m
//  Pods
//
//  Created by xoHome on 15/11/3.
//
//


#import "EMCycleScrollAdView.h"
#import "CollectionModels.h"
#import "NSTimer+Pause.h"

static const CGFloat kDefaultAutoScrollTimeInterval = 5.0;  //默认轮播时间

@interface EMCycleScrollAdView()<MSHorizontalCollectionViewDelegate>
{
    NSInteger lastItemsCount;
}
//@property (nonatomic ,assign) BOOL isInfiniteCycle; //是否是循环滚动
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic ,strong) NSTimer *scrollTimer;

@end

@implementation EMCycleScrollAdView

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
                infiniteCycle:(BOOL)isInfiniteCycle {
    
    self.infiniteCycle = isInfiniteCycle;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
        [self updateCollectionViewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateCollectionViewConfig];
}

- (void)initConfig {
    _autoScrollInterval = kDefaultAutoScrollTimeInterval;
    self.isAutoCycleScroll = NO;
}

- (void)updateCollectionViewConfig {
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
}

/**
 *  UICollectionView 偏移到item位置
 *
 *  @param item 滚动的位置
 */
- (void)scrollToItem:(NSInteger)item {
    
    MSCollectionDataSource *dataSource = self.collectionView.dataSource;
    if ([dataSource.sections count] > 0) {
    NSArray *items = [_dataSource itemsAtSection:0];
    if (item < items.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }

}

- (void)autoScroll {
    if(self.items.count > 1) {
        int currentIndex = self.collectionView.contentOffset.x / CGRectGetWidth(self.frame) + 1;
        if (currentIndex < self.items.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidateTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat collectionWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = 0;
    if (self.isInfiniteCycle) {
        NSInteger item = 0;
        //    从右向左滑动
        if (offsetX >= collectionWidth * (self.items.count - 1)) {
            item = 1;
            [self scrollToItem:item];
        }
        //   从左向右滑动
        else if (offsetX <=0) {
            item = self.items.count -2;
            [self scrollToItem:item];
        } else {
            item = (offsetX + collectionWidth * 0.5) / collectionWidth;
        }
        
        currentPage = item - 1;
        
    } else {
        currentPage = (offsetX + collectionWidth * 0.5) / collectionWidth;
    }
    self.pageControl.currentPage = (int)currentPage;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:willChangeToIndex:)]) {
        [self.delegate cycleScrollView:self willChangeToIndex:currentPage];
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    NSInteger _totalPages = self.items.count;
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self fireTimer];
    self.collectionView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.collectionView.scrollEnabled = YES;
}

#pragma mark - MSHorizontalCollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_collectionView.dataSource isKindOfClass:[MSCollectionDataSource class]]) {
        return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItem:)]) {
        
        MSCollectionDataSource *ds = (MSCollectionDataSource *)_collectionView.dataSource;
        id<MSCollectionCellModel> item = [ds itemAtIndexPath:indexPath];
        if (item) {
            [self.delegate cycleScrollView:self didSelectItem:item];
        }
    }
}

#pragma mark - Getter & Setter
- (void)setDataSource:(MSCollectionDataSource *)dataSource
{
    lastItemsCount = self.items.count;
    self.collectionView.dataSource = dataSource;
    _dataSource = dataSource;
    if ([_dataSource.sections count] > 0) {
        NSArray *items = [_dataSource itemsAtSection:0];
        //    设置页面数
        self.pageControl.numberOfPages = (int)items.count;
        if(self.isInfiniteCycle && items.count > 1) {
            [self cycleDataSource:items];
            if (self.isAutoCycleScroll) {
                [self fireTimer];
            }
        } else {
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:items];
            [self.collectionView reloadData];
        }
    }
}

- (void)cycleDataSource:(NSArray *)array {
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:array];
    
    //    配置数据源：
    //    如：_imageUrlItems = [1,2,3] 则配置后的数据源格式为[3,1,2,3,1]
    id firstObject = [array firstObject];
    id lastObject = [array lastObject];
    [self.items insertObject:lastObject atIndex:0];
    [self.items addObject:firstObject];
  
    _dataSource = [[MSCollectionDataSource alloc] initWithItems:@[self.items] sections:@[@""]];
    self.collectionView.dataSource = _dataSource;
//  加载到cell上，设置偏移量不对问题，估计是计算cell坐标问题，当cell坐标还没计算好，就改变偏移量会出错
//  所以延时一下改变偏移量，暂时处理此问题
    
    if(lastItemsCount != self.items.count) {
        [self setNeedsLayout];
    }

    [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(changeOfSet) userInfo:nil repeats:NO];
}

- (void)changeOfSet {
    if(self.pageControl.currentPage == 0 || lastItemsCount != self.items.count) {
        [self scrollToItem:1];
    }
}

- (void)setIsAutoCycleScroll:(BOOL)isAutoCycleScroll {
    _isAutoCycleScroll = isAutoCycleScroll;
    
    if (_isAutoCycleScroll) {
        _infiniteCycle = YES;
        [self fireTimer];
    } else {
        [self invalidateTimer];
    }
}

- (void)setInfiniteCycle:(BOOL)infiniteCycle {
    _infiniteCycle = infiniteCycle;
    NSAssert(!(_isAutoCycleScroll == YES && _infiniteCycle == NO), @"需要设置self.infiniteCycle为yes");
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval {
    if (_autoScrollInterval != autoScrollInterval) {
        _autoScrollInterval = autoScrollInterval;
        [self invalidateTimer];
        self.scrollTimer = nil;
        [self fireTimer];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSTimer *)scrollTimer {
    if (!_scrollTimer) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSDefaultRunLoopMode];
    }
    return _scrollTimer;
}

/**
 *  废弃计时器
 */
- (void)invalidateTimer{
    //        如果支持无限滚动，自动循环滚动，激活计时器
    if (self.isInfiniteCycle && self.isAutoCycleScroll && self.items.count > 1) {
        [self.scrollTimer pause];
    }
}
/**
 *  启动计时器
 */
- (void)fireTimer{
    //        如果支持无限滚动，自动循环滚动，激活计时器
    if (self.isInfiniteCycle && self.isAutoCycleScroll && self.items.count > 1) {
        [self invalidateTimer];
        [self.scrollTimer resumeInDate:[NSDate dateWithTimeIntervalSinceNow:self.autoScrollInterval]];
    }
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        [self fireTimer];
    } else {
        [self invalidateTimer];
    }
}

- (void)dealloc
{
    if ([self.scrollTimer isValid]) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

@end
