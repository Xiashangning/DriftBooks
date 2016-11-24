//
//  DriftBooks.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "DriftBooks.h"
#import "BookInfo.h"
#import "User.h"
#import "CommentModel.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NoticeInfo.h"

static DriftBooks* book;
static NSString* base_q = @"";
static NSString* kind_str = @"";
#define addBook(arr,b)  [arr addObject:[[BookInfo alloc]initWithId:[b[@"id"]intValue] name:b[@"name"] from:[[User alloc]initWithName:b[@"fromName"] pass:nil addr:nil phone:0 QQ:0] content:b[@"content"] hold:[[User alloc]initWithName:b[@"holdUser"][@"name"] pass:nil addr:b[@"holdUser"][@"addr"] phone:[b[@"holdUser"][@"phone"]integerValue] QQ:[b[@"holdName"][@"QQ"]integerValue]] wanting:[b[@"waiting"]intValue]]];
@implementation DriftBooks

//#define initBook(bn,un1,un2) [[BookInfo alloc]initWithId:3 name:bn from:initUser(un1,@"地球") content:@"一些内容:fgfsdgajgkneg格式的奋不顾身的爱venf无服务分  为丰vsdavjkhsdvahfn丰富而无法发的发布人 部分代码 我告诉你大概  爱手工零食代购 发的是国内十多个吧水电费缩放呃我分世纪东方部分被吧 方式等方面不多麻烦你吧安保法第三部分安抚不少地方的说法呢稍等给你多少分给你答lalalalal啦啦啦啦啦啦啦哈哈哈哈哈哈哈哈哈哈哈娃娃哇哇哇哇哇哇哇哇哇哇哇哇 复 方法第三方士大夫告诉对方公司的风格的个工时费大概的双方各发给讽德诵功核桃仁和认同感电话地方规划法规和德国大使馆热个是梵蒂冈热给人打工富可舒服 访问分 卡发放和我 超级长的那种" hold:initUser(un2,@"Mars") wanting:3]
#define initUser(un1,a) [[User alloc]initWithName:un1 pass:@"123" addr:a phone:1811446 QQ:1750546]
-(id)init{
    self = [super init];
    if(self){
        self->loc = NJ;
        self->user = nil;
        self->cachedBooks = [NSMutableArray array];
        self->realBookCnt = 0;
    }
    return self;
}
+(void)setVisitMod{
    book->user = [[User alloc]init];
    //目前无操作。。。
}
+(void)sendDeviceToken:(NSData *)deviceToken{
    
}
+(void)connectToWeb:(void (^)())canNotReach{
    if(book==nil){
        book = [[DriftBooks alloc]init];
    }
//    Reachability* re = [Reachability reachabilityWithHostName:<#(NSString *)#>];
//    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if(status == AFNetworkReachabilityStatusNotReachable){
//            canNotReach();
//        }
//    }];
}
+(void)registNewUser:(NSString *)name pass:(NSString *)pass addr:(NSString *)addr phone:(NSString *)phone QQ:(NSString *)qq icon:(NSData *)icon vcode:(NSString *)code withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    if(name==nil||[name isEqualToString:@""]){
        failure(@"用户名不能为空");
        return;
    }else if(pass==nil||[pass isEqualToString:@""]){
        failure(@"密码不能为空");
        return;
    }else if(addr==nil||[addr isEqualToString:@""]){
        failure(@"地址不能为空");
        return;
    }else if (phone==nil||[phone isEqualToString:@""]){
        failure(@"电话不能为空");
        return;
    }else if(qq==nil||[qq isEqualToString:@""]){
        failure(@"QQ不能为空");
        return;
    }else if(code==nil||[code isEqualToString:@""]){
        failure(@"请输入验证码");
        return;
    }
    NSString *nameRegex = @"[[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]][[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5] ]{1,}[[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]]";
    NSPredicate *namePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    NSString *passRegex = @"[0-9a-zA-Z]{6,}";
    NSPredicate *passPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    NSString *phoneRegex = @"(1\\d{10})|(\\d{4}-|\\d{3}-)?(\\d{8}|\\d{7})";
    NSPredicate *phonePred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSString *qqRegex = @"[1-9]\\d{4,}";
    NSPredicate *qqPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    if(![namePred evaluateWithObject: name]){
        failure(@"用户名只能由英文，中文，数字组成且长度大于1,不能以空格结尾");
        return;
    }else if (![passPred evaluateWithObject: pass]){
        failure(@"密码必须大于6个字符且只有数字字母组成");
        return;
    }else if (![phonePred evaluateWithObject:phone]){
        failure(@"电话必须为有效电话号码(目前仅支持手机)");
        return;
    }else if(![qqPred evaluateWithObject:qq]){
        failure(@"qq必须为有效QQ号码");
        return;
    }
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"regist.jsp?user=%@&pass=%@&addr=%@&phone=%@&QQ=%@&code=%@",name,pass,addr,phone,qq,code]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc]initWithURL:url];
    __weak ASIFormDataRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(@"注册成功！");
        }else if([dict[@"res"] isEqualToString:@"-2"]){
            failure(@"验证码错误");
        }else if([dict[@"res"] isEqualToString:@"-3"]){
            failure(@"用户名重复");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setData:icon withFileName:[name stringByAppendingString:@".png"] andContentType:@"image/png" forKey:@"icon"];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    NSDictionary* params = @{@"user":name,@"pass":pass,@"addr":addr,@"phone":phone,@"QQ":qq,@"code":code};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    [m POST: @"regist.jsp" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:icon name:@"icon" fileName:[name stringByAppendingString:@".png"] mimeType:@"image/png"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(@"注册成功！");
//        }else if([dict[@"res"] isEqualToString:@"-2"]){
//            failure(@"验证码错误");
//        }else if([dict[@"res"] isEqualToString:@"-3"]){
//            failure(@"用户名重复");
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)login:(NSString *)name pass:(NSString *)pass withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    if(name==nil||[name isEqualToString:@""]){
        failure(@"用户名不能为空");
        return;
    }else if(pass==nil||[pass isEqualToString:@""]){
        failure(@"密码不能为空");
        return;
    }
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"login.jsp?user=%@&pass=%@",name,pass]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* user = dict[@"content"];
            book->user = [[User alloc]initWithName:name pass:pass addr:user[@"addr"] phone:[user[@"phone"] integerValue] QQ:[user[@"QQ"] integerValue]];
            success(nil);
        }else if([dict[@"res"] isEqualToString:@"-2"]){
            failure(@"用户名或密码出错，请重试");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    [m GET:@"login.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* user = dict[@"content"];
//            book->user = [[User alloc]initWithName:name pass:pass addr:user[@"addr"] phone:[user[@"phone"] integerValue] QQ:[user[@"QQ"] integerValue]];
//            success(nil);
//        }else if([dict[@"res"] isEqualToString:@"-2"]){
//            failure(@"用户名或密码出错，请重试");
//        }else if([dict[@"res"] isEqualToString:@"-3"]){
//            failure(@"用户已在其他地方登陆，请重试");
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)quitUserWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    if(book->user.name==nil){
        success(nil);
        return;
    }
    NSURL* url = [NSURL URLWithString:@"login.jsp?mode=quit" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(nil);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"quit"};
//    [m GET:@"login.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(nil);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)changeLoc:(Location)loc{
    book->loc = loc;
}
+(Location)getLoc{
    return book->loc;
}
+(void)loadBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* clearUrl = [NSURL URLWithString:@"booksInfo.jsp?mode=reset" relativeToURL:BASE_URL];
    ASIHTTPRequest* clearRequest = [[ASIHTTPRequest alloc]initWithURL:clearUrl];
    [clearRequest startSynchronous];
    if(!clearRequest.error){
        book->cachedBooks = [NSMutableArray arrayWithCapacity:5];
        book->realBookCnt = 0;
       [self getBookAt:4 withFailure:^(id desc) {//加载第一组5个
           failure(desc);
       }];
       success(nil);
    }else{
        failure(@"无法连接至服务器，请重试");
    }
