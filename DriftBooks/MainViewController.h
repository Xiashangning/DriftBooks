//
//  MainViewController.h
//  DriftBooks
//
//  Created by apple on 16/4/22.
//  Copyright (c) 2016年 x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoView.h"
#import "REFrostedViewController.h"

@interface MainViewController : UITableViewController<UISearchBarDelegate>{
    NSDictionary* notice;
}
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loc;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
