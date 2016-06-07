//
//  ZHNunlimitedCarouselView.m
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNunlimitedCarouselView.h"
#import "ZHNunlimitedCell.h"
#import "UIImageView+ZHNimageCache.h"
#import "ZHNwebImageCache.h"
#define  zhnCell @"cell"
#define zhnMaxSections 100

@interface ZHNunlimitedCarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIImage * placeholderImage;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , assign) ZHN_contentMode imageContentMode;
@property (nonatomic , assign) pageControlMode zhnPageControlMode;
@property (nonatomic , assign) NSInteger timeIvatel;
@property (nonatomic , copy) ZhnCarouselViewDidSelectItemBlock didSelecItemBlock;

@end




@implementation ZHNunlimitedCarouselView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initViewWithFrame:frame];
    }
    return self;
}

- (void)initViewWithFrame:(CGRect)frame{
   
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    
    _collectionView=collectionView;
    
    UIPageControl * pageCtl = [[UIPageControl alloc]init];
    [self addSubview:pageCtl];
    self.pageControl = pageCtl;
    self.pageControl.userInteractionEnabled = NO;
    
    [self.collectionView registerClass:[ZHNunlimitedCell class] forCellWithReuseIdentifier:zhnCell];
}

- (void)setTimeIvatel:(NSInteger)timeIvatel{
    
    _timeIvatel = timeIvatel;
    [self addTimer];
}

- (void)setPageControlNormalColor:(UIColor *)pageControlNormalColor{
    _pageControlNormalColor = pageControlNormalColor;
    self.pageControl.pageIndicatorTintColor = pageControlNormalColor;
}

- (void)setPageControlSelectColor:(UIColor *)pageControlSelectColor{
    _pageControlSelectColor = pageControlSelectColor;
    self.pageControl.currentPageIndicatorTintColor = pageControlSelectColor;
}

- (void)setZhnPageControlMode:(pageControlMode)zhnPageControlMode{
    _zhnPageControlMode = zhnPageControlMode;
    self.pageControl.numberOfPages = self.imageArray.count;
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.imageArray.count];
    if (zhnPageControlMode == pageControlModeLeft) {
        
        self.pageControl.frame = CGRectMake(20, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }else if(zhnPageControlMode == pageControlModeRight){
        
        self.pageControl.frame = CGRectMake(self.frame.size.width - 20 - pageSize.width, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }else if(zhnPageControlMode == pageControlModeCenter){
        
        self.pageControl.frame = CGRectMake((self.frame.size.width - pageSize.width)/2, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }
}


- (void)setImageArray:(NSArray *)imageArray{
    
    _imageArray = imageArray;
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:zhnMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeIvatel target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:zhnMaxSections /2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.imageArray.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return zhnMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZHNunlimitedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zhnCell forIndexPath:indexPath];
    [cell.backImageView zhn_setImageWithUrl:self.imageArray[indexPath.row] withContentMode:self.imageContentMode placeHolder:self.placeholderImage];
    return cell;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.didSelecItemBlock) {
        self.didSelecItemBlock(self.pageControl.currentPage);
    }
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.imageArray.count;
    self.pageControl.currentPage =page;
}



+ (instancetype)zhn_instanceCarouselViewUseImageArray:(NSArray *)imageArray frame:(CGRect)frame placeHolder:(UIImage *)placeHolderImage imageContentMode:(ZHN_contentMode)contentMode pageControlMode:(pageControlMode)ctrolMode timerTime:(NSInteger)timeInterval didSelectItemBlock:(ZhnCarouselViewDidSelectItemBlock)selectItemBlock{

    ZHNunlimitedCarouselView * carouselView = [[ZHNunlimitedCarouselView alloc]initWithFrame:frame];
    carouselView.imageArray = imageArray;
    carouselView.zhnPageControlMode = ctrolMode;
    carouselView.imageContentMode = contentMode;
    carouselView.timeIvatel = timeInterval;
    carouselView.didSelecItemBlock = selectItemBlock;
    carouselView.placeholderImage = placeHolderImage;
    
    return carouselView;
}


- (void)clearCache{
    [[ZHNwebImageCache shareInstance] zhnWebImageCache_clearImages];
}



@end