//    NSDictionary* params = @{@"mode":book->loc==NJ?@"NJ":@"NFLS"};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    book->cachedBooks = [NSMutableArray array];
//    book->realBookCnt = 0;
//    [m GET:@"booksInfo.jsp" parameters:@{@"mode":@"reset"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary* dict = responseObject;
//            if([dict[@"res"] isEqualToString:@"1"]){
//                NSDictionary* books = dict[@"content"][@"books"];
//                book->realBookCnt = [dict[@"content"][@"totalCount"] intValue];
//                book->cachedBooks = [NSMutableArray arrayWithCapacity:5];
//                for(NSDictionary* b in books){
//                    addBook(book->cachedBooks, b);
//                }
//                success(nil);
//            }else{
//                failure(@"服务器出错，请重试");
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            failure(@"无法连接至服务器，请重试");
//        }];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(User *)getUser{
    return book->user;
}
+(NSUInteger)getBooksCnt{
    return book->realBookCnt;
}
+(BookInfo*)getBookAt:(NSInteger)row withFailure:(callBackBlock)failure{
    NSInteger size;
    NSInteger addCnt = 5;
    for(size = [book->cachedBooks count]-1;size < row;size += addCnt){
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"booksInfo.jsp?mode=%@",book->loc==NJ?@"NJ":@"NFLS"] relativeToURL:BASE_URL];
        ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
        [request startSynchronous];
        if(![request error]){
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
            if([dict[@"res"] isEqualToString:@"1"]){
                NSDictionary* books = dict[@"content"][@"books"];
                for(NSDictionary* b in books){
                    addBook(book->cachedBooks, b);
                }
                book->realBookCnt = [dict[@"content"][@"totalCount"] intValue];
            }else{
                book->realBookCnt = book->cachedBooks.count;
                failure(@"服务器出错，请重试");
            }
        }else{
            book->realBookCnt = book->cachedBooks.count;
            failure(@"无法连接至服务器，请重试");
        }
    }
    if(row<book->cachedBooks.count){
        return [book->cachedBooks objectAtIndex:row];
    }else{
        return nil;
    }
