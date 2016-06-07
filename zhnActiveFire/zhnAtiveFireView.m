//
//  zhnAtiveFireView.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnAtiveFireView.h"
#import "UIImageView+ZHNimageCache.h"
#import "Masonry.h"
#import <objc/runtime.h>
// 最顶上的view
#define topView [self.subviews lastObject]
// 顶上view上面提示喜欢的view
#define noticeLikeView topView.subviews.firstObject.subviews[1]
// 顶上view上面提示不喜欢的view
#define noticeDisLikeView topView.subviews.firstObject.subviews.lastObject
// 显示内容的view
#define showContentView topView.subviews.firstObject.subviews.firstObject
static const CGFloat KWpadding = 10;// x轴上的padding
static const CGFloat KHpadding = 5;// y轴上的padding
static const CGFloat KRotashakeRange = 0.0005;// 拖动转动的幅度
static const CGFloat kLikeDislikePercent = 0.5;// 在百分之多少的情况是选择成功
static const CGFloat KnoticeViewWidthHeight = 50;// 喜欢喝不喜欢提示的view的 宽高
@interface zhnAtiveFireView()
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) NSInteger currentCount;// 有多少个数据
@property (nonatomic,assign) NSInteger currentIndex;// 当前最上面显示的是第几组数据
@property (nonatomic,assign) CGPoint topViewOldCenter;
@property (nonatomic,strong) NSMutableArray * subViewOldSizeArry;
@property (nonatomic,strong) NSMutableArray * subViewOldCenterArray;
@property (nonatomic,strong) UITapGestureRecognizer * tapGes;

@end



@implementation zhnAtiveFireView

- (NSMutableArray *)subViewOldSizeArry{
    
    if (_subViewOldSizeArry == nil) {
        _subViewOldSizeArry = [NSMutableArray array];
    }
    return _subViewOldSizeArry;
}
- (NSMutableArray *)subViewOldCenterArray{
    if (_subViewOldCenterArray == nil) {
        _subViewOldCenterArray = [NSMutableArray array];
    }
    return _subViewOldCenterArray;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self initGesture];
    
    if (!objc_getAssociatedObject(self, @"KonceTimeKey")) {
       
        CGFloat subViewWidth = self.frame.size.width;
        CGFloat subViewHeight = self.frame.size.height;
        
       
        if ([self.dataSource zhnActiveFireViewItemCount] > 3) {
            self.currentCount = [self.dataSource zhnActiveFireViewItemCount];
            self.currentIndex = 0;
            for (int index = 0; index < 4; index++) {
                // 最外面的容器view
                UIView * tempView = [[UIView alloc]init];
                CGFloat tempViewX = (3-index) * KWpadding;
                CGFloat tempViewY = (3-index) * KHpadding;
                CGFloat tempViewHeight = subViewHeight - 2 * KHpadding;
                CGFloat tempViewWidth = subViewWidth - (3-index)*2 * KWpadding;
            
                if (index == 0) {
                    tempViewY = tempViewY - KHpadding;
                }
                tempView.frame = CGRectMake(tempViewX, tempViewY, tempViewWidth, tempViewHeight);
                [self addSubview:tempView];
                
                // backgroundview
                UIView * backView = [[UIView alloc]init];
                [tempView addSubview:backView];
                backView.layer.borderColor = [UIColor blackColor].CGColor;
                backView.layer.borderWidth = 1;
                backView.layer.cornerRadius = 5;
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                backView.backgroundColor = [UIColor redColor];
                
                // 内容
                UIView * contentView = [self.dataSource zhnActiveFireViewinIndex:index];
                [backView addSubview:contentView];
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                
                UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseShowMore:)];
                self.tapGes = tapGes;
                [contentView addGestureRecognizer:tapGes];
                
                // 喜欢的view
                UIImageView * likeView = [[UIImageView alloc]init];
                [backView addSubview:likeView];
                likeView.backgroundColor = [UIColor blackColor];
                [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(backView.mas_top).with.offset(10);
                    make.left.equalTo(backView.mas_left).with.offset(10);
                    make.size.mas_equalTo(CGSizeMake(KnoticeViewWidthHeight, KnoticeViewWidthHeight));
                }];
                likeView.hidden = YES;
                
                // 不喜欢的view
                UIImageView * dislikeView = [[UIImageView alloc]init];
                [backView addSubview:dislikeView];
                dislikeView.backgroundColor = [UIColor yellowColor];
                [dislikeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(backView.mas_top).with.offset(10);
                    make.right.equalTo(backView.mas_right).with.offset(-10);
                    make.size.mas_equalTo(CGSizeMake(KnoticeViewWidthHeight, KnoticeViewWidthHeight));
                }];
                dislikeView.hidden = YES;
                

                [self.subViewOldSizeArry addObject:[NSValue valueWithCGSize:CGSizeMake(tempViewWidth, tempViewHeight)]];
                [self.subViewOldCenterArray addObject:[NSValue valueWithCGPoint:tempView.center]];
            }
            
        }
        objc_setAssociatedObject(self, @"KonceTimeKey", @"YES", OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)choseShowMore:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(zhnActiveFireViewChoseShowMore)]) {
        [self.delegate zhnActiveFireViewChoseShowMore];
    }
}


