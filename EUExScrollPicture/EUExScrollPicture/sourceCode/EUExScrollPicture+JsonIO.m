//
//  EUExScrollPicture+JsonIO.m
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExScrollPicture+JsonIO.h"
#import "EUtility.h"

@implementation EUExScrollPicture (JsonIO)


//从json字符串中获取数据
- (id)getDataFromJSON:(NSString *)jsonString{
    NSError *error = nil;
    NSData *jsonData= [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        
        return jsonObject;
    }else{
        // 解析錯誤
        return nil;
    }
    
}

/*
 回调方法name(data)
 
 */
-(void) returnJSONWithName:(NSString *)name object:(id)dict{
    NSString *result=[dict JSONFragment];
    NSString *jsSuccessStr = [NSString stringWithFormat:@"if(uexScrollPicture.%@ != null){uexScrollPicture.%@('%@');}",name,name,result];
    [EUtility brwView:self.meBrwView evaluateScript:jsSuccessStr];
}






@end