//        NSDictionary* params = @{@"mode":book->loc==NJ?@"NJ":@"NFLS"};
//        AFHTTPSessionManager* m = GETMANAGER;
//        m.requestSerializer = [AFJSONRequestSerializer serializer];
//        [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary* dict = responseObject;
//            if([dict[@"res"] isEqualToString:@"1"]){
//                NSDictionary* books = dict[@"content"][@"books"];
//                for(NSDictionary* b in books){
//                    addBook(book->cachedBooks, b);
//                }
//                success([book->cachedBooks objectAtIndex:row]);
//            }else{
//                book->realBookCnt = book->cachedBooks.count;
//                failure(@"服务器出错，请重试");
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            book->realBookCnt = book->cachedBooks.count;
//            failure(@"无法连接至服务器，请重试");
//        }];
}
+(void)setKind:(BookKind)kind{
    switch (kind) {
        case All:
            kind_str = @"&kind=all";
            break;
        default:
            break;
    }
}
+(void)getNewsWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:@"news.jsp?mode=get" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* news = dict[@"content"];
            NSMutableArray* all = [NSMutableArray arrayWithCapacity:5];
            NSMutableArray* user = [NSMutableArray arrayWithCapacity:5];
            for(NSDictionary* n in news[@"all"]){
                [all addObject:[[NoticeInfo alloc]initWithId:[n[@"id"] intValue] text:n[@"title"] detail:n[@"content"] time:n[@"time"] withExpiredTime:n[@"expiredTime"] andAction:n[@"action"]]];
            }
            for(NSDictionary* n in news[@"user"]){
                [user addObject:[[NoticeInfo alloc]initWithId:[n[@"id"] intValue] text:n[@"title"] detail:n[@"content"] time:n[@"time"] withExpiredTime:n[@"expiredTime"] andAction:n[@"action"]]];
            }
            success(@[all,user]);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    [m GET:@"news.jsp" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* news = dict[@"content"];
//            NSMutableArray* all = [NSMutableArray arrayWithCapacity:5];
//            NSMutableArray* user = [NSMutableArray arrayWithCapacity:5];
//            for(NSDictionary* n in news[@"all"]){
//                [all addObject:[[NoticeInfo alloc]initWithText:n[@"title"] detail:n[@"content"] time:n[@"time"] withExpiredTime:n[@"expiredTime"] andAction:n[@"action"]]];
//            }
//            for(NSDictionary* n in news[@"user"]){
//                [user addObject:[[NoticeInfo alloc]initWithText:n[@"title"] detail:n[@"content"] time:n[@"time"] withExpiredTime:n[@"expiredTime"] andAction:n[@"action"]]];
//            }
//            success(@[all,user]);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)removeNews:(NSInteger)newsId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"news.jsp?mode=remove&newsId=%ld",(long)newsId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(nil);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
}
+(void)getLentBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:@"booksInfo.jsp?mode=Lent" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* books = dict[@"content"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
            for(NSDictionary* b in books){
                addBook(arr, b);
            }
            book->cachedLentBooks = arr;
            success(arr);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"Lent"};
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* books = dict[@"content"];
//            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
//            for(NSDictionary* b in books){
//                addBook(arr, b);
//            }
//            book->cachedLentBooks = arr;
//            success(arr);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)getBorrowedBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:@"booksInfo.jsp?mode=Borrowed" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* books = dict[@"content"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
            for(NSDictionary* b in books){
                addBook(arr, b);
            }
            book->cachedBorrowedBooks = arr;
            success(arr);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"Borrowed"};
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* books = dict[@"content"];
//            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
//            for(NSDictionary* b in books){
//                addBook(arr, b);
//            }
//            book->cachedBorrowedBooks = arr;
//            success(arr);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)getBookListWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:@"booksInfo.jsp?mode=List" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* books = dict[@"content"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
            for(NSDictionary* b in books){
                addBook(arr, b);
            }
            book->cachedBookList = arr;
            success(arr);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"List"};
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* books = dict[@"content"];
//            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
//            for(NSDictionary* b in books){
//                addBook(arr, b);
//            }
//            book->cachedBookList = arr;
//            success(arr);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)returnBook:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"book.jsp?mode=return&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(@"成功还书，通知已经发送给下一位等待的读者");
        }else if([dict[@"res"] isEqualToString:@"2"]){
            success(@"已经还书，还没有人想借，请等待想看的人联系你吧！");
        }else if([dict[@"res"] isEqualToString:@"3"]){
            success(@"已经还过的书不用再还了哦");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"return",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"book.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(@"成功还书，通知已经发送给下一位等待的读者");
//        }else if([dict[@"res"] isEqualToString:@"2"]){
//            success(@"已经还书，还没有人想借，请等待想看的人联系你吧！");
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)borrowBook:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"book.jsp?mode=borrow&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(nil);//借到
        }else if([dict[@"res"] isEqualToString:@"2"]){
            success(@"已加入等待队列，请耐心等待，您心仪的书很快就会漂流到你的手上啦！");
        }else if([dict[@"res"] isEqualToString:@"-2"]){
            failure(@"一个人同时只能借3本书哦！");
        }else if([dict[@"res"] isEqualToString:@"-3"]){//不会出现
            failure(@"您自己发出漂流的书不需要借哦，请等待别人来借吧！");
        }else if([dict[@"res"] isEqualToString:@"-4"]){//不会出现
            failure(@"您已经在排队了，不用再借");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"borrow",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"book.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(nil);//借到
//        }else if([dict[@"res"] isEqualToString:@"2"]){
//            success(@"已加入等待队列，请耐心等待，您心仪的书很快就会漂流到你的手上啦！");
//        }else if([dict[@"res"] isEqualToString:@"-2"]){
//            failure(@"一个人同时只能借3本书哦！");
//        }else if([dict[@"res"] isEqualToString:@"-3"]){
//            failure(@"您自己发出漂流的书不需要借哦，请等待别人来借吧！");
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)cancelWaiting:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"book.jsp?mode=cancel&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(@"取消成功");
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"cancel",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"book.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(@"取消成功");//借到
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)submitBook:(NSString*)name desc:(NSString*)desc image:(UIImage*)image withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"uploadBook.jsp?name=%@&desc=%@&loc=%@",name,desc,book->loc==NJ?@"NJ":@"NFLS"]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc]initWithURL:url];
    __weak ASIFormDataRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(@"上传成功，请等待管理员审核" );
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setData:UIImagePNGRepresentation(image) withFileName:[name stringByAppendingString:@".png"] andContentType:@"image/png" forKey:@"photo"];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    NSDictionary* params = @{@"name":name,@"desc":desc,@"loc":book->loc==NJ?@"NJ":@"NFLS"};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    book->cachedBooks = [NSMutableArray array];
//    [m POST:@"uploadBook.jsp" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"photo" fileName:[name stringByAppendingString:@".png"] mimeType:@"image/png"];
//    }  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(@"上传成功，请等待管理员审核" );
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)searchBooks:(NSString*)key withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"booksInfo.jsp?mode=%@&searchWord=%@",book->loc==NJ?@"NJ":@"NFLS",key]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            NSDictionary* books = dict[@"content"][@"books"];
            book->realBookCnt = [dict[@"content"][@"totalCount"] intValue];
            book->cachedBooks = [NSMutableArray arrayWithCapacity:5];
            for(NSDictionary* b in books){
                addBook(book->cachedBooks, b);
            }
            success(nil);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    NSDictionary* params = @{@"mode":book->loc==NJ?@"NJ":@"NFLS",@"searchWord":key};
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    book->cachedBooks = [NSMutableArray array];
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            NSDictionary* books = dict[@"content"][@"books"];
//            book->realBookCnt = [dict[@"content"][@"totalCount"] intValue];
//            book->cachedBooks = [NSMutableArray arrayWithCapacity:5];
//            for(NSDictionary* b in books){
//                addBook(book->cachedBooks, b);
//            }
//            success(nil);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)getNumsBefore:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"booksInfo.jsp?mode=Waiting&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(dict[@"content"]);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"Waiting",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(dict[@"content"]);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)getReturnDate:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"booksInfo.jsp?mode=ReturnDate&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            success(dict[@"content"][@"returnDate"]);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"ReturnDate",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"booksInfo.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            success(dict[@"content"][@"returnDate"]);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)addToBookList:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"book.jsp?mode=add&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            if(book->cachedBookList!=nil){
                for(BookInfo* info in book->cachedBooks){
                    if(info.bookId == bookId){
                        [book->cachedBookList addObject:info];
                    }
                }
            }
            success(nil);
        }else{
            failure(@"服务器出错，请重试");
        }
    }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//    m.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary* params = @{@"mode":@"add",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//    [m GET:@"book.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dict = responseObject;
