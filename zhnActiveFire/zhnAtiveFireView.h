//
//  zhnAtiveFireView.h
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol zhnActiveFireViewDataSource <NSObject>
@required
- (UIView *)zhnActiveFireViewinIndex:(NSInteger)index;
- (NSInteger)zhnActiveFireViewItemCount;
@end


@protocol zhnActiveFireViewDelegate <NSObject>
@optional
- (void)zhnActiveFireViewChoseShowMore;

@end




@interface zhnAtiveFireView : UIView


//- (instancetype)initWithHotGirlsImageArray:(NSArray <NSString *> *)girlImageArray frame:(CGRect)frame;
//+ (instancetype)zhnActiveFireWithHotGirlsImageArray:(NSArray <NSString *> *)girlImageArray frame:(CGRect)frame;
// 拖动的及时百分比 小于0代表左边 大于0代表右边 绝对值0-1之间是表示没有喜欢或者喜欢 超过这个值代表选择了喜欢或者不喜欢
@property (nonatomic,assign) CGFloat showPercent;

@property (nonatomic,weak) id<zhnActiveFireViewDataSource> dataSource;
@property (nonatomic,weak) id<zhnActiveFireViewDelegate> delegate;
@end
