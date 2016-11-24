//
//  BookListTableViewController.h
//  DriftBooks
//
//  Created by ios11 on 16/4/27.
//  Copyright © 2016年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *barTitle;
@property NSArray *books;
@property NSString *t;
@end
