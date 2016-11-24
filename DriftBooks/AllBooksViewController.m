//
//  AllBooksViewController.m
//  DriftBooks
//
//  Created by ios11 on 16/4/27.
//  Copyright © 2016年 x. All rights reserved.
//

#import "AllBooksViewController.h"

@interface AllBooksViewController ()

@end

@implementation AllBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)awakeFromNib{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentView"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuView"];
    [super awakeFromNib];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
