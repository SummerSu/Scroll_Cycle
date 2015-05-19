//
//  CHRollView.m
//  Demo_ScrollView_Cycle
//
//  Created by 扶不起的阿斗 on 15/5/15.
//  Copyright (c) 2015年 扶不起的阿斗. All rights reserved.
//

#import "CHRollView.h"

/** 参数设置区域 */
// 页标指示器的纵向位置 //
#define PAGE_Y 20
// 自动滚动时间 //
#define AUTO_SCROLL_TIME 3

// 宏定值
#define ITEM_WIDTH self.scrollView.frame.size.width

@interface CHRollView()<UIScrollViewDelegate>

/** 数据源 */
@property(nonatomic, strong)NSMutableArray * items;
/** 是否自动滚动 */
@property(nonatomic, getter = isAutoRoll)BOOL autoRoll;
/** 滚动视图 */
@property(nonatomic, strong)UIScrollView * scrollView;
/** 页面指示器 */
@property(nonatomic, strong)UIPageControl * pageControl;

@end

@implementation CHRollView

/**
 *  初始化调用
 *
 *  @param frame    在父视图中的Frame
 *  @param items    要展示的内容
 *  @param autoRoll 自动滚动
 *
 *  @return CHRollView
 */
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items andAutoRoll:(BOOL)autoRoll{
    
    if (self = [super initWithFrame:frame]) {
        
        // 处理items
        [self handleItems:items];
        
        // 初始化控件
        [self initControl];
        
        // 设置自动滚动
        self.autoRoll = autoRoll;
        
    }
    return self;
}


/**
 *  处理items
 */
- (void)handleItems:(NSArray *)items{
    
    NSMutableArray * tempItem = [items mutableCopy];
    
    self.items = tempItem;
    
    id fristItem = [items firstObject];
    id lastItem  = [items lastObject];
    
    [tempItem addObject:fristItem];
    [tempItem insertObject:lastItem atIndex:0];
    

}


/**
 *  初始化控件
 */
- (void)initControl{
    
    // 滚动视图 && 页面指示
    self.scrollView = [[UIScrollView alloc]init];
    self.pageControl = [[UIPageControl alloc]init];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor yellowColor];
    
    self.pageControl.numberOfPages = self.items.count - 2;
    self.pageControl.enabled = YES;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    
    
}


/**
 *  布局子控件
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
//    CGFloat pageW = self.frame.size.width;
//    CGFloat pageX = self.frame.size.width * 0.5 - pageW * 0.5;
 
    CGFloat pageW = 100;
    CGFloat pageX = self.frame.size.width-100;
    
    CGFloat pageH = 20;
    CGFloat pageY = self.frame.size.height - PAGE_Y;
    
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    self.scrollView.frame = self.bounds;
    
    // 添加展示Items
    [self addItems];
}


/**
 *  添加展示Items
 */
- (void)addItems{
    
//    for (UIColor * color in self.items) {
//        UIView * showView = [[UIView alloc]init];
//        showView.backgroundColor = color;
//        showView.frame = CGRectMake(self.scrollView.contentSize.width,
//                                    self.scrollView.bounds.origin.y,
//                                    self.scrollView.frame.size.width,
//                                    self.scrollView.frame.size.height);
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + self.scrollView.frame.size.width,self.scrollView.frame.size.height);
//        
//        [self.scrollView addSubview:showView];
//    }

    //Modify by Sylvia(Sylvia is me)
    
    for (NSString * imageName in self.items) {
        
        UIImageView * showView = [[UIImageView alloc]init];
        showView.image = [UIImage imageNamed:imageName];

        showView.frame = CGRectMake(
                                    self.scrollView.contentSize.width,
                                    self.scrollView.bounds.origin.y,
                                    self.scrollView.frame.size.width,
                                    self.scrollView.frame.size.height);
        
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        [self.scrollView addSubview:showView];
    }
    

    
    // 移动到起始位置
    [self.scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO];

    // 添加点击手势
    [self addTapGestureRecognizer];
    
    // 判断是否是自动模式
    if (self.isAutoRoll) {
        [self performSelector:@selector(autoRoll) withObject:nil afterDelay:AUTO_SCROLL_TIME];
    }
    
}

/**
 *  添加手势
 */
- (void)addTapGestureRecognizer{
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCilckAD:)];
    
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  手势响应方法
 */
- (void)tapCilckAD:(UITapGestureRecognizer *)tapGR{
    
    if (self.clickItem) {
        
        NSNumber * index = [[NSNumber alloc]initWithInteger:self.pageControl.currentPage];
        self.clickItem(index);
    }
}


/**
 *  自动滚动方法
 */

- (void)autoRoll{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoRoll) object:nil];
    
    CGFloat moveItemX = self.scrollView.contentOffset.x + ITEM_WIDTH;
    
    moveItemX = (moveItemX / ITEM_WIDTH) * ITEM_WIDTH;
    
    [self moveItem:moveItemX];
    
    if (self.isAutoRoll) {
        
        [self performSelector:@selector(autoRoll) withObject:nil afterDelay:AUTO_SCROLL_TIME];
    }
    
}

/**
 *  移动条目
 */
- (void)moveItem:(CGFloat)itemX{
    
    [self.scrollView setContentOffset:CGPointMake(itemX, 0) animated:YES];
}


#pragma mark - ScrollView 代理

/**
 *  滚动调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /**
     *  循环展示
     */
    
    // 偏移量
    CGFloat targetX = scrollView.contentOffset.x;
    
    // 如果偏移量 大于 倒数第二页
    if (targetX >= ITEM_WIDTH * ([self.items count] - 1)) {
        
        // 偏移量设置成第二页
        targetX = ITEM_WIDTH;
        
        // 设置偏移量
        [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    }
    // 如果小于第一页
    else if(targetX <= 0)
    {
        // 调整到第四页
        targetX = ITEM_WIDTH *([self.items count]-2);

        // 设置偏移量
        [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    }

    
    /**
     *  计算页标
     */
    
    // 偏移量 + item的一半 / item宽
    NSInteger page = (_scrollView.contentOffset.x + ITEM_WIDTH / 2.0) / ITEM_WIDTH;
    
    // 如果移动到第四页 把页标设置为起始位置页标
    page --;
    
    if (page >= self.pageControl.numberOfPages){
        page = 0;
    }
    // 如果移动到了第一页 页标设置成最大页标
    else if(page < 0){
        page = self.pageControl.numberOfPages -1;
    }

    // 设置当前页标
    _pageControl.currentPage = page;
}

/**
 *  开始拖拽
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoRoll) object:nil];
}

/**
 *  停止拖拽
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self performSelector:@selector(autoRoll) withObject:nil afterDelay:AUTO_SCROLL_TIME];
}


@end
