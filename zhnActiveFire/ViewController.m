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
#import "UIImageView+WebCache.h"
@interface ViewController ()<zhnActiveFireViewDataSource,zhnActiveFireViewDelegate>
@property (nonatomic,weak) zhnAtiveFireView * fireView;
@property (nonatomic,strong) NSArray * imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 重新刷新
    UIButton * reloadButton = [[UIButton alloc]init];
    [self.view addSubview:reloadButton];
    reloadButton.layer.cornerRadius = 20;
    [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
    reloadButton.titleLabel.font = [UIFont systemFontOfSize:11];
    reloadButton.backgroundColor = [UIColor lightGrayColor];
    [reloadButton addTarget:self action:@selector(clickReload) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    // dislikebutton
    UIButton * dislikeButton = [[UIButton alloc]init];
    dislikeButton.layer.cornerRadius = 50;
    [self.view addSubview:dislikeButton];
    dislikeButton.backgroundColor = [UIColor greenColor];
    [dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).with.offset(-10);
        make.centerY.equalTo(reloadButton.mas_centerY).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [dislikeButton addTarget:self action:@selector(clickDisLokeButton) forControlEvents:UIControlEventTouchUpInside];
    
    // likebutton
    UIButton * likeButton = [[UIButton alloc]init];
    likeButton.layer.cornerRadius = 50;
    [self.view addSubview:likeButton];
    likeButton.backgroundColor = [UIColor redColor];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).with.offset(10);
        make.centerY.equalTo(reloadButton.mas_centerY).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    
   
    zhnAtiveFireView * fireView = [[zhnAtiveFireView alloc]init];
    [self.view addSubview:fireView];
    [fireView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 20, 200, 20));
    }];
    fireView.dataSource = self;
    fireView.delegate   = self;
    self.fireView       = fireView;
    [fireView addObserver:self forKeyPath:@"showPercent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    
//    self.imageArray = @[@"http://photocdn.sohu.com/20121112/Img357363674.jpg",@"http://image.s1979.com/allimg/130829/468_130829174629_1.jpg",@"http://www.sinaimg.cn/dy/slidenews/4_img/2013_04/704_868057_265532.jpg",@"http://cdn2.bjweekly.com/news/image2/440/12072115689429546424.jpg"];
    self.imageArray = @[@"http://a1.hoopchina.com.cn/attachment/Day_091231/176_2698549_edf68aafc659ca6.jpg",@"http://wenwen.soso.com/p/20090316/20090316192531-1838945174.jpg",@"http://img4.imgtn.bdimg.com/it/u=1196012006,634290422&fm=21&gp=0.jpg",@"http://img1.gtimg.com/2/275/27542/2754231_500x500_0.jpg",@"http://images.takungpao.com/2013/0206/20130206015558575.jpg",@"http://photocdn.sohu.com/20140402/Img397660571.jpg",@"http://ent.chinadaily.com.cn/img/attachement/jpg/site1/20150710/0023ae987ec61709d95044.jpg",@"http://s6.sinaimg.cn/mw690/001wjct9gy6Q1kOLbq5e5",@"http://img.pconline.com.cn/images/upload/upc/tx/ladyproduct/1505/14/c0/6772265_1431586682296_medium.jpg",@"http://i0.sinaimg.cn/ent/s/u/hlw/2014-11-04/U11178P28T3D4234912F326DT20141104075140.jpg"];
}

- (void)clickReload{
    self.imageArray = @[@"http://photocdn.sohu.com/20121112/Img357363674.jpg",@"http://image.s1979.com/allimg/130829/468_130829174629_1.jpg",@"http://www.sinaimg.cn/dy/slidenews/4_img/2013_04/704_868057_265532.jpg",@"http://cdn2.bjweekly.com/news/image2/440/12072115689429546424.jpg",@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNyLs1uX7WCOPKKvv5FQnkrHBQ8u2z78-j_VskY1t7KuAwxxg7",@"http://photocdn.sohu.com/20110319/Img304583698.jpg",@"http://res.ent.ifeng.com/attachments/2010/04/23/c7f67b64a4ff2d5e034870eae814b531.jpg",@"http://ugc.qpic.cn/baikepic/28350/cut-20131216145454-450569768.jpg/0",@"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTxGGInP6_KR9fhH9R4XZDS2zZbHO0T1Pkc7TRs0zTv8vi5QpV8",@"http://n.sinaimg.cn/transform/20150331/zROj-avxeafs3542797.png"];
    [self.fireView reloadData];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"showPercent"]) {
//        NSLog(@"%f",self.fireView.showPercent);
    }
    
}


#pragma  mark - 喜欢或者不喜欢咯
- (void)clickLikeButton{

    [self.fireView nextPicWithLike:YES];
    
}

- (void)clickDisLokeButton{
    [self.fireView nextPicWithLike:NO];
}


#pragma mark -  datasoruce

- (NSInteger)zhnActiveFireViewItemCount{
    
    return self.imageArray.count;
}

- (UIView *)zhnActiveFireViewinIndex:(NSInteger)index{

    UIView * tempView = [[UIView alloc]init];
    tempView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView * backImage = [[UIImageView alloc]init];
    [tempView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 100, 0));
    }];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
//    [backImage sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [backImage zhn_setImageWithUrl:self.imageArray[index] withContentMode:ZHN_contentModeTop placeHolder:[UIImage imageNamed:@"placeholder"]];
    
    return tempView;
}


#pragma mark - delegate
- (void)zhnActiveFireViewChoseShowMore{
    
}

- (void)zhnActiveFireViewSwipeLikeIndex:(NSInteger)index{
    
    NSLog(@"喜欢%lu",index);
}

- (void)zhnActiveFireViewSwipeDisLikeIndex:(NSInteger)index{
    NSLog(@"不喜欢%lu",index);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
