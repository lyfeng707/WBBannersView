//
//  WBBannerView.h
//  Woober
//
//  Created by Billy on 2017/6/13.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBPageControl.h"

@interface WBBannerViewModel : NSObject
/** 设置图片的URL */
@property(nonatomic,strong) NSURL *imageUrl;

@property(nonatomic,copy) void(^clickBannerImageCallBack)(NSUInteger index);
@end


@interface WBBannerView : UIView

@property (nonatomic,strong) NSArray <WBBannerViewModel *> *banners;

@property(nonatomic,strong)  WBPageControl *pageControl;

/** 设置的数值 <= 0 不会自动轮播 */
@property (nonatomic,assign) NSTimeInterval autoPlayTimeInterval;

/** 设置下载图片回调 - 必须赋值才能下载显示图片 */
@property(nonatomic,copy) void(^setupImageCallBack)(UIImageView *imageView , NSURL *imageUrl);

@property(nonatomic,assign) BOOL scrollEnable;
@end

