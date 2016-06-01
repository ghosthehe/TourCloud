//
//  InfoMenu.m
//  ScrollView2010Demo
//
//  Created by chenmeiosis on 13-6-17.
//  Copyright (c) 2013年 Fugu Mobile Limited. All rights reserved.
//

#import "MSMultiPagingMenu.h"
#import "MSContext.h"

#define kMultPagingMenuFont     [UIFont systemFontOfSize:16]

const CGFloat kMultiPagingMenuBarHeight             = 35;
const CGFloat kMultiPagingMenuEdithButtonWidth      = 57;
const CGFloat kMultiPagingMenuSpace                 = 20;
const CGFloat kMultiPagingMenuSelectTwoWordWidth    = 58;
const CGFloat kMultiPagingMenuSelectFourWordWidth   = 80;
const CGFloat kMultiPagingMenuSelectFiveWordWidth   = 99;
const CGFloat kMultiPagingMenuSelectHeight          = 36;


@interface MSMultiPagingMenu()
- (CGRect)selectBgRectAtIndex:(NSUInteger)index;
@end

@implementation MSMultiPagingMenu
@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;
@dynamic selectedColor;
@dynamic unselectedColor;

- (instancetype)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles
           editable:(BOOL)editable
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titles = [titles copy];
        _selectedIndex = 0;
        _unselectedColor = [UIColor darkGrayColor];
        _selectedColor = [UIColor blackColor];
        
        int editWidth = editable ? kMultiPagingMenuEdithButtonWidth : 0;
        _svMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-editWidth + 4, kMultiPagingMenuBarHeight)];
        _svMenu.contentSize = [self contentSizeByTitles:_titles];
        _svMenu.showsHorizontalScrollIndicator = NO;
        _svMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _svMenu.backgroundColor = [UIColor clearColor];
        [self addSubview:_svMenu];
        
        [self createMenuButtons:_titles];
        
        UIImage *img = [UIImage imageNamed:@"info_xuanzhongerji.png"];
        _selectedBg = [[UIImageView alloc] initWithImage:img];
        CGRect rect = [self selectBgRectAtIndex:_selectedIndex];
        rect.origin = CGPointMake(CGRectGetMidX(rect)-img.size.width/2, CGRectGetMaxY(rect)-img.size.height-1);
        rect.size = img.size;
        _selectedBg.frame = rect;
        
        [_svMenu addSubview:_selectedBg];
        [_svMenu sendSubviewToBack:_selectedBg];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.4f;
        [self addSubview:line];
        
//        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        line.alpha = 0.4f;
//        [self addSubview:line];
        
        if (editable) {
            [self loadEditView];
        }
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)loadEditView
{
    UIImage *editImage = [UIImage imageNamed:@"inf_btn_edit.png"];
    _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnEdit setBackgroundImage:editImage forState:UIControlStateNormal];
    _btnEdit.contentMode = UIViewContentModeBottomRight;
    _btnEdit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_btnEdit addTarget:self action:@selector(pressEdit:) forControlEvents:UIControlEventTouchUpInside];
    _btnEdit.frame = CGRectMake(self.frame.size.width-kMultiPagingMenuEdithButtonWidth, 0, kMultiPagingMenuEdithButtonWidth, kMultiPagingMenuBarHeight);
    [self addSubview:_btnEdit];
}

- (CGRect)selectBgRectAtIndex:(NSUInteger)index{
    if (index < [_btns count]) {//asd
        UIButton *btn = [_btns objectAtIndex:index];
        return btn.frame;
    }
    
    return CGRectMake(0, 0, 0, 0);
}

- (CGSize)contentSizeByTitles:(NSArray *)titles {
    int width = kMultiPagingMenuSpace;
    int height = kMultiPagingMenuBarHeight;
    
    for (NSString *text in titles) {
        width += [text sizeWithAttributes:@{NSFontAttributeName:kMultPagingMenuFont}].width+20;
        width += kMultiPagingMenuSpace-4;
    }
    return CGSizeMake(width, height);
}

- (void)createMenuButtons:(NSArray *)titles
{
    int width = 0;//kMultiPagingMenuSpace;
    _btns = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[titles count];i++) {
        NSString *text = [titles objectAtIndex:i];
        int widthForButton = 0;
        
        widthForButton = [text sizeWithAttributes:@{NSFontAttributeName:kMultPagingMenuFont}].width+20;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:text forState:UIControlStateNormal];
        btn.frame = CGRectMake(width, (kMultiPagingMenuBarHeight-kMultiPagingMenuSelectHeight)/2, widthForButton, kMultiPagingMenuSelectHeight);
        btn.tag = i+1;
        [btn.titleLabel setFont:kMultPagingMenuFont];
        
        if (i==0) {
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:_unselectedColor forState:UIControlStateNormal];
        }

        [btn addTarget:self action:@selector(pressMenu:) forControlEvents:UIControlEventTouchUpInside];

        [_svMenu addSubview:btn];
        [_btns addObject:btn];
        
        width += widthForButton;
        width += kMultiPagingMenuSpace-4;
    }
    _svMenu.contentSize = [self contentSizeByTitles:_titles];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    
    for (UIButton *btn in _btns) {
        if (btn.tag == _selectedIndex+1) {
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:_unselectedColor forState:UIControlStateNormal];
        }
    }
}

