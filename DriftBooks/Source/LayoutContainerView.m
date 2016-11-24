//
//  LayoutContainnerView.m
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//


#import "LayoutContainerView.h"
#import "LayoutView.h"
#import "GridLayoutView.h"
#import "CommentModel.h"
#import "Constant.h"
#import "BlurCommentView.h"
#import "DriftBooks.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/UIImage+GIF.h"
#import "BookInfoViewController.h"
@interface LayoutContainerView()

@property (nonatomic,strong) UILabel      *nameLabel;
@property (nonatomic,strong) UILabel      *addressLabel;
@property (nonatomic,strong) UIImageView  *headImageView;
@property (nonatomic,strong) UIButton     *commentButton;
@property (nonatomic,strong) CommentModel *model;

@end

@implementation LayoutContainerView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)updateWithModelArray:(NSMutableArray *)sortedArray{
    
    int i = 0;
    id lastView = nil;
    float lastH = 0;
    
    CommentModel *lastModel = [sortedArray lastObject];
    
    if(sortedArray.count > MaxOverlapNumber ){
       
        NSMutableArray *tempArray =[[NSMutableArray alloc] initWithArray:sortedArray];
        [tempArray removeObjectsInRange:NSMakeRange(sortedArray.count - MaxOverlapNumber, MaxOverlapNumber)];
        
        CGRect r = CGRectMake(44+ MaxOverlapNumber*OverlapSpace, 60 + MaxOverlapNumber*OverlapSpace, ScreenWidth - 44 -10 - 2*(MaxOverlapNumber * OverlapSpace),  0);
        GridLayoutView  *gridView =[[GridLayoutView alloc] initWithFrame:r andModelArray:tempArray];
        lastH = gridView.frame.size.height;
        [self addSubview:gridView];
        lastView = gridView;
       
        [sortedArray removeObjectsInRange:NSMakeRange(0, sortedArray.count - MaxOverlapNumber)];
  
    }
        
    for (CommentModel *model in sortedArray) {
       
        i = lastModel.floor.intValue - model.floor.intValue;
        
        CGRect r = CGRectMake(44+ i*OverlapSpace, 60 + i*OverlapSpace, ScreenWidth - 44 -10 - 2*(i * OverlapSpace), 0);
        CGSize sz = [model sizeWithConstrainedToSize:CGSizeMake(r.size.width-10, MAXFLOAT)];
        r.size.height = sz.height +lastH + 55;
        
        LayoutView *vi =[[LayoutView alloc] initWithFrame:r model:model parentView:lastView isLast:[lastModel isEqual: model]];
        
        lastH =  r.size.height;
        
        if (lastView) {
            [self insertSubview:vi belowSubview:lastView];
        }else{
            [self addSubview:vi];
        }
        lastView = vi;
    }
    
    self.frame = CGRectMake(0, 0,ScreenWidth, lastH+44);
    
    
}
-(instancetype)initWithModelArray:(NSArray *)model{
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = CellBackgroundColor;
        NSMutableArray *ar =[NSMutableArray arrayWithArray:model];
        self.model = [ar lastObject];
        
        self.backgroundColor = CellBackgroundColor;
        
        NSURL* url;
        url = [NSURL URLWithString:[[@"photo.jsp?mode=user&name=" stringByAppendingString:self.model.name] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]relativeToURL:BASE_URL];
        _headImageView  =[[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
        [_headImageView setContentMode:UIViewContentModeScaleToFill];
        _headImageView.layer.cornerRadius = 2;
        [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage sd_animatedGIFNamed:@"wait.gif"] options:SDWebImageRetryFailed];
//        _headImageView.image =[UIImage imageNamed:@"head_default.png"];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.font = AddressFont;
        _addressLabel.textColor =[UIColor grayColor];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = NameFont;
        _nameLabel.textColor = NameColor;
        
        _nameLabel.text = self.model.name;
        _addressLabel.text = self.model.address;
        
        _commentButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setUserInteractionEnabled:YES];
        _commentButton.tag = ((CommentModel*)[model objectAtIndex:0]).comId;
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"like_btn.jpg"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_commentButton];
        [self addSubview:_headImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_addressLabel];

        [self updateWithModelArray:ar];
        
    }
    return self;
}
-(void)clickComment:(UIButton*)b{
    UIViewController* vc = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController*)nextResponder;
        }
    }
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:ac animated:YES completion:nil];
        return;
    }
    __weak BookInfoViewController* ref = (BookInfoViewController*)vc;
    [BlurCommentView commentshowInView:vc.view success:^(NSString *commentText) {
        if([commentText isEqualToString:@""]){
            return;
        }
        [ref.info addComment:commentText below:(int)b.tag withSuccess:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            if(ref){
                [ref presentViewController:ac animated:YES completion:nil];
                [ref.comment reloadData];
            }
        } andFailure:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            if(ref){
                [ref presentViewController:ac animated:YES completion:nil];
                [ref.comment reloadData];
            }
        }];
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(10, 10, 30, 30);
    _nameLabel.frame = CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 4, 10 ,self.frame.size.width - 10, 34);
    _addressLabel.frame = CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 4, 30 ,self.frame.size.width - 10, 34);
    _commentButton.frame =  CGRectMake(self.frame.size.width - 32, 14 ,17, 16);
}
@end
