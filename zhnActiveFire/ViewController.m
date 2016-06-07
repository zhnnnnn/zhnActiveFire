//
//  ViewController.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "zhnAtiveFireView.h"
#import "Masonry.h"
#import "UIImageView+ZHNimageCache.h"
@interface ViewController ()<zhnActiveFireViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zhnAtiveFireView * fireView = [[zhnAtiveFireView alloc]init];
    [self.view addSubview:fireView];
    [fireView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 20, 200, 20));
    }];
    fireView.dataSource = self;
}

- (NSInteger)zhnActiveFireViewItemCount{
    
    return 4;
}

- (UIView *)zhnActiveFireViewinIndex:(NSInteger)index{

    UIView * tempView = [[UIView alloc]init];
    tempView.backgroundColor = [UIColor greenColor];
    
    UIImageView * backImage = [[UIImageView alloc]init];
    [tempView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    backImage.contentMode = UIViewContentModeScaleToFill;
    [backImage zhn_setImageWithUrl:@"http://1.hoopchina.com.cn/attachment/Day_091231/176_2698549_edf68aafc659ca6.jpg" withContentMode:ZHN_contentModeCenter placeHolder:[UIImage imageNamed:@"tutu"]];
    
    return tempView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
