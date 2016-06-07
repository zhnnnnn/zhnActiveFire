//
//  zhnAtiveFireView.m
//  zhnActiveFire
//
//  Created by zhn on 16/6/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnAtiveFireView.h"
#import "zhnShowImageView.h"
#import "UIImageView+ZHNimageCache.h"
#import "Masonry.h"
#import <objc/runtime.h>
#define topView [self.subviews lastObject]

static const CGFloat KWpadding = 10;
static const CGFloat KHpadding = 10;
static const CGFloat KRotashakeRange = 0.0005;
static const CGFloat kLikeDislikePercent = 0.5;
static const CGFloat KnoticeViewWidthHeight = 50;
@interface zhnAtiveFireView()
@property (nonatomic,copy) NSArray * girlImageArray;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint topViewOldCenter;

@property (nonatomic,strong) NSMutableArray * subViewOldSizeArry;
@property (nonatomic,strong) NSMutableArray * subViewOldCenterArray;

@property (nonatomic,strong) UITapGestureRecognizer * tapGes;
@end



@implementation zhnAtiveFireView

- (instancetype)initWithHotGirlsImageArray:(NSArray <NSString *> *)girlImageArray frame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.girlImageArray = girlImageArray;
        
        [self initGesture];
    }
    return self;
}

+ (instancetype)zhnActiveFireWithHotGirlsImageArray:(NSArray <NSString *> *)girlImageArray frame:(CGRect)frame{
    return [[self alloc]initWithHotGirlsImageArray:girlImageArray frame:frame];
}

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
    
    if (!objc_getAssociatedObject(self, @"KonceTimeKey")) {
       
        CGFloat subViewWidth = self.frame.size.width;
        CGFloat subViewHeight = self.frame.size.height;
        if ([self.dataSource zhnActiveFireViewItemCount] > 3) {
            
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
        // 下面的三个view
        if (transLationY <= KHpadding) {
            for (int index = 0; index < 3; index ++) {
                CGPoint oldCenter = [self.subViewOldCenterArray[index]CGPointValue];
                CGSize subViewSize =  [self.subViewOldSizeArry[index] CGSizeValue];
                self.subviews[index].bounds = CGRectMake(0, 0, subViewSize.width + (2 * transLationY), subViewSize.height);
                if (index > 0) {
                      self.subviews[index].center = CGPointMake(oldCenter.x, oldCenter.y - transLationY);
                }
            }
        }
    }
    
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        
        self.tapGes.enabled = YES;
        CGPoint currentPoint = [pan locationInView:self];
        CGFloat xdelta = currentPoint.x - _startPoint.x;
        if (fabs(xdelta/self.frame.size.width)> kLikeDislikePercent) {// 超过边界（喜欢或者不喜欢）
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                topView.center = CGPointMake(xdelta * 50, 0);
            } completion:^(BOOL finished) {
                
                [topView.subviews firstObject].transform = CGAffineTransformIdentity;
                CGSize topCurrentSize = [self.subViewOldSizeArry[0]CGSizeValue];
                topView.center = [self.subViewOldCenterArray[0]CGPointValue];
                topView.bounds = CGRectMake(0, 0, topCurrentSize.width, topCurrentSize.height);
                
                [self insertSubview:topView atIndex:0];
            }];
            
        }else{// 没有超过边界
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseIn animations:^{
                topView.center = _topViewOldCenter;
                [topView.subviews firstObject].transform = CGAffineTransformIdentity;
                for (int index = 0; index < 3; index ++) {
                    self.subviews[index].transform = CGAffineTransformIdentity;
                    if (index > 0) {
                        CGSize subViewSize =  [self.subViewOldSizeArry[index] CGSizeValue];
                        CGPoint subViewCenter = [self.subViewOldCenterArray[index] CGPointValue];
                        self.subviews[index].bounds = CGRectMake(0, 0, subViewSize.width, subViewSize.height);
                        self.subviews[index].center = subViewCenter;
                    }
                }
            } completion:^(BOOL finished) {
                
            }];
        }  
    }
}

@end
