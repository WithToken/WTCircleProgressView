//
//  ViewController.m
//  WJCircleProgressView
//
//  Created by 郭武将 on 2017/7/6.
//  Copyright © 2017年 郭武将. All rights reserved.
//

#import "ViewController.h"
#import "WTCircleProgressView.h"

@interface ViewController () {
    WTCircleProgressView *circleView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
    self.view.backgroundColor = [UIColor blackColor];
    [self addCircle];
}

-(void)addCircle {
    CGFloat margin = 15.0f;
    CGFloat circleWidth = [UIScreen mainScreen].bounds.size.width - 2*margin;
    float lineWidth = 0.1*circleWidth;
    
    circleView = [[WTCircleProgressView alloc]initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth) lineWidth:lineWidth];
    circleView.center = self.view.center;
    circleView.totalTime = 5.0;
    [self.view addSubview:circleView];
    
    [circleView start:^{
        NSLog(@"ff");
    }];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(circleView.frame) + 50, self.view.bounds.size.width - 2*50, 30)];
    [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setMinimumTrackTintColor:[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:0/255.0f alpha:1]];
    [self.view addSubview:slider];
}

-(void)sliderMethod:(UISlider*)slider {
    circleView.progress = slider.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
