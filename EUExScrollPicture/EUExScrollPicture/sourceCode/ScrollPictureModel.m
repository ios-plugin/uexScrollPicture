
//
//  ScrollPictureModel.m
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "ScrollPictureModel.h"
#import "UIButton+WebCache.h"
@implementation ScrollPictureModel

-(instancetype)initScrollPictureWithName:(NSString *)name
                          switchInterval:(CGFloat)switchInterval
                                 anchorX:(CGFloat)anchorX
                                 anchorY:(CGFloat)anchorY
                      pageControlOffsetX:(CGFloat)PCOffsetX
                      pageControlOffsetY:(CGFloat)PCOffsetY
                                  height:(CGFloat)height
                                   width:(CGFloat)width
                                 imgUrls:(NSArray *)urls{
    self=[super init];
    if(self){
        self.isPaused = NO;
        self.modelName = name;
        self.anchorX = anchorX;
        self.anchorY = anchorY;
        self.PCOffsetX=PCOffsetX;
        self.PCOffsetY=PCOffsetY;
        self.width=width;
        self.height =height;
        self.switchInterval =switchInterval;
        self.imageCount=0;
        self.imgUrls=urls;
        [self checkImages:self.imgUrls];
        if(self.imageCount == 0){
            return nil;
        }
        [self createScrollPicture];
        
        
        
        
        
        
        return self;
    }
    
    
    
    return nil;
}



-(void)checkImages:(NSArray *)urls{
    for(NSString *imgUrl in urls){
        if([[[imgUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString] hasPrefix:@"http"]){
            self.imageCount++;

        }else{
            NSData *imageData = [NSData dataWithContentsOfFile:imgUrl];
            UIImage *img=[UIImage imageWithData:imageData];
            if(img){
                self.imageCount ++;
            }
        }
    }
}

-(void)setImageForButton:(UIButton*)button byIndex:(NSInteger)index{
    if((self.imgUrls.count-1)<index){
        return;
    }
    NSString *urlString=self.imgUrls[index];
    if([[[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString] hasPrefix:@"http"]){
        [button sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal];
        
    }else{
        NSData *imageData = [NSData dataWithContentsOfFile:urlString];
        UIImage *img=[UIImage imageWithData:imageData];
        if(img){
            [button setBackgroundImage:img forState:UIControlStateNormal];
        }
    }

}

-(void)createScrollPicture{
    [NSTimer scheduledTimerWithTimeInterval:self.switchInterval target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.width,self.height)];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    

    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.PCOffsetX+self.width*0.5,self.PCOffsetY+ self.height-20,self.imageCount*10,10)]; // 初始化mypagecontrol
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    self.pageControl.numberOfPages = self.imageCount;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:self.pageControl];
    
    for (int i = 0;i<self.imageCount;i++)
    {
        UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageButton setFrame:CGRectMake(self.width * (i+1) ,0, self.width, self.height)];

        [self setImageForButton:imageButton byIndex:i];
        imageButton.tag = i;
        //添加点击事件
        [imageButton addTarget:self action:@selector(clickPageImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:imageButton];
    }

    // 取数组最后一张图片 放在第0页
    UIButton * lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setImageForButton:lastButton byIndex:self.imageCount-1];

    [lastButton setFrame:CGRectMake(0,0,self.width,self.height)];
    lastButton.tag = self.imageCount-1;// 添加最后1页在首页 循环
    [lastButton addTarget:self action:@selector(clickPageImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:lastButton];
    
    // 取数组第一张图片 放在最后一页
    UIButton * firstButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [self setImageForButton:firstButton byIndex:0];
    [firstButton setFrame:CGRectMake((self.width * (self.imageCount + 1)),0, self.width,self.height)]; // 添加第1页在最后 循环
    [firstButton addTarget:self action:@selector(clickPageImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:firstButton];
    
    [self.scrollView setContentSize:CGSizeMake(self.width * (self.imageCount + 2), self.height)]; //  +上第1页和最后一页
    //[self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(self.width,0,self.width,self.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第最后一页
    [self.view setFrame:CGRectMake(self.anchorX,self.anchorY,self.width,self.height)];
}




//点击回调
-(void)clickPageImage:(UIButton *)sender{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[NSString stringWithFormat:@"%ld",(long)sender.tag] forKey:@"index"];
    [result setValue:self.modelName forKey:@"viewId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPicItemClick" object:nil userInfo:result];
   // NSLog(@"click button tag is %d",sender.tag);
   
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ (self.imageCount+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.width * self.imageCount,0,self.width,self.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==(self.imageCount+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.width,0,self.width,self.height) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    
        NSInteger page = self.pageControl.currentPage; // 获取当前的page
        [self.scrollView scrollRectToVisible:CGRectMake(self.width*(page+1),0,self.width,self.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    
  
}
// 定时器 绑定的方法
- (void)runTimePage
{
    if(!self.isPaused){
        NSInteger page = self.pageControl.currentPage; // 获取当前的page
        page++;
        page = page > (self.imageCount-1) ? 0 : page ;
        self.pageControl.currentPage = page;
        [self turnPage];
    }
}

@end
