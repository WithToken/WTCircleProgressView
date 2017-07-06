//
//  WTCircleProgressView.h
//  WJCircleProgressView
//
//  Created by 郭武将 on 2017/7/6.
//  Copyright © 2017年 郭武将. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)();

@interface WTCircleProgressView : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)width;

@property (assign ,nonatomic) float progress;

@property (assign ,nonatomic) CGFloat width;

@property (assign ,nonatomic) CGFloat totalTime;

@property (assign ,nonatomic) BOOL isCountTime; // 自动倒计时时 禁止手动设置进度

@property (nonatomic, copy) completeBlock completeBlock;

- (void)start:(completeBlock)completeBlock;
- (void)start;
- (void)stop;
@end
