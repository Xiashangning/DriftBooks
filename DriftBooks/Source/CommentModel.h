//
//  CommentModel.h
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface CommentModel : NSObject
@property int comId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *timeString;
@property (nonatomic,strong) NSString *floor;


-(instancetype)initWithId:(int)comid from:(NSString*)from addr:(NSString*)addr comment:(NSString*)com time:(NSString*)time floor:(int)f;
-(CGSize)sizeWithConstrainedToSize:(CGSize)sz;
@end
