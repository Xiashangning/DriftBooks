//
//  CommentModel.m
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//
#import "Constant.h"
#import "CommentModel.h"

@implementation CommentModel

-(instancetype)initWithId:(int)comid from:(NSString *)from addr:(NSString *)addr comment:(NSString *)com time:(NSString *)time floor:(int)f{
    
    if (self = [super init]) {
        self.comId = comid;
        self.address = addr;
        self.comment =com;
        self.name = from;
        self.timeString = time;
        self.floor = [NSString stringWithFormat:@"%d",f];
    }
    return self;
    
}
- (CGSize)sizeWithConstrainedToSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: CommentFont};
    CGSize textSize         = [self.comment boundingRectWithSize:CGSizeMake(size.width, 0)
                                                 options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    return textSize;
}
@end