// 初始化手势
- (void)initGesture{
    
    UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheView:)];
    [self addGestureRecognizer:panGes];
}

// 拖动手势的处理
- (void)panTheView:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _topViewOldCenter = topView.center;
        _startPoint = [pan locationInView:self];
        self.tapGes.enabled = NO;
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [pan locationInView:self];
        
        CGFloat xdelta = currentPoint.x - _startPoint.x;
        CGFloat ydelta = currentPoint.y - _startPoint.y;
        self.showPercent = xdelta/(self.frame.size.width * kLikeDislikePercent);
        CGFloat scale= xdelta * KRotashakeRange * M_PI;
        CGFloat maxDelta = fabs(xdelta) > fabs(ydelta) ? fabs(xdelta):fabs(ydelta);
        CGFloat transLationY = maxDelta/(self.frame.size.width * kLikeDislikePercent)* KHpadding;
        // 最上面的view
        [topView.subviews firstObject].transform = CGAffineTransformMakeRotation(scale);
        topView.center = CGPointMake(_topViewOldCenter.x + xdelta, _topViewOldCenter.y + ydelta);
        
        if (self.showPercent > 0.5) {
            noticeLikeView.hidden= NO;
            noticeDisLikeView.hidden= YES;
        }
        if (self.showPercent < -0.5) {
            noticeLikeView.hidden= YES;
            noticeDisLikeView.hidden= NO;
        }
        
        
        // 下面的三个view
        if (transLationY <= KHpadding) {
            int maxCount = self.currentCount > (self.currentIndex+3)? 3:(int)(self.currentCount - self.currentIndex -1);
            for (int index = 0; index < maxCount; index ++) {
                CGPoint oldCenter;
                CGSize subViewSize;
                if (maxCount == 3) {
                    oldCenter = [self.subViewOldCenterArray[index]CGPointValue];
                    subViewSize =  [self.subViewOldSizeArry[index] CGSizeValue];
                }else{
                    oldCenter = [self.subViewOldCenterArray[index + (3-maxCount)]CGPointValue];
                    subViewSize = [self.subViewOldSizeArry[index + (3-maxCount)]CGSizeValue];
                }
                
                self.subviews[index].bounds = CGRectMake(0, 0, subViewSize.width + (2 * transLationY), subViewSize.height);
                if (maxCount == 3) {
                    if (index > 0) {
                        self.subviews[index].center = CGPointMake(oldCenter.x, oldCenter.y - transLationY);
                    }
                }else{
                        self.subviews[index].center = CGPointMake(oldCenter.x, oldCenter.y - transLationY);
                }
            }
        }
    }
    
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        
        // 一些必要的赋值
        self.tapGes.enabled = YES;
        noticeDisLikeView.hidden = YES;
        noticeLikeView.hidden = YES;
        
        CGPoint currentPoint = [pan locationInView:self];
        CGFloat xdelta = currentPoint.x - _startPoint.x;
        if (fabs(xdelta/self.frame.size.width)> kLikeDislikePercent) {// 超过边界（喜欢或者不喜欢）
            self.currentIndex += 1;
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                topView.center = CGPointMake(xdelta * 50, 0);
            } completion:^(BOOL finished) {
                
                if (self.currentIndex + 4 > self.currentCount) {// 数据少于四组的情况
                    [topView removeFromSuperview];
                    return ;
                }
                
                [topView.subviews firstObject].transform = CGAffineTransformIdentity;
                CGSize topCurrentSize = [self.subViewOldSizeArry[0]CGSizeValue];
                topView.center = [self.subViewOldCenterArray[0]CGPointValue];
                topView.bounds = CGRectMake(0, 0, topCurrentSize.width, topCurrentSize.height);
                
                [showContentView removeFromSuperview];
                UIView * contentView = [self.dataSource zhnActiveFireViewinIndex:self.currentIndex + 3];
                [self.subviews.lastObject.subviews.firstObject insertSubview:contentView atIndex:0];
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                [self insertSubview:topView atIndex:0];

            }];
            
        }else{// 没有超过边界
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseIn animations:^{
                topView.center = _topViewOldCenter;
                [topView.subviews firstObject].transform = CGAffineTransformIdentity;
                int maxCount = self.currentCount > (self.currentIndex+3)? 3:(int)(self.currentCount - self.currentIndex -1);
               
                for (int index = 0; index < maxCount+1; index ++) {
                    self.subviews[index].transform = CGAffineTransformIdentity;
                    CGPoint oldCenter;
                    CGSize subViewSize;
                    if (maxCount == 3) {
                        oldCenter = [self.subViewOldCenterArray[index]CGPointValue];
                        subViewSize =  [self.subViewOldSizeArry[index] CGSizeValue];
                    }else{
                        oldCenter = [self.subViewOldCenterArray[index + (3-maxCount)]CGPointValue];
                        subViewSize = [self.subViewOldSizeArry[index + (3-maxCount)]CGSizeValue];
                    }
                    
                    self.subviews[index].bounds = CGRectMake(0, 0, subViewSize.width, subViewSize.height);
                    self.subviews[index].center = oldCenter;
                    
                }
            } completion:^(BOOL finished) {
                
            }];
        }  
    }
}

@end
