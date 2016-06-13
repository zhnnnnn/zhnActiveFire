//
//  custonTransition.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "custonTransition.h"
#import "mainContainerViewController.h"
#import "detailViewController.h"
#import "zhnAtiveFireView.h"

@implementation custonTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.3;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    mainContainerViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    detailViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    UIView * tempFakeNavi = [fromVC.fakeNaviBar snapshotViewAfterScreenUpdates:YES];
    [toVC.view addSubview:tempFakeNavi];
    tempFakeNavi.frame = [fromVC.fakeNaviBar convertRect:fromVC.fakeNaviBar.frame toView:toVC.view];
    

    toVC.headView.hidden = YES;

    UIImageView * tempView = [[UIImageView alloc]init];
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    tempView.image = fromVC.fireView.topShowImageView.image;
    [toVC.view addSubview:tempView];
    CGRect oldRect = [fromVC.fireView.topShowImageView convertRect:fromVC.fireView.topShowImageView.frame toView:toVC.view];
    tempView.frame = oldRect;
    
    
    NSTimeInterval time = [self transitionDuration:transitionContext];
    CGPoint oldCenter = tempFakeNavi.center;
    
    [UIView animateWithDuration:time animations:^{
        
        tempFakeNavi.center = CGPointMake(oldCenter.x, oldCenter.y - 64);
        tempView.frame = toVC.headView.frame;
        
    } completion:^(BOOL finished) {
        
        toVC.headView.image = fromVC.fireView.topShowImageView.image;
        toVC.headView.hidden = NO;
        
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
    
    
}



@end
