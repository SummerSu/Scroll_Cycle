//
//  ViewController.m
//  Demo_ScrollView_Cycle
//
//  Created by 扶不起的阿斗 on 15/5/14.
//  Copyright (c) 2015年 扶不起的阿斗. All rights reserved.
//

#import "ViewController.h"
#import "CHRollView.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 安装广告
    [self steupAD];
}

/**
 *  安装广告
 */
- (void)steupAD{

    // 数据源

    NSArray * items = @[@"151.jpg",@"152.jpeg",@"153.jpg",@"154.jpg",@"155.jpg"];
    
    // 摆放的位置
    CGRect rollFrame = CGRectMake(0, 20, self.view.bounds.size.width, 320);
    
    // 创建对象
    CHRollView * rollView = [[CHRollView alloc]initWithFrame:rollFrame andItems:items andAutoRoll:YES];
    
    // 点击广告回调方法
    rollView.clickItem = ^(id obj){
        
        NSLog(@"%@",obj);
    };
    
    // 加入父视图
    [self.view addSubview:rollView];
}


@end
