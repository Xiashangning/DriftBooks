//
//  User.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/9.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//
#import "User.h"

@implementation User
@synthesize name;
@synthesize pass;
@synthesize addr;
@synthesize phone;
@synthesize QQ;

-(id)initWithName:(NSString *)n pass:(NSString *)p addr:(NSString *)a phone:(NSInteger)ph QQ:(NSInteger)qq{
    self = [super init];
    if(self)
    {
        self.name = n;
        self.pass = p;
        self.addr = a;
        self.phone = ph;
        self.QQ = qq;
    }
    return self;
}

@end
