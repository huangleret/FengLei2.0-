//
//  LaunchViewController.m
//  BiTuBi
//
//  Created by 必图必 on 15/11/13.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "LaunchViewController.h"

#import "AppDelegate.h"

#define BTBWidth [UIScreen mainScreen].bounds.size.width

#define BTBHeight [UIScreen mainScreen].bounds.size.height

@interface LaunchViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;//全局分页视图
    
    NSInteger IndexPage;//当前页面
    
    NSTimer *timer;//计时器

}
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置默认背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建滑动视图
    [self loadScrollView];
    
    //存入一个参数 用于判断用户是否第一次进入程序
    [self scrollViewDidScroll:_myScrollView];
}

-(void)loadScrollView{
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    
    NSArray *ImageArr = @[@"pic1.jpg",@"pic2.jpg",@"pic3.jpg"];
    
    for (int i = 0; i <ImageArr.count; i++) {
        
        UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(i * BTBWidth, 0, BTBWidth, BTBHeight)];
        
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:imgView.bounds];
        
        imgv.image = [UIImage imageNamed:ImageArr[i]];
        
        if (i == ImageArr.count - 1) {
            
            UIButton *button = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:button];
        }
        
        [imgView addSubview:imgv];
        
        [self.myScrollView addSubview:imgView];
    }
    
    self.myScrollView.contentSize = CGSizeMake(BTBWidth * ImageArr.count, BTBHeight);
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.showsVerticalScrollIndicator = NO;
    
    _myScrollView.bounces = YES;
    
    _myScrollView.pagingEnabled = YES;
    
    _myScrollView.delegate = self;
    
    [self.view addSubview:_myScrollView];
    
    //创建分页控制
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, BTBHeight - 60, BTBWidth , 60)];
    
    _pageControl.numberOfPages = 3;
    
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_pageControl];
    
    //计时器方法
    IndexPage = 0;
//    timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    
}

#pragma mark - 代理方法
- (void)pageAction:(UIPageControl *)pageControl {
    
    NSInteger page = pageControl.currentPage;
    
    //计算偏移量
    CGFloat offSet = page * BTBWidth;
    
    [_myScrollView setContentOffset:CGPointMake(offSet, 0) animated:YES];
    
}

#pragma mark - 私有方法
//减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //计算页数
    NSInteger pages = scrollView.contentOffset.x / BTBWidth;
    _pageControl.currentPage = pages;
    IndexPage = pages;
    
}

//点击跳转
-(void)buttonAction:(UIButton *)btn{
    [AppDelegate tiaozhuan];
    [self.view removeFromSuperview];
}

#pragma mark - override Method
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ScrollView Delegate
//设置存入是否第一次登陆
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        
    // 存入数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@YES forKey:@"Guide"];
        
//    NSLog(@"执行了");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
