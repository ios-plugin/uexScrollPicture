//
//  EUExScrollPicture.m
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExScrollPicture.h"
#import "EUExScrollPicture+JsonIO.h"
#import "EBrowserView.h"
#import "EUtility.h"
#import "uexScrollPictureModel.h"
@interface EUExScrollPicture()<uexScrollPictureModelDelegate>

@property (nonatomic,strong) NSMutableArray<uexScrollPictureModel *> *scrollPictures;
@end


@implementation EUExScrollPicture

-(id)initWithBrwView:(EBrowserView *) eInBrwView{
    if (self = [super initWithBrwView:eInBrwView]) {

        self.scrollPictures =[NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [self clean];
}

-(void)clean{
    for (uexScrollPictureModel *model in self.scrollPictures) {
        [model.view removeFromSuperview];
    }
    [self.scrollPictures removeAllObjects];
}

/*
createNewScrollPicture(param)
var param={
    interval;//自动滚动的间隔时间，单位为毫秒，默认3000
    anchor;//float数对[X,Y] 轮播图的左上角锚点的坐标
    pageControlOffset;//float数对[X,Y] 轮播图pageControl偏移 可选参数
    height;//轮播图高度
    width;//轮播图宽度
    urls;//List<String> 的json字符串
    viewId;//轮播图id
};
*/

-(void)createNewScrollPicture:(NSMutableArray *)array{
    id info = [self getDataFromJSON:array[0]];
    CGFloat switchInterval,anchorX,anchorY,height,width;
    NSString *viewId = [info objectForKey:@"viewId"];
    if([info objectForKey:@"interval"]){
        switchInterval =[[info objectForKey:@"interval"] floatValue]/1000;
    }else{
        switchInterval =3;
    }
    NSArray *anchor = [info objectForKey:@"anchor"];
    anchorX =[anchor[0] floatValue];
    anchorY =[anchor[1] floatValue];
    height = [[info objectForKey:@"height"] floatValue];
    width = [[info objectForKey:@"width"] floatValue];
    NSArray *urls=[info objectForKey:@"urls"];
    NSMutableArray *imgurls=[NSMutableArray array];
    for(NSString *url in urls){
    NSString *imgurl=[self absPath:url];
        [imgurls addObject:imgurl];
    }
    
    CGFloat PCOffsetX=0;
    CGFloat PCOffsetY=0;
    if([info objectForKey:@"pageControlOffset"]){
        NSArray *offset = [info objectForKey:@"pageControlOffset"];
        PCOffsetX =[offset[0] floatValue];
        PCOffsetY =[offset[1] floatValue];
    }
    
    uexScrollPictureModel *model =[[uexScrollPictureModel alloc] initScrollPictureWithName:viewId
                                                                            switchInterval:switchInterval
                                                                                   anchorX:anchorX
                                                                                   anchorY:anchorY
                                                                        pageControlOffsetX:PCOffsetX
                                                                        pageControlOffsetY:PCOffsetY
                                                                                    height:height
                                                                                     width:width
                                                                                   imgUrls:imgurls
                                                                                  delegate:self];
    
    
   [EUtility brwView:self.meBrwView addSubviewToScrollView:model.view];
    //[EUtility brwView:meBrwView addSubview:model.view];
    [self.scrollPictures addObject:model];
}
/*
startAutoScroll(param);
var param={
    viewId;//轮播图id
};


 stopAutoScroll(param);
 var param={
	viewId;//轮播图id
 };
*/
-(NSInteger)searchModelById:(NSMutableArray *)array{
    id info = [self getDataFromJSON:array[0]];
    NSString *viewId =[info objectForKey:@"viewId"];
    for(int i=0;i<[self.scrollPictures count];i++){
        uexScrollPictureModel *model = self.scrollPictures[i];
        if([model.modelName isEqual:viewId]) return i;
    }

    return -1;
}
            
            

-(void) startAutoScroll:(NSMutableArray *)array{
    NSInteger position = [self searchModelById:array];
    if(position == -1) return;
    uexScrollPictureModel *model =self.scrollPictures[position];
    model.isPaused =NO;
}
-(void) stopAutoScroll:(NSMutableArray *)array{
    NSInteger position = [self searchModelById:array];
    if(position == -1) return;
    uexScrollPictureModel *model =self.scrollPictures[position];
    model.isPaused =YES;
}
/*
 removeView(param)
 var param={
	viewId://轮播图id
 }
 */
-(void) removeView:(NSMutableArray *)array{
    NSInteger position = [self searchModelById:array];
    if(position == -1) return;
    uexScrollPictureModel *model =self.scrollPictures[position];
    [model.view removeFromSuperview];
    model = nil;
    [self.scrollPictures removeObjectAtIndex:position];
}
-(void)scrollPictureModelDidClickWithInfo:(NSDictionary *)info{
    [self returnJSONWithName:@"onPicItemClick" object:info];
    
}

@end
