//
//  ZHNunlimitedCell.m
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNunlimitedCell.h"

@interface ZHNunlimitedCell()



@end


@implementation ZHNunlimitedCell

- (void)layoutSubviews{
    
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * backImageView = [[UIImageView alloc]init];
        [self addSubview:backImageView];
        self.backImageView = backImageView;
        self.backImageView.frame = self.bounds;
        backImageView.userInteractionEnabled = YES;
    }
    return self;
}

@end