- (void)setUnselectedColor:(UIColor *)unselectedColor
{
    _unselectedColor = unselectedColor;
    
    for (UIButton *btn in _btns) {
        if (btn.tag == _selectedIndex+1) {
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:_unselectedColor forState:UIControlStateNormal];
        }
    }
}

- (void)pressEdit:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(MSMultiPagingMenuDidPressedEdit:)]) {
        [_delegate MSMultiPagingMenuDidPressedEdit:self];
    }
}

- (void)pressMenu:(id)sender
{
    UIButton *btn = sender;
    UIButton *obtn = (UIButton *)[_svMenu viewWithTag:_selectedIndex+1];
    [obtn setTitleColor:_unselectedColor forState:UIControlStateNormal];
    obtn.titleLabel.font = kMultPagingMenuFont;
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
    btn.titleLabel.font = kMultPagingMenuFont;
    _selectedIndex = btn.tag-1;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutSelectedBg];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(MSMultiPagingMenuDidPressed:atIndex:)]) {
        [_delegate MSMultiPagingMenuDidPressed:self atIndex:_selectedIndex];
    }
}

- (void)layoutSelectedBg
{
    CGRect rect = [self selectBgRectAtIndex:_selectedIndex];
    UIImage *img = [UIImage imageNamed:@"info_xuanzhongerji.png"];
    rect.origin = CGPointMake(CGRectGetMidX(rect)-img.size.width/2, CGRectGetMaxY(rect)-img.size.height-1);
    rect.size = img.size;
    _selectedBg.frame = rect;
}

- (BOOL)commitEditWithTitles:(NSMutableArray *)titles
{
    if ([_titles count]==[titles count]) {
        BOOL isChanged = NO;
        
        for (int i=0; i<[titles count]; i++) {
            NSString *str0 = [_titles objectAtIndex:i];
            NSString *str1 = [titles objectAtIndex:i];
            if (![str0 isEqualToString:str1]) {
                isChanged = YES;
                break;
            }
        }
        
        if (!isChanged)
            return isChanged;
    }
    
    if (_titles != titles) {
        _titles = [titles mutableCopy];
        
        for (UIView *v in _btns) {
            [v removeFromSuperview];
        }
        
        _selectedIndex = 0;
        [self createMenuButtons:titles];
        [self setCurrentMenuIndex:_selectedIndex
                         animated:YES];
    }
    
    return YES;
}

- (void)setCurrentMenuIndex:(int)index
                   animated:(BOOL)animated
{
    index = MAX(0, index);
    UIButton *btn = (UIButton *)[_svMenu viewWithTag:index+1];
    UIButton *obtn = (UIButton *)[_svMenu viewWithTag:_selectedIndex+1];
    [obtn setTitleColor:_unselectedColor forState:UIControlStateNormal];
    obtn.titleLabel.font = kMultPagingMenuFont;
    
    [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.titleLabel.font = kMultPagingMenuFont;
    _selectedIndex = index;
    
    if (animated) {
        [UIView beginAnimations:@"infoScrollMenu" context:nil];
        [UIView setAnimationDuration:0.3f];
    }
    
    [self layoutSelectedBg];
    
    if (_selectedBg.frame.origin.x-_svMenu.contentOffset.x<0) {
        int x = _selectedBg.frame.origin.x-kMultiPagingMenuSpace;
        [_svMenu setContentOffset:CGPointMake(x, _svMenu.contentOffset.y)];
    }
    else if (_selectedBg.frame.origin.x+_selectedBg.frame.size.width>_svMenu.contentOffset.x+_svMenu.frame.size.width) {
        int x = _selectedBg.frame.origin.x+_selectedBg.frame.size.width-self.frame.size.width+kMultiPagingMenuEdithButtonWidth;
        [_svMenu setContentOffset:CGPointMake(x, _svMenu.contentOffset.y)];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (NSString *)titleAtIndex:(NSUInteger)index
{
    if (index<[_titles count]) {
        return [_titles objectAtIndex:index];
    }
    else{
        return @"";
    }
}

@end



@implementation MSMultiPagingSelectBgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect rt = CGRectMake(0, rect.size.height - 5, rect.size.width, 3);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFillRect(ctx, rt, [UIColor whiteColor]);
}

@end
