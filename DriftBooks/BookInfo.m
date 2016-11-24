//
//  BookInfo.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "BookInfo.h"
#import "CommentModel.h"
#import "ASIHTTPRequest.h"
@implementation BookInfo

@synthesize name;
@synthesize from;
@synthesize content;
@synthesize hold;
@synthesize wanting;
#define addCom(comment,c,i) [comment addObject:[[CommentModel alloc]initWithId:[c[@"id"]intValue] from:c[@"fromUser"][@"name"] addr:c[@"fromUser"][@"addr"] comment:c[@"comment"] time:c[@"time"] floor:i+1]];
//#define initCom(com,f) [[CommentModel alloc]initWithId:4 from:@"管理员" addr:@"南外" comment:com time:@"2016 05 16" floor:f]
-(id)initWithId:(int)bId name:(NSString *)bname from:(User *)bfrom content:(NSString *)con hold:(User *)bhold wanting:(int)wantNum{
    self = [super init];
    if(self)
    {
        self.bookId = bId;
        self.name = bname;
        self.from = bfrom;
        self.content = con;
        self.hold = bhold;
        self.wanting = wantNum;
        self->comments = [NSMutableArray array];
        self->realCount = 0;
        [self loadCommentsWithSuccess:^(id desc) {
        } andFailure:^(id desc) {
        }];
    }
    return self;
}
-(BOOL)isEqual:(id)object{
    BookInfo *info = object;
    if(info.bookId == self.bookId){
        return YES;
    }
    return NO;
}
-(void)loadCommentsWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* clearUrl = [NSURL URLWithString:[NSString stringWithFormat:@"comment.jsp?mode=reset&bookId=%d",self.bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* clearRequest = [[ASIHTTPRequest alloc]initWithURL:clearUrl];
    [clearRequest startSynchronous];
    if(!clearRequest.error){
        self->comments = [NSMutableArray arrayWithCapacity:5];
        self->realCount = 0;
        [self getCommentAt:4 withFailure:^(id desc) {//加载第一组
            failure(desc);
        }];
    }else{
        failure(@"无法连接至服务器，请重试");
    }
//    NSDictionary* params = @{@"mode":@"get",@"bookId":[NSString stringWithFormat:@"%d",self.bookId]};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    [m GET:@"comment.jsp" parameters:@{@"mode":@"reset",@"bookId":[NSString stringWithFormat:@"%d",self.bookId]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [m GET:@"comment.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary* dict = responseObject;
//            if([dict[@"res"] isEqualToString:@"1"]){
//                NSArray* coms = dict[@"content"][@"comments"];
//                self->realCount = [dict[@"content"][@"totalCount"] intValue];
//                self->comments = [NSMutableArray arrayWithCapacity:4];
//                for(NSArray* com in coms){
//                    NSMutableArray* comment = [NSMutableArray arrayWithCapacity:5];
//                    for(int i = 0;i<com.count;i++){
//                        NSDictionary* c = com[i];
//                        addCom(comment, c, i);
//                    }
//                    [self->comments addObject:comment];
//                }
//                success(nil);
//            }else{
//                failure(@"服务器出错,请重试");
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            failure(@"无法连接到服务器，请重试");
//        }];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接到服务器，请重试");
//    }];
}
-(NSMutableArray*)getCommentAt:(NSInteger)row withFailure:(callBackBlock)failure{
    NSInteger size;
    NSInteger addCnt = 5;
    for(size = [self->comments count]-1;size < row;size += addCnt){
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"comment.jsp?mode=get&bookId=%d",self.bookId] relativeToURL:BASE_URL];
        ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
        [request startSynchronous];
        if(![request error]){
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
            if([dict[@"res"] isEqualToString:@"1"]){
                NSArray* coms = dict[@"content"][@"comments"];
                for(NSArray* com in coms){
                    NSMutableArray* comment = [NSMutableArray arrayWithCapacity:5];
                    for(int i = 0;i<com.count;i++){
                        NSDictionary* c = com[i];
                        addCom(comment, c, i);
                    }
                    [self->comments addObject:comment];
                    self->realCount = [dict[@"content"][@"totalCount"] intValue];
                }
            }else{
                self->realCount = self->comments.count;
                failure(@"服务器出错，请重试");
            }
        }else{
            self->realCount = self->comments.count;
            failure(@"无法连接至服务器，请重试");
        }
    }
    if(row<self->comments.count){
        return [self->comments objectAtIndex:row];
    }else{
        return nil;
    }
//        NSDictionary* params = @{@"mode":@"get",@"bookId":[NSString stringWithFormat:@"%d",self.bookId]};
//        AFHTTPSessionManager* m = GETMANAGER;
//        m.requestSerializer = [AFJSONRequestSerializer serializer];
//        [m GET:@"comment.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary* dict = responseObject;
//            if([dict[@"res"] isEqualToString:@"1"]){
//               NSArray* coms = dict[@"content"][@"comments"];
//                for(NSArray* com in coms){
//                    NSMutableArray* comment = [NSMutableArray arrayWithCapacity:5];
//                    for(int i = 0;i<com.count;i++){
//                        NSDictionary* c = com[i];
//                        addCom(comment, c, i);
//                    }
//                    [self->comments addObject:comment];
//                }
//                shouldFinish = YES;
//            }else{
//                self->realCount = self->comments.count;
//                hasFailed = YES;
//                failure(@"服务器出错，请重试");
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            self->realCount = self->comments.count;
//            hasFailed = YES;
//            failure(@"无法连接至服务器，请重试");
//        }];
}
-(NSInteger)getCommentCount{
    return self->realCount;
}
-(void)addComment:(NSString *)comment below:(int)comId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"comment.jsp?mode=add&bookId=%d&comment=%@&belowId=%d",self.bookId,comment,comId]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* info = dict[@"content"];
            if(comId!=-1){
                for(NSMutableArray* com in self->comments){
                    if(((CommentModel*)com[0]).comId == comId){
                        [com addObject:[[CommentModel alloc]initWithId:[info[@"id"]intValue] from:info[@"user"] addr:info[@"addr"] comment:comment time:info[@"time"] floor:(int)com.count+1]];
                    }
                }
            }else{
                [self->comments insertObject:[NSMutableArray arrayWithObject:[[CommentModel alloc]initWithId:[info[@"id"]intValue] from:info[@"user"] addr:info[@"addr"] comment:comment time:info[@"time"] floor:1]] atIndex:0];
                self->realCount++;
            }
            success(@"添加成功");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    NSDictionary* params = @{@"mode":@"add",@"bookId":[NSString stringWithFormat:@"%d",self.bookId],@"comment":comment,@"belowId":[NSString stringWithFormat:@"%d",comId]};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    [m GET:@"comment.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* info = dict[@"content"];
//            if(comId!=-1){
//                for(NSMutableArray* com in self->comments){
//                    if(((CommentModel*)com[0]).comId == comId){
//                        [com addObject:[[CommentModel alloc]initWithId:[info[@"id"]intValue] from:info[@"user"] addr:info[@"addr"] comment:comment time:info[@"time"] floor:(int)com.count+1]];
//                    }
//                }
//            }else{
//                [self->comments insertObject:[[CommentModel alloc]initWithId:[info[@"id"]intValue] from:info[@"user"] addr:info[@"addr"] comment:comment time:info[@"time"] floor:1] atIndex:0];
//            }
//            success(@"添加成功");
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接到服务器，请重试");
//    }];
}
@end