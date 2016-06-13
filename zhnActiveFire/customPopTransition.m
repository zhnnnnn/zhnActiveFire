//
//  customPopTransition.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "customPopTransition.h"
#import "mainContainerViewController.h"
#import "detailViewController.h"
#import "zhnAtiveFireView.h"
@implementation customPopTransition



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    mainContainerViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
   
    
    
    detailViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    UIImageView * temp = [[UIImageView alloc]init];
    temp.image = fromVC.headView.image;
    [toVC.view addSubview:temp];
    temp.frame = fromVC.headView.frame;
    temp.contentMode = UIViewContentModeScaleAspectFill;
    temp.clipsToBounds = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
     temp.frame = [toVC.fireView.topShowImageView convertRect:toVC.fireView.topShowImageView.frame toView:fromVC.view];
    } completion:^(BOOL finished) {
        [temp removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}



@end
