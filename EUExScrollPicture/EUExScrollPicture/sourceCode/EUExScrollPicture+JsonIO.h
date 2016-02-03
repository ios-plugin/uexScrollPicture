//
//  EUExScrollPicture+JsonIO.h
//  AppCanPlugin
//
//  Created by AppCan on 15/4/28.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExScrollPicture.h"
#import "JSON.h"

@interface EUExScrollPicture (JsonIO)
-(void) returnJSONWithName:(NSString *)name object:(id)dict;
- (id)  getDataFromJSON:(NSString *)jsonString;
@end



