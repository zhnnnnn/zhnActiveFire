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
- (void)zhnActiveFireViewChoseShowMore;

@end




@interface zhnAtiveFireView : UIView

// 拖动的及时百分比 小于0代表左边 大于0代表右边 绝对值0-1之间是表示没有喜欢或者喜欢 超过这个值代表选择了喜欢或者不喜欢
@property (nonatomic,assign) CGFloat showPercent;
/**
 *  重新加载数据
 */
- (void)reloadData;
/**
 *  数据源
 */
@property (nonatomic,weak) id<zhnActiveFireViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic,weak) id<zhnActiveFireViewDelegate> delegate;
@end
