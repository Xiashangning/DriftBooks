//
//  NoticeViewController.h
//  DriftBooks
//
//  Created by ios11 on 16/5/18.
//  Copyright © 2016年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UITableViewController
@property NSMutableArray* userNews;
@property NSMutableArray* allNews;
@property (weak, nonatomic) IBOutlet UINavigationItem *navi;

@end
