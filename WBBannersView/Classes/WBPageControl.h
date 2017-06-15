//
//  WBPageControl.h
//  Woober
//
//  Created by Billy on 2017/6/13.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBPageControl : UIView

@property (nonatomic,assign) NSUInteger currentPage;
@property (nonatomic,assign) NSUInteger numberOfPages;
@property (nonatomic,strong) UIImage *currentPageIndicateImage;
@property (nonatomic,strong) UIImage *otherPageIndicateImage;

@end
