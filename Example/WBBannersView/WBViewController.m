//
//  WBViewController.m
//  WBBannersView
//
//  Created by 18344043066@163.com on 06/15/2017.
//  Copyright (c) 2017 18344043066@163.com. All rights reserved.
//

#import "WBViewController.h"
#import "WBBannerView.h"
#import "UIImageView+AFNetworking.h"

@interface WBViewController ()

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    WBBannerView *bannersView = [[WBBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:bannersView];

    //创建模型数据
    NSMutableArray * modelArray = [NSMutableArray new];
    WBBannerViewModel *model0 = [[WBBannerViewModel alloc] init];
    model0.imageUrl = [NSURL URLWithString:@"http://image.cnpp.cn/upload/images/20170427/1493284500_20125_9.jpg"];

    //点击图片回调
    [model0 setClickBannerImageCallBack:^(NSUInteger index) {
        NSLog(@"点击了图片 -- %zd",index);
    }];
    [modelArray addObject:model0];

    //创建模型数据
    WBBannerViewModel *model1 = [[WBBannerViewModel alloc] init];
    model1.imageUrl = [NSURL URLWithString:@"http://picture.youth.cn/qtdb/201705/W020170522261537206381.jpg"];

     //点击图片回调
    [model1 setClickBannerImageCallBack:^(NSUInteger index) {
        NSLog(@"点击了图片 -- %zd",index);
    }];
    [modelArray addObject:model1];


    //设置模型数据
    bannersView.banners = modelArray;

    //自动播放时间 / 秒
    bannersView.autoPlayTimeInterval = 2;
    

    //设置图片回调
    [bannersView setSetupImageCallBack:^(UIImageView *imageView, NSURL *url) {
        [imageView setImageWithURL:url];
    }];


}

@end
