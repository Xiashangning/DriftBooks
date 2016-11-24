//
//  BookListTableViewController.m
//  DriftBooks
//
//  Created by ios11 on 16/4/27.
//  Copyright © 2016年 x. All rights reserved.
//

#import "BookListTableViewController.h"
#import "DriftBooks.h"
#import "BookInfo.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/UIImage+GIF.h"
static BOOL refreshing;
@interface BookListTableViewController ()

@end

@implementation BookListTableViewController
@synthesize books;
@synthesize t;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.barTitle.title = self.t;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    if([self.t isEqualToString:@"我加入漂流的书"]){
        self.books = [DriftBooks getCachedLentBooks];
    }else if ([self.t isEqualToString:@"我借的书"]){
        self.books = [DriftBooks getCachedBorrowedBooks];
    }else{
        self.books = [DriftBooks getCachedBookList];
    }
    if (self.books==nil) {
        self.books = [NSArray array];
        [self refresh];
    }
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refresh{
    refreshing = YES;
    NSArray* temp = self.books;
    self.books = [NSArray array];
    [self.tableView reloadData];
    if([self.t isEqualToString:@"我加入漂流的书"]){
        [DriftBooks getLentBooksWithSuccess:^(id desc) {
            self.books = desc;
            [self refreshEnd];
        } andFailure:^(id desc) {
            self.books = temp;
            [self refreshEnd];
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }else if ([self.t isEqualToString:@"我借的书"]){
        [DriftBooks getBorrowedBooksWithSuccess:^(id desc) {
            self.books = desc;
            [self refreshEnd];
        } andFailure:^(id desc) {
            self.books = temp;
            [self refreshEnd];
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }else{
        [DriftBooks getBookListWithSuccess:^(id desc) {
            self.books = desc;
            [self refreshEnd];
        } andFailure:^(id desc) {
            self.books = temp;
            [self refreshEnd];
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }
}
-(void)refreshEnd{
    [self.refreshControl endRefreshing];
    refreshing = NO;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [books count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row != [books count]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 10;
        BookInfo *info = [self.books objectAtIndex:indexPath.row];
        UIImageView* v = (UIImageView *)[cell viewWithTag:1];
        NSURL* url;
        url = [NSURL URLWithString:[[@"photo.jsp?mode=book&name=" stringByAppendingString:info.name] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]relativeToURL:BASE_URL];
        [v sd_setImageWithURL:url placeholderImage:[UIImage sd_animatedGIFNamed:@"wait.gif"] options:SDWebImageRetryFailed];
        v.layer.cornerRadius = 3;
        v.layer.borderColor = [UIColor grayColor].CGColor;
        v.layer.borderWidth = 2.5f;
        v.clipsToBounds = YES;
        UILabel* l = (UILabel *)[cell viewWithTag:2];
        l.text = [@"书名：" stringByAppendingString:info.name];
        l = (UILabel *)[cell viewWithTag:3];
        l.text = [[@"由 " stringByAppendingString:info.from.name]stringByAppendingString: @" 加入漂流"] ;
        l = (UILabel *)[cell viewWithTag:4];
        l.text = [@"内容：" stringByAppendingString:info.content];
        l = (UILabel *)[cell viewWithTag:5];
        l.text = [[@"现在在 " stringByAppendingString:info.hold.name]stringByAppendingString:@" 手里"];
        l = (UILabel *)[cell viewWithTag:6];
        l.text = [[@"目前有 " stringByAppendingString:[NSString stringWithFormat:@"%d",info.wanting]]stringByAppendingString:@" 人表示想要"];
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"noMoreCell"];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if(refreshing){
            ((UILabel*)[cell viewWithTag:1]).text = @"加载中。。。。";
        }else{
            ((UILabel*)[cell viewWithTag:1]).text = @"没有更多了";
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != [books count]){
        return 170;
    }else{
        return 23;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"List_s"])
    {
        [segue.destinationViewController setValue:[books objectAtIndex:self.tableView.indexPathForSelectedRow.row] forKey:@"info"];
    }
    
}
@end
