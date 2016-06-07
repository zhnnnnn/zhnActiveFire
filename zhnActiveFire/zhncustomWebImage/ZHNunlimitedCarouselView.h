//
//  ZHNunlimitedCarouselView.h
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ZHNimage.h"

typedef void (^ZhnCarouselViewDidSelectItemBlock)(NSInteger index);
typedef NS_ENUM(NSInteger,pageControlMode){
    
    pageControlModeLeft,
    pageControlModeCenter,
    pageControlModeRight
};


@interface ZHNunlimitedCarouselView : UIView

// pagecontrol的普通颜色
@property (nonatomic,strong) UIColor * pageControlNormalColor;
// pagecontrol的选中的颜色
@property (nonatomic,strong) UIColor * pageControlSelectColor;
/**
 *  轮播图的实例方法
 *
 *  @param imageArray       图片数组
 *  @param frame            轮播的位置
 *  @param placeHolderImage 占位图片 （占位图片一定要设置的）
 *  @param contentMode      图片的显示模式
 *  @param ctrolMode        pagectrol的显示位置
 *  @param timeInterval     自动轮播的时长
 *  @param selectItemBlock  点击事件的block回调
 *
 *  @return 轮播实例
 */
+ (instancetype)zhn_instanceCarouselViewUseImageArray:(NSArray *)imageArray frame:(CGRect)frame placeHolder:(UIImage *)placeHolderImage imageContentMode:(ZHN_contentMode)contentMode pageControlMode:(pageControlMode)ctrolMode timerTime:(NSInteger)timeInterval didSelectItemBlock:(ZhnCarouselViewDidSelectItemBlock)selectItemBlock;

/**
 *  清空缓存
 */
- (void)clearCache;
@end
