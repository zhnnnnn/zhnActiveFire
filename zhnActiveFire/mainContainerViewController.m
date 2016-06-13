//
//  mainContainerViewController.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "mainContainerViewController.h"
#import "ViewController.h"
#import "detailViewController.h"
#import "custonTransition.h"
#import "zhnAtiveFireView.h"
@interface mainContainerViewController ()<ViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) UIScrollView * backScrollview;
@end

@implementation mainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:backScrollView];
    backScrollView.frame = self.view.bounds;
    backScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height-24);
    backScrollView.backgroundColor = [UIColor blueColor];
    backScrollView.pagingEnabled = YES;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    self.backScrollview = backScrollView;
    [self addChildViewControllers];

    
    self.navigationController.navigationBar.hidden = YES;
    UIView * fakeNaviBar = [[UIView alloc]init];
    self.fakeNaviBar = fakeNaviBar;
    [self.view addSubview:fakeNaviBar];
    fakeNaviBar.backgroundColor = [UIColor redColor];
    fakeNaviBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
}

- (void)addChildViewControllers{
    
    // 左边
    UIViewController * leftVC = [[UIViewController alloc]init];
    leftVC.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:leftVC];
    [self.backScrollview addSubview:leftVC.view];
    leftVC.view.frame = self.view.bounds;
    
    // 中间
    ViewController * centVC = [[ViewController alloc]init];
    [self addChildViewController:centVC];
    [self.backScrollview addSubview:centVC.view];
    centVC.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    centVC.delegate = self;
    // 右边
    UIViewController * rightVC = [[UIViewController alloc]init];
    rightVC.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:rightVC];
    [self.backScrollview addSubview:rightVC.view];
    rightVC.view.frame = CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}


- (void)viewControllerPushVc:(zhnAtiveFireView *)fireView{
    
    self.fireView = fireView;
    detailViewController * detailVC = [[detailViewController alloc]init];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
   
    return [[custonTransition alloc]init];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
