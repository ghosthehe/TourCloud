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
#import "TCCycleModel.h"

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
    
}

@property (nonatomic, strong) NSArray *slideBtns;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MainPageCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initHeadLineBtn];
        [self initTelBtn];
        [self initScrollView];
       
    }
    
    return self;
}

- (void)initHeadLineBtn
{
    self.headLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.headLineBtn.frame = CGRectMake(10, 5, 80, 30);
    [self.headLineBtn setTitle:@"旅游头条" forState:UIControlStateNormal];
    self.headLineBtn.backgroundColor = [UIColor redColor];
    [self.headLineBtn addTarget:self action:@selector(headLineBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    self.slideBtns = [NSArray arrayWithObjects:@"徐汇",@"七宝",@"浦东新区", nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(110, 5, 200, 35)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    self.scrollView.contentSize = CGSizeMake( 0, ([self.slideBtns count] + 2) * self.scrollView.frame.size.height);
    
    // 遍历创建子控件
    [self.slideBtns enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = idx + 1;
        [btn addTarget:self action:@selector(slideBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:imageName forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake( 0, (idx+1)  * self.scrollView.frame.size.height, 200, self.scrollView.frame.size.height);
        [self.scrollView addSubview:btn];

    }];
    
    // 将最后一张图片弄到第一张的位置
    UIButton *firstBtn = [[UIButton alloc] init];
    firstBtn.tag = 4;
    [firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [firstBtn setTitle:self.slideBtns[[self.slideBtns count] - 1] forState:UIControlStateNormal];
    firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    firstBtn.frame = CGRectMake(0, 0, 200, self.scrollView.frame.size.height);
    [self.scrollView addSubview:firstBtn];
    
    // 将第一张图片放到最后位置，造成视觉上的循环
    UIButton *lastBtn = [[UIButton alloc] init];
    lastBtn.tag = 5;
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastBtn setTitle:self.slideBtns[0] forState:UIControlStateNormal];
    lastBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    lastBtn.frame =  CGRectMake(0, 35 * ([self.slideBtns count] + 1), 200, self.scrollView.frame.size.height);
    [self.scrollView addSubview:lastBtn];

    
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height)];


    [self createTimer];
    
}

- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cycleScroll:) userInfo:nil repeats:YES];
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
    static int count = 0;
    count ++;
    
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * count) animated:YES];

    NSInteger page = self.scrollView.contentOffset.y / self.scrollView.frame.size.height;
    // 如果当前页是第0页就跳转到数组中最后一个地方进行跳转
    if (page == 0) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * ([[self slideBtns] count])) animated:YES];
        

        
    }else if (page == [[self slideBtns] count] + 1){
        // 如果是第最后一页就跳转到数组第一个元素的地点
        [self.scrollView setContentOffset:CGPointMake( 0, self.scrollView.frame.size.height)];
        
        count = 1;

    }
    
    
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pause];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger page = scrollView.contentOffset.y / scrollView.frame.size.height;
//    
//    if (page == 0) {
//        
//        [scrollView setContentOffset:CGPointMake( 0, scrollView.frame.size.height * ([[self slideBtns] count]))];
//        
//    }else if (page == [[self slideBtns] count] + 1){
//        // 如果是第最后一页就跳转到数组第一个元素的地点
//        [scrollView setContentOffset:CGPointMake(0, scrollView.frame.size.height)];
//        
//    }
//    
//}

- (void)slideBtn:(UIButton *)btn
{
    
}

- (void)headLineBtn:(UIButton *)btn
{
    

}

- (void)telBtn:(UIButton *)btn
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
