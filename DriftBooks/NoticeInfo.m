//
//  NoticeInfo.m
//  DriftBooks
//
//  Created by ios11 on 16/5/18.
//  Copyright © 2016年 x. All rights reserved.
//

#import "NoticeInfo.h"

@implementation NoticeInfo
@synthesize ID;
@synthesize text;
@synthesize detail;
@synthesize time;
@synthesize expiredTime;
@synthesize action;
-(id)initWithId:(NSInteger)Id text:(NSString *)t detail:(NSString *)d time:(NSString*)ti withExpiredTime:(NSString *)et andAction:(NSString *)a{
    self = [super init];
    if(self){
        self.ID = Id;
        self.text = t;
        self.detail = d;
        self.time = ti;
        self.expiredTime = et;
        self.action = a;
    }
    return self;
}
@end
