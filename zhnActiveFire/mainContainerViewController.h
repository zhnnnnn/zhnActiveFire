//
//  mainContainerViewController.h
//  zhnActiveFire
//
//  Created by zhn on 16/6/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhnAtiveFireView;
@interface mainContainerViewController : UIViewController

@property (nonatomic,weak) UIView * fakeNaviBar;
@property (nonatomic,strong) zhnAtiveFireView * fireView;

@end
