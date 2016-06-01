//
//  WSNavigationView.m
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import "MSNavigationView.h"
#define kItemW 70
#define kMargin 10

@interface MSNavigationView ()
{
    UIScrollView *_scrollView;
    CALayer *_bottomBorderLayer;
}

@property (strong, nonatomic) CALayer * selectLayer;

@property (strong, nonatomic) NSMutableArray *btns;

@property (weak, nonatomic) UIButton *selectedItem;

@property (copy, nonatomic) itemClick itemClickBlock;

@end

@implementation MSNavigationView

#pragma mark - event

- (void)itemClick:(UIButton *)sender {
    
    if ([sender isEqual:self.selectedItem]) return;
    
    self.selectedItem.selected = NO;
    sender.selected = YES;
   
    if (self.itemClickBlock) {
        
        self.itemClickBlock(sender.tag);
    }

    //更改字体大小
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.titleLabel.font = [UIFont systemFontOfSize:16];
        self.selectedItem.titleLabel.font = [UIFont systemFontOfSize:16];
    }];
    
    //判断位置
    CGFloat offsetX = sender.center.x - self.center.x;
    
    if (offsetX < 0){
        
        self.contentOffset = CGPointMake(0, 0);
        
    }else if (offsetX > (_scrollView.contentSize.width - self.bounds.size.width)){
        
        self.contentOffset = CGPointMake(_scrollView.contentSize.width - self.bounds.size.width, 0);
        
    }else{
        
        self.contentOffset = CGPointMake(offsetX, 0);
    }

    
    self.selectedItem = sender;
    
    _selectLayer.frame = CGRectMake(self.selectedItem.frame.origin.x+kMargin, self.frame.size.height - 7, self.selectedItem.frame.size.width-2*kMargin, 7);
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    
    _selectedItemIndex = selectedItemIndex;
    
    UIButton *item = self.btns[selectedItemIndex];
    
    [self itemClick:item];
}


- (void)setContentOffset:(CGPoint)contentOffset{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [_scrollView setContentOffset:contentOffset];
    }];
}


#pragma mark - init

+ (instancetype)navigationViewWithItems:(NSArray<NSString *> *)items itemClick:(itemClick)itemClick{
    
    MSNavigationView *nav = [[MSNavigationView alloc] init];
    
    nav.btns = [NSMutableArray arrayWithCapacity:items.count];
    
    nav.itemClickBlock = itemClick;
    
    nav.items = items;


    return nav;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat itemHeight = self.frame.size.height - 0.5;
    _scrollView.frame = self.bounds;
    _bottomBorderLayer.frame = CGRectMake(0, itemHeight, self.frame.size.width, 0.5);

    CGFloat itemX  = kMargin;
    for (NSInteger i=0; i<self.btns.count; i++) {
        
        UIButton *item = self.btns[i];
        [item sizeToFit];
        CGFloat width = item.frame.size.width + 2 * kMargin;
        width = MAX(width, kItemW);
        item.frame = CGRectMake(itemX, 0, width, itemHeight);
        itemX += item.frame.size.width;
    }
    
    CGFloat scrollWidth = itemX + kMargin;
    
    if (self.aligment == MSNavigatorViewAligmentAdjust && scrollWidth <= _scrollView.frame.size.width)
    {//两边对齐，重新分布
        CGFloat interval = (_scrollView.frame.size.width  - scrollWidth) / (2.0 * self.btns.count);
        CGFloat itemX = interval;
        for (NSInteger i=0; i<self.btns.count; i++) {
            
            UIButton *item = self.btns[i];
            item.frame = CGRectMake(itemX, 0, item.frame.size.width, itemHeight);
            itemX += (item.frame.size.width + 2 * interval);
        }
        
        scrollWidth = _scrollView.frame.size.width;
    }
    
    scrollWidth = MAX(scrollWidth, _scrollView.frame.size.width);//最新的容器宽度
    
    _scrollView.contentSize = CGSizeMake(scrollWidth, itemHeight);
    _selectLayer.frame = CGRectMake(self.selectedItem.frame.origin.x+kMargin, self.frame.size.height - 7, self.selectedItem.frame.size.width-2*kMargin, 7);
}

- (void)setItems:(NSArray<NSString *> *)items{
    
    _items = items;
    
    //创建按钮
    for (NSInteger i=0; i<items.count; i++) {
        
        UIButton *item = [[UIButton alloc] init];
        [item setTitle:items[i] forState:UIControlStateNormal];
        [item setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [item setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
        [item setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];
        item.titleLabel.font = [UIFont systemFontOfSize:16];
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:item];
        [_scrollView addSubview:item];
        item.tag = i;
    }
}

- (void)setFrame:(CGRect)frame{
        [super setFrame:frame];
}

- (instancetype)init{
    
    if (self = [super init]) {

        self.backgroundColor = [UIColor whiteColor];
        self.normalTextColor = [UIColor darkGrayColor];
        self.selectedTextColor = [UIColor blackColor];
        self.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
        
        _bottomBorderLayer = [CALayer layer];
        _bottomBorderLayer.backgroundColor = self.borderColor.CGColor;
        [self.layer addSublayer:_bottomBorderLayer];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        ////禁用滚动到最顶部的属性
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
 
        _selectLayer = [CALayer layer];
        _selectLayer.contents = (id)[UIImage imageNamed:@"info_xuanzhongerji.png"].CGImage;
//        _selectLayer.backgroundColor = self.selectedTextColor.CGColor;
        [_scrollView.layer addSublayer:_selectLayer];
    }
    return self;
}

- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    _normalTextColor = normalTextColor;
    
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:_normalTextColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [btn setTitleColor:_selectedTextColor forState:UIControlStateHighlighted];
    }
//    _selectLayer.backgroundColor = self.selectedTextColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _bottomBorderLayer.backgroundColor = self.borderColor.CGColor;
}

@end
