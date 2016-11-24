//
//  NoticeInfo.h
//  DriftBooks
//
//  Created by ios11 on 16/5/18.
//  Copyright © 2016年 x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfo : NSObject
@property NSInteger ID;
@property NSString* text;
@property NSString* detail;
@property NSString* time;
@property NSString* expiredTime;
@property NSString* action;
-(id)initWithId:(NSInteger)Id text:(NSString *)t detail:(NSString *)d time:(NSString*)ti withExpiredTime:(NSString*)et andAction:(NSString*)a;
@end
