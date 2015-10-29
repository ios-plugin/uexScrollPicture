//
//  ScrollPictureModel.h
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExScrollPicture.h"
@interface ScrollPictureModel :UIViewController<UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat switchInterval;
@property (nonatomic,assign) CGFloat anchorX;
@property (nonatomic,assign) CGFloat anchorY;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat PCOffsetX;
@property (nonatomic,assign) CGFloat PCOffsetY;
@property (nonatomic,copy) NSString *modelName;
@property (nonatomic,strong)NSArray *imgUrls;
@property (nonatomic,assign)NSInteger imageCount;
@property (nonatomic,assign)BOOL isPaused;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (strong,nonatomic)UIScrollView *scrollView;

-(instancetype)initScrollPictureWithName:(NSString *)name
                          switchInterval:(CGFloat)switchInterval
                                 anchorX:(CGFloat)anchorX
                                 anchorY:(CGFloat)anchorY
                      pageControlOffsetX:(CGFloat)PCOffsetX
                      pageControlOffsetY:(CGFloat)PCOffsetY
                                  height:(CGFloat)height
                                   width:(CGFloat)width
                                 imgUrls:(NSArray*)urls;



-(void)loadImages:(NSArray *)urls;


@end
