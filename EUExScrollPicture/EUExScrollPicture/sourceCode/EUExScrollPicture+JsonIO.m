//
//  EUExScrollPicture+JsonIO.m
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExScrollPicture+JsonIO.h"


@implementation EUExScrollPicture (JsonIO)


//从json字符串中获取数据
- (id)getDataFromJson:(NSString *)jsonData{
    NSError *error = nil;
    
    
    
    NSData *jsonData2= [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData2
                     
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
-(void) returnJSonWithName:(NSString *)name object:(id)dict{
    /*
     
     
     
     if([NSJSONSerialization isValidJSONObject:dict]){
     NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
     options:NSJSONWritingPrettyPrinted
     error:&error
     ];
     
     NSString *result = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
     */
    NSString *result=[dict JSONFragment];
    NSString *jsSuccessStr = [NSString stringWithFormat:@"if(uexScrollPicture.%@ != null){uexScrollPicture.%@('%@');}",name,name,result];
    
    [self performSelectorOnMainThread:@selector(callBack:) withObject:jsSuccessStr waitUntilDone:YES];
    
}
-(void)callBack:(NSString *)str{
    [self performSelector:@selector(delayedCallBack:) withObject:str afterDelay:0.01];
    //[meBrwView stringByEvaluatingJavaScriptFromString:str];
}

-(void)delayedCallBack:(NSString *)str{
    [meBrwView stringByEvaluatingJavaScriptFromString:str];

}





@end


