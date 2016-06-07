//
//  ViewController.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "zhnAtiveFireView.h"
#import "zhnShowImageView.h"
#import "Masonry.h"
#import "UIImageView+ZHNimageCache.h"
@interface ViewController ()<zhnActiveFireViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zhnAtiveFireView * fireView = [zhnAtiveFireView zhnActiveFireWithHotGirlsImageArray:@[@"ddada",@"dadada",@"dada",@"dada",@"daaqq"] frame:CGRectMake(100, 100, 300, 400)];
    [self.view addSubview:fireView];
    fireView.dataSource = self;
}

- (NSInteger)zhnActiveFireViewItemCount{
    
    return 10;
}

- (UIView *)zhnActiveFireViewinIndex:(NSInteger)index{

    UIView * tempView = [[UIView alloc]init];
    tempView.backgroundColor = [UIColor greenColor];
    
    zhnShowImageView * backImage = [[zhnShowImageView alloc]init];
    [tempView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    [backImage zhn_setImageWithUrl:@"aa" withContentMode:ZHN_contentModeCenter placeHolder:[UIImage imageNamed:@"tutu"]];
    
    return tempView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
