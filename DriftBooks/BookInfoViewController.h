//
//  BookInfoViewController.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfo.h"

@interface BookInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *holder;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *pos;
@property (weak, nonatomic) IBOutlet UILabel *wantNum;
@property (weak, nonatomic) IBOutlet UILabel *beforeNum;
@property (weak, nonatomic) IBOutlet UIView *v;
@property (weak, nonatomic) IBOutlet UISegmentedControl *conOrcom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToList;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property BookInfo* info;
@property UITableView* comment;
@property BOOL hasAdd;
@end
