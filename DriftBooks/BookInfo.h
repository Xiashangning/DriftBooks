//
//  BookInfo.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "User.h"
typedef void (^callBackBlock)(id desc);

#define BASE_URL [NSURL URLWithString:@"http://115.159.194.205:8080/DriftBooksServer/IOS/"]

@interface BookInfo : NSObject
{
    NSMutableArray* comments;
    NSUInteger realCount;
}
@property int bookId;
@property NSString* name;
@property User* from;
@property NSString* content;
@property User* hold;
@property int wanting;

-(id)initWithId:(int)bId name:(NSString*)bname from:(User*)bfrom content:(NSString*)con hold:(User*)bhold wanting:(int)wantNum;
-(void)loadCommentsWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
-(NSMutableArray*)getCommentAt:(NSInteger)row withFailure:(callBackBlock)failure;
-(NSInteger)getCommentCount;
-(void)addComment:(NSString*)comment below:(int)comId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
@end