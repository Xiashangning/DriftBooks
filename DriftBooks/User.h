//
//  User.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/9.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface User : NSObject
@property NSString* name;
@property NSString* pass;
@property NSString* addr;
@property NSInteger phone;
@property NSInteger QQ;

-(id)initWithName:(NSString*)n pass:(NSString*)p addr:(NSString*)a phone:(NSInteger)ph QQ:(NSInteger)qq;

@end
