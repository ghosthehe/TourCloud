//
//  MainPageHotCell.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MainPageHotCell.h"
#import "TCMainPageParserItem.h"
#import "TCMainPageTypeCollectionCell.h"

@interface MainPageHotCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *typeTitles;
@property (nonatomic, strong) NSArray *typeImages;

@end

@implementation MainPageHotCell

- (void)awakeFromNib {
    // Initialization code
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 4;

    self.typesCollection.collectionViewLayout = flowLayout;
    
    [self.typesCollection registerNib:[UINib nibWithNibName:@"TCMainPageTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TCMainPageTypeCollectionCell"];
    
}

- (void)update:(id<MSCellModel>)cellModel
{
    if ([cellModel isKindOfClass:[TCMainPageParserItem class]]) {
        
        self.typeTitles = @[@"线路", @"场馆", @"服务", @"景点", @"活动"];
        self.typeImages = @[@"乐游上海1_07", @"乐游上海1_09", @"乐游上海1_11", @"乐游上海1_13", @"乐游上海1_20"];
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 85);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.typeTitles count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCMainPageTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCMainPageTypeCollectionCell" forIndexPath:indexPath];

    cell.typeTitleLabel.text = self.typeTitles[indexPath.row];
    cell.typeTitleImage.image = [UIImage imageNamed:self.typeImages[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
