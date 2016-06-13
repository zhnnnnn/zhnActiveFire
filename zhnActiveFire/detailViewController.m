//
//  detailViewController.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "detailViewController.h"
#import "customPopTransition.h"

@interface detailViewController ()<UINavigationControllerDelegate>

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView * headView = [[UIImageView alloc]init];
    headView.contentMode = UIViewContentModeScaleAspectFill;
//    backImage.contentMode = UIViewContentModeScaleAspectFill;
    headView.clipsToBounds = YES;
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor redColor];
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 400);
    self.headView  = headView;
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheView)];
    [headView addGestureRecognizer:tap];
    
    self.navigationController.delegate = self;
}

- (void)tapTheView{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    return [[customPopTransition alloc]init];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
