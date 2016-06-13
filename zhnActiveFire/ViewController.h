//
//  ViewController.h
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhnAtiveFireView;

@protocol ViewControllerDelegate <NSObject>
@optional
- (void)viewControllerPushVc:(zhnAtiveFireView *)fireView;

@end



@interface ViewController : UIViewController

@property (nonatomic,weak) id<ViewControllerDelegate> delegate;

@end

