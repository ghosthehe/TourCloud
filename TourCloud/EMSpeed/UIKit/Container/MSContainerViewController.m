//
//  MSContainerViewController.m
//  Pods
//
//  Created by flora on 16/4/13.
//
//

#import "MSContainerViewController.h"


@interface MSContainerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

static NSString *CellID = @"ControllerCell";

@implementation MSContainerViewController
@synthesize navigationView = _navigationView;

#pragma mark - collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *viewContorller = self.viewControllers[indexPath.item];
    UIView *view = [self.viewControllers[indexPath.item] view];
    [viewContorller beginAppearanceTransition:YES animated:YES];
    [cell.contentView addSubview:view];
    [viewContorller endAppearanceTransition];
    view.frame = cell.bounds;
    
    return cell;
}

#pragma mark - collectionView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    _navigationView.selectedItemIndex = index;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewContorller = self.viewControllers[indexPath.item];
    [viewContorller beginAppearanceTransition:NO animated:YES];
    [viewContorller endAppearanceTransition];
}

#pragma mark - setting

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    _selectedIndex = selectedIndex;

    if (self.navigationView &&
        selectedIndex < [self.viewControllers count])
    {
        [self.navigationView setSelectedItemIndex:selectedIndex];
    }
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    _viewControllers = viewControllers;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addChildViewController:obj];
    }];
    
    __block NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arrM addObject:obj.title ? : @""];
    }];
    
    [self navigationView].items = arrM;
}

#pragma mark - view

- (void)viewDidLayoutSubviews
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    _navigationView.frame = CGRectMake(0, 0, width, 35);
    self.collectionView.frame = CGRectMake(0, _navigationView.frame.size.height, width, height - _navigationView.frame.size.height);
    
    self.flowLayout.itemSize = self.collectionView.bounds.size;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout = flowLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    //设置collectionView的属性
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    _collectionView = collectionView;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    self.collectionView.scrollsToTop = NO;
    
    //添加导航view
    typeof(self) __weak weakObj= self;
    MSNavigationView *view = [MSNavigationView navigationViewWithItems:nil itemClick:^(NSInteger selectedIndex) {
        
        _selectedIndex = selectedIndex;
        CGFloat offsetX = weakObj.view.bounds.size.width * selectedIndex;
        weakObj.collectionView.contentOffset = CGPointMake(offsetX, 0);
        [weakObj didChangeToSelectControllerAtIndex:selectedIndex];
    }];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    _navigationView = view;
    
    __block NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arrM addObject:obj.title ? : @""];
    }];
    
    [self navigationView].items = arrM;
    if (self.selectedIndex < [arrM count]) {
        [self navigationView].selectedItemIndex = self.selectedIndex;
    }
}

- (UIViewController *)currentController
{
    if (_selectedIndex < [self.viewControllers count]) {
        return self.viewControllers[_selectedIndex];
    }
    return nil;
}

#pragma mark -
#pragma mark life cycle

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.currentController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.currentController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.currentController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Add code to clean up any of your own resources that are no longer necessary.
    if ([self isViewLoaded] && self.view.window == nil)
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.collectionView = nil;
        _navigationView = nil;
        self.flowLayout = nil;
        self.view = nil;
    }
}

- (void)didChangeToSelectControllerAtIndex:(NSInteger)index
{
    
}

@end

