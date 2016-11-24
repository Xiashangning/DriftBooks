//
//  DriftBooks.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BookInfo.h"
#import "User.h"

typedef enum{
    NJ,
    NFLS
} Location;
typedef enum{
    All
} BookKind;
@interface DriftBooks : NSObject
{
    User* user;
    Location loc;
    NSMutableArray* cachedBooks;
    NSUInteger realBookCnt;
    NSString* queryStr;
    NSMutableArray* cachedBorrowedBooks;
    NSMutableArray* cachedLentBooks;
    NSMutableArray* cachedBookList;
}
+(void)sendDeviceToken:(NSData*)deviceToken;
+(void)connectToWeb:(void (^)())canNotReach;
+(void)setVisitMod;
+(void)login:(NSString *)name pass:(NSString *)password withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)registNewUser:(NSString*)name pass:(NSString*)pass addr:(NSString*)addr phone:(NSString*)phone QQ:(NSString*)qq icon:(NSData*)icon vcode:(NSString*)code withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)quitUserWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)changeLoc:(Location)loc;
+(Location)getLoc;
+(void)loadBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(User*)getUser;
+(BookInfo*)getBookAt:(NSInteger)row withFailure:(callBackBlock)failure;
+(NSUInteger)getBooksCnt;
+(void)setKind:(BookKind)kind;
+(void)getLentBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)returnBook:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)getBorrowedBooksWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)borrowBook:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)cancelWaiting:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)getBookListWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)getNewsWithSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)removeNews:(NSInteger)newsId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)submitBook:(NSString*)name desc:(NSString*)desc image:(UIImage*)image withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)searchBooks:(NSString*)key withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)getNumsBefore:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)getReturnDate:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)addToBookList:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(void)removeFromBookList:(int)bookId withSuccess:(callBackBlock)success andFailure:(callBackBlock)failure;
+(NSArray*)getCachedLentBooks;
+(NSArray*)getCachedBorrowedBooks;
+(NSArray*)getCachedBookList;
@end