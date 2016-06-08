//
//  MainPageCycleView.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MainPageCycleView.h"
#import "Masonry.h"
#import "EMCycleScrollAdView.h"
#import "MSUIKitCore.h"
#import "MSMutableCollectionDataSource.h"
#import "TCHeadlineItem.h"

#define WIDTH_OF_SCROLL_PAGE 320
#define HEIGHT_OF_SCROLL_PAGE 460
#define WIDTH_OF_IMAGE 320
#define HEIGHT_OF_IMAGE 284
#define LEFT_EDGE_OFSET 0

@interface MainPageCycleView ()<UIScrollViewDelegate>
{
    EMCycleScrollAdView *_cycleScrollView;
    UIScrollView *_scrollView;
    NSTimer *_timer;
    NSInteger _currentPage;

    
}

@property (nonatomic, strong) UIButton *headLineBtn;
@property (nonatomic, strong) UIButton *telBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MainPageCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
       
    }
    
    return self;
}

- (void)layoutSubviews
{
    [self initHeadLineBtn];
    [self initTelBtn];
    [self initScrollView];
}

- (void)initHeadLineBtn
{
    self.headLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.headLineBtn.frame = CGRectMake(10, 5, 80, 30);
    [self.headLineBtn setTitle:@"旅游头条" forState:UIControlStateNormal];
    self.headLineBtn.backgroundColor = [UIColor redColor];
    [self.headLineBtn addTarget:self action:@selector(slideBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headLineBtn];
    
    [self.headLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@(5));
        make.height.equalTo(@(35));

    }];

}

- (void)initTelBtn
{
    self.telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.telBtn setTitle:@"电话" forState:UIControlStateNormal];
    self.telBtn.backgroundColor = [UIColor redColor];
    [self.telBtn addTarget:self action:@selector(telBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.telBtn];
    
    [self.telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //            make.left.equalTo(@(20));
        make.top.equalTo(@(5));
        make.right.equalTo(@(0));
        make.width.equalTo(@(40));
        make.height.equalTo(@(35));

    }];

}

- (void)initScrollView
{
    
    _currentPage = 1;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(110, 5,  (MSScreenWidth() / 375) * 180 , 35)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    self.scrollView.contentSize = CGSizeMake( 0, ([self.slideBtns count] + 2) * self.scrollView.frame.size.height);
    
    // 遍历创建子控件
    [self.slideBtns enumerateObjectsUsingBlock:^(TCHeadlineItem *item, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = item.newstitle;
        label.font = [UIFont systemFontOfSize:15];
        label.frame = CGRectMake( 0, (idx+1)  * self.scrollView.frame.size.height, 200, self.scrollView.frame.size.height);
        [self.scrollView addSubview:label];

    }];
    
    // 将最后一张图片弄到第一张的位置
    UILabel *firstLabel = [[UILabel alloc] init];
    TCHeadlineItem *lastItem = self.slideBtns[[self.slideBtns count] - 1];
    firstLabel.text = lastItem.newstitle;
    firstLabel.frame = CGRectMake(0, 0, 200, self.scrollView.frame.size.height);
    [self.scrollView addSubview:firstLabel];
    
    // 将第一张图片放到最后位置，造成视觉上的循环
    UILabel *lastLabel = [[UILabel alloc] init];
    TCHeadlineItem *firstItem = self.slideBtns[0];
    lastLabel.text = firstItem.newstitle;
    lastLabel.frame =  CGRectMake(0, 35 * ([self.slideBtns count] + 1), 200, self.scrollView.frame.size.height);
    [self.scrollView addSubview:lastLabel];

    
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height)];


    [self createTimer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(slideBtn)];
    
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(cycleScroll:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    [_timer fire];
}

//废弃定时器
- (void)pause {
    if (![_timer isValid]) {
        return;
    }
    [_timer setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是4001-01-01 00:00:00 +0000
}

- (void)resume {
    [self resumeInDate:[NSDate date]];
}

- (void)resumeInDate:(NSDate *)date {
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:date];
}


- (void)cycleScroll:(NSTimer *)timer
{
    if (_currentPage % (self.slideBtns.count + 1) != 0 || _currentPage == 1) {
        
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * (_currentPage + 1)) animated:YES];

    }else if (_currentPage % (self.slideBtns.count + 1) == 0 && _currentPage != 1){
        
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height) animated:YES];

    }
    
    
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pause];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _currentPage = (NSInteger)((scrollView.contentOffset.y + 1) / scrollView.frame.size.height);
    CGFloat horiPage = (scrollView.contentOffset.y) / scrollView.frame.size.height;
    if (horiPage == self.slideBtns.count + 1) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.frame.size.height) animated:NO];
    }
    if (horiPage == 0) {
        [scrollView setContentOffset:CGPointMake(0, self.slideBtns.count * scrollView.frame.size.height) animated:NO];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resume];
}

- (void)slideBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headLineBtnClick)]) {
        
        [self.delegate performSelector:@selector(headLineBtnClick) withObject:self];
    }

}

- (void)telBtn:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(telBtnClick)]) {
        
        [self.delegate performSelector:@selector(telBtnClick) withObject:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
