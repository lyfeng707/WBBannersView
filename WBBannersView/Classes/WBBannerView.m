//
//  WBBannerView.m
//  Woober
//
//  Created by Billy on 2017/6/13.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WBBannerView.h"

static NSUInteger const kItemScale = 50;
@interface WBBannerViewCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *imageView;
@end
//2017.9.4
@implementation WBBannerViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.frame = self.contentView.bounds;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end


@interface WBBannerView()<UICollectionViewDelegate , UICollectionViewDataSource>
{
    NSUInteger _numberOfItems;
    NSUInteger _currentPage;
}
@property(nonatomic,strong) UICollectionView *bannersCollectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong) NSTimer *scrollTimer;
@end

@implementation WBBannerView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.bannersCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.bannersCollectionView.frame = self.bounds;
        [self addSubview:self.bannersCollectionView];

        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat centerX = self.frame.size.width / 2.f;
    CGFloat centerY = self.frame.size.height - 10 - self.pageControl.frame.size.height / 2.f;
    self.pageControl.center = CGPointMake(centerX, centerY);
    //直接设置约束时需要设置collectionView的layout
    self.flowLayout.itemSize = self.frame.size;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //直接设置frame时需要设置collectionView的layout （用autolayout时 ，传进的frame不正确需要在 layoutSubviews 设置）
    self.flowLayout.itemSize = frame.size;
}

- (void)setBanners:(NSArray<WBBannerViewModel *> *)banners
{
    _banners = banners;

    self.pageControl.numberOfPages = _banners.count;

    _numberOfItems = _banners.count * kItemScale;

    [self.bannersCollectionView reloadData];



    if (banners.count <= 1) {
        self.scrollEnable  = NO;
        self.pageControl.hidden = YES;
    }


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bannersCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_banners.count * kItemScale / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    self.bannersCollectionView.scrollEnabled = scrollEnable;
}

- (void)setAutoPlayTimeInterval:(NSTimeInterval)autoPlayTimeInterval
{
    _autoPlayTimeInterval = autoPlayTimeInterval;

    [self scrollTimer];
}

- (void)autoScrollNextPage {
    //    NSInteger page = _currentPage + 1;
    //    [self.bannersCollectionView setContentOffset:CGPointMake(self.bannersCollectionView.frame.size.width * page, 0) animated:YES];
    //    [self.bannersCollectionView setContentOffset:CGPointMake(self.bannersCollectionView.contentOffset.x + self.frame.size.width, 0) animated:YES];
    NSUInteger nextItem = (self.bannersCollectionView.contentOffset.x  /  self.frame.size.width ) + 1;
    [self.bannersCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}


#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
static NSString *const ID = @"bannersCollectionViewID";
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBBannerViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    if (self.setupImageCallBack) {
        self.setupImageCallBack(cell.imageView , self.banners[indexPath.row % self.banners.count].imageUrl);
    }


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row % self.banners.count;
    WBBannerViewModel *model = self.banners[index];
    if (model.clickBannerImageCallBack) {
        model.clickBannerImageCallBack(index);
    }
}

#pragma mark - UISCrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.banners.count > 1) {
        [self scrollTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];

}

- (void)caculateCurrentPage: (UIScrollView *)scrollView {

    if (self.banners.count == 0) {
        return;
    }
    if (self.banners.count == 1) {
        _currentPage = 1;
        return;
    }
    // 确认中间区域
    NSInteger min = self.banners.count * (kItemScale / 2 - 1);
    NSInteger max = self.banners.count * (kItemScale / 2 + 1);

    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page % self.banners.count;

    if (page < min || page > max) {
        page = min + page % self.banners.count;

        [scrollView setContentOffset:CGPointMake(page * scrollView.frame.size.width, 0) animated:NO];

    }

    _currentPage = page;

}



#pragma mark - getter
-(UICollectionView *)bannersCollectionView
{
    if (_bannersCollectionView == nil) {
        _bannersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _bannersCollectionView.backgroundColor = [UIColor clearColor];
        _bannersCollectionView.pagingEnabled = YES;
        _bannersCollectionView.showsHorizontalScrollIndicator = NO;
        _bannersCollectionView.showsVerticalScrollIndicator = NO;
        [_bannersCollectionView registerClass:[WBBannerViewCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _bannersCollectionView.dataSource = self;
        _bannersCollectionView.delegate = self;
        [self addSubview:_bannersCollectionView];

    }
    return _bannersCollectionView;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

-(WBPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[WBPageControl alloc] init];
        _pageControl.currentPageIndicateImage = [UIImage imageNamed:@"currentPage"];
        _pageControl.otherPageIndicateImage = [UIImage imageNamed:@"otherPage"];

    }
    return _pageControl;
}

-(NSTimer *)scrollTimer {
    if (_scrollTimer == nil && _autoPlayTimeInterval > 0 && self.banners.count > 1) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoPlayTimeInterval target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
    return _scrollTimer;
}

@end

@implementation WBBannerViewModel
@end
