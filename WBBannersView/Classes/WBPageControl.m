//
//  WBPageControl.m
//  Woober
//
//  Created by Billy on 2017/6/13.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WBPageControl.h"

@implementation WBPageControl
{
    CGSize _fitSize;
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;

    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        UIButton *subview = (UIButton *)self.subviews[i];
        if (currentPage == i) {
            [subview setImage:_currentPageIndicateImage forState:UIControlStateNormal];
        }else{
            [subview setImage:_otherPageIndicateImage forState:UIControlStateNormal];
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    CGPoint originalPoint = frame.origin;
    frame = CGRectMake(originalPoint.x, originalPoint.y, _fitSize.width,_fitSize.height);
    [super setFrame:frame];
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    CGFloat  height = _currentPageIndicateImage.size.height > _otherPageIndicateImage.size.height ?  _currentPageIndicateImage.size.height :  _otherPageIndicateImage.size.height;
    CGFloat kButtonMargin = 5.f;
    for (NSUInteger i = 0; i < numberOfPages; i++) {
        UIButton *indicateBtn = [[UIButton alloc] init];

        [self addSubview:indicateBtn];

        CGFloat x = i * (height + kButtonMargin);
        indicateBtn.frame = CGRectMake(x, 0, height, height);
    }

    _fitSize = CGSizeMake(height * numberOfPages + (numberOfPages - 1) * kButtonMargin , height);
    CGPoint originalPoint = self.frame.origin;
    self.frame = CGRectMake(originalPoint.x, originalPoint.y, _fitSize.width,_fitSize.height);
    self.currentPage = 0;
}

@end