//        if([dict[@"res"] isEqualToString:@"1"]){
//            if(book->cachedBookList!=nil){
//                for(BookInfo* info in book->cachedBooks){
//                    if(info.bookId == bookId){
//                        [book->cachedBookList addObject:info];
//                    }
//                }
//            }
//            success(nil);
//        }else{
//            failure(@"服务器出错，请重试");
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(@"无法连接至服务器，请重试");
//    }];
}
+(void)removeFromBookList:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"book.jsp?mode=remove&bookId=%d",bookId] relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:ref.responseData options:0 error:nil];
        if([dict[@"res"] isEqualToString:@"1"]){
            if(book->cachedBookList!=nil){
                for(BookInfo* info in book->cachedBooks){
                    if(info.bookId == bookId){
                        [book->cachedBookList removeObject:info];
                    }
                }
            }
            success(nil);
        }else{
            failure(@"服务器出错，请重试");
        }

        }];
    [request setFailedBlock:^{
        failure(@"无法连接至服务器，请重试");
    }];
    [request startAsynchronous];
//    AFHTTPSessionManager* m = GETMANAGER;
//        m.requestSerializer = [AFJSONRequestSerializer serializer];
//        NSDictionary* params = @{@"mode":@"remove",@"bookId":[NSString stringWithFormat:@"%d",bookId]};
//        [m GET:@"book.jsp" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary* dict = responseObject;
//            if([dict[@"res"] isEqualToString:@"1"]){
//                if(book->cachedBookList!=nil){
//                    for(BookInfo* info in book->cachedBooks){
//                        if(info.bookId == bookId){
//                            [book->cachedBookList removeObject:info];
//                        }
//                    }
//                }
//                success(nil);
//            }else{
//                failure(@"服务器出错，请重试");
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            failure(@"无法连接至服务器，请重试");
//        }];
}
+(NSArray*)getCachedBookList{
    return book->cachedBookList;
}
+(NSArray*)getCachedLentBooks{
    return book->cachedLentBooks;
}
+(NSArray*)getCachedBorrowedBooks{
    return book->cachedBorrowedBooks;
}
@end