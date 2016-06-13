//
//  zhnAtiveFireView.h
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  数据源方法
 */
@protocol zhnActiveFireViewDataSource <NSObject>
@required
/**
 *  第index个位置显示的view
 *
 *  @param index 第几个
 *
 *  @return view
 */
- (UIView *)zhnActiveFireViewinIndex:(NSInteger)index;
/**
 *  一共有多少个数据
 *
 *  @return 多少个数据
 */
- (NSInteger)zhnActiveFireViewItemCount;
@end

/**
 *  代理方法
 */
@protocol zhnActiveFireViewDelegate <NSObject>
@optional
/**
 *  点击的最上面的view
 */
- (void)zhnActiveFireViewChoseShowMoreWithIndex:(NSInteger)showIndex;
/**
 *  滑动喜欢了第几组数据
 *
 *  @param index 第几组数据
 */
- (void)zhnActiveFireViewSwipeLikeIndex:(NSInteger)index;
/**
 *  滑动不喜欢了第几组数据
 *
 *  @param index 第几组数据
 */
- (void)zhnActiveFireViewSwipeDisLikeIndex:(NSInteger)index;

@end




@interface zhnAtiveFireView : UIView

// 拖动的及时百分比 小于0代表左边 大于0代表右边 绝对值0-1之间是表示没有喜欢或者喜欢 超过这个值代表选择了喜欢或者不喜欢(外面想要拿到这个百分比做事情就用kvo咯)
@property (nonatomic,assign) CGFloat showPercent;
/**
 *  数据源
 */
@property (nonatomic,weak) id<zhnActiveFireViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic,weak) id<zhnActiveFireViewDelegate> delegate;
/**
 *  重新加载数据
 */
- (void)reloadData;
/**
 *  直接下一张图片咯
 *
 *  @param like 是不是喜欢 (判断作用动画)
 */
- (void)nextPicWithLike:(BOOL)like;

@end
