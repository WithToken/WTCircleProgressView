//
//  WTCircleProgressView.m
//  WJCircleProgressView
//
//  Created by 郭武将 on 2017/7/6.
//  Copyright © 2017年 郭武将. All rights reserved.
//

#import "WTCircleProgressView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = 1.0f;

@interface WTCircleProgressView ()
{
    CAShapeLayer *_progressLayer;
    UIImageView *_endPoint;
}

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation WTCircleProgressView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = lineWidth;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    float centerX = self.bounds.size.width / 2.0;
    float centerY = self.bounds.size.height / 2.0;
    float radius = (self.bounds.size.width - _width) / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:1.5f*M_PI clockwise:YES];
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1].CGColor;
    backLayer.lineWidth = _width;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _width;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(255, 151, 0) CGColor],(id)[RGB(255, 203, 0) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer];
    [self.layer addSublayer:gradientLayer];
    
    _endPoint = [[UIImageView alloc] init];
    _endPoint.frame = CGRectMake(0, 0, _width - endPointMargin * 2,_width - endPointMargin * 2);
    _endPoint.hidden = NO;
    _endPoint.backgroundColor = [UIColor redColor];//暂时隐藏圆点 （与进度脱节）
    _endPoint.layer.masksToBounds = YES;
    _endPoint.layer.cornerRadius = _endPoint.bounds.size.width/2;
    [self addSubview:_endPoint];
}

-(void)setProgress:(float)progress {
    if (_isCountTime) {
        return;
    }
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [self updateCircle];
    [_progressLayer removeAllAnimations];
}

-(void)updateCircle {
    CGFloat angle = M_PI * 2 * _progress;
    float radius = (self.bounds.size.width - _width)/2.0;
    int index = (angle) / M_PI_2;
    float needAngle = angle - index * M_PI_2;
    float x = 0 ,y = 0;
    switch (index) {
        case 0:
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
        default:
            break;
    }
    
    CGRect rect = _endPoint.frame;
    rect.origin.x = x + endPointMargin;
    rect.origin.y = y + endPointMargin;
    _endPoint.frame = rect;
    [self bringSubviewToFront:_endPoint];
    _endPoint.hidden = NO;
    if (_progress == 0 || _progress == 1) {
        _endPoint.hidden = YES;
    }
}

- (void)start:(completeBlock)completeBlock {
    _isCountTime = YES;
    _completeBlock = [completeBlock copy];
    _timer = [NSTimer timerWithTimeInterval:0.01 target:self
                                       selector:@selector(updata) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode: NSRunLoopCommonModes];
}

- (void)start {
    _isCountTime = YES;
    _timer = [NSTimer timerWithTimeInterval:0.01 target:self
                                       selector:@selector(updata) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode: NSRunLoopCommonModes];
}

- (void)updata {
    // 时间计算有问题。
    _count ++;
    [self updataProgress:1.0 / (_totalTime * 100) + _progress];
    if (_count >= _totalTime * 100) {
        _isCountTime = NO;
        _count = 0;
        [_timer invalidate];
        _timer = nil;
        if (_completeBlock) _completeBlock();
    }
}

- (void)updataProgress:(CGFloat)progress {
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [self updateCircle];
    [_progressLayer removeAllAnimations];
}

- (void)stop {
    _count = 0;
    _totalTime = 0;
    self.progress = 0;
    [_timer invalidate];
    _timer = nil;
}
@end
