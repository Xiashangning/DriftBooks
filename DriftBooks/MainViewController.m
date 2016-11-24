//
//  MainViewController.m
//  DriftBooks
//
//  Created by apple on 16/4/22.
//  Copyright (c) 2016年 x. All rights reserved.
//

#import "MainViewController.h"
#import "DriftBooks.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/UIImage+GIF.h"
static BOOL refreshing;
static BOOL firstInit = YES;
static NSIndexPath *selectedRow;
@interface MainViewController ()

@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* url;
    if([DriftBooks getUser].name){
        url = [NSURL URLWithString:[[@"photo.jsp?mode=user&name=" stringByAppendingString:[DriftBooks getUser].name]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]relativeToURL:BASE_URL];
    }else{
        url = [NSURL URLWithString:[@"photo.jsp?mode=user" stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]relativeToURL:BASE_URL];
    }
    [self.userIcon sd_setImageWithURL:url placeholderImage:[UIImage sd_animatedGIFNamed:@"wait.gif"] options:SDWebImageCacheMemoryOnly];
    [self.userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu)]];
    self.userIcon.layer.cornerRadius = 3;
    self.userIcon.layer.borderColor = [UIColor colorWithRed:66./255 green:133./255 blue:200./255 alpha:1].CGColor;
    self.userIcon.layer.borderWidth = 2.5f;
    self.userIcon.clipsToBounds = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    UIPanGestureRecognizer *pg = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(rightSide:)];
    [self.tableView.tableHeaderView addGestureRecognizer:pg];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.searchBar.delegate = self;
    [self.loc setSelectedSegmentIndex:[DriftBooks getLoc]==NJ?0:1];
    if(firstInit){
        firstInit = NO;
        [self refresh];
    }else{
        if(selectedRow!=nil){
            [self.tableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        selectedRow = nil;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if(self->notice!=nil){
        //显示通知。。。取决于dict的key,目前还没好
    }
}
-(void)rightSide:(UIPanGestureRecognizer *)sender{
    [self.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}
-(void)showMenu{
    [self.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
- (void)refresh{
    [self.view endEditing:YES];
    self.searchBar.text = @"";
    refreshing = YES;
    [DriftBooks loadBooksWithSuccess:^(NSString *desc) {
        [self.refreshControl endRefreshing];
        refreshing = NO;
        [self.tableView reloadData];
    } andFailure:^(NSString *desc) {
        [self.refreshControl endRefreshing];
        refreshing = NO;
        [self.tableView reloadData];
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeLoc:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    [DriftBooks changeLoc:sender.selectedSegmentIndex==0?NJ:NFLS];
    [self refresh];
}
- (IBAction)changKind:(id)sender {
    [self.view endEditing:YES];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"图书分类" message:@"请选择图书种类" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [DriftBooks setKind:All];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"其他分类敬请期待" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DriftBooks getBooksCnt]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if(indexPath.row != [DriftBooks getBooksCnt]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 10;
        BookInfo* info = [DriftBooks getBookAt:indexPath.row withFailure:^(id desc) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:[@"加载图书失败，" stringByAppendingString:desc] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView reloadData];
                NSIndexPath* p = [[NSIndexPath alloc]initWithIndex:indexPath.row-5];
                [self.tableView scrollToRowAtIndexPath:p atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
        if(info == nil){
            return cell;
        }
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
        if(refreshing){
            ((UILabel*)[cell viewWithTag:1]).text = @"加载中。。。。";
        }else{
            ((UILabel*)[cell viewWithTag:1]).text = @"没有更多了";
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != [DriftBooks getBooksCnt]){
        return 170;
    }else{
        return 23;
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [DriftBooks searchBooks:self.searchBar.text withSuccess:^(id desc) {
        [self.tableView reloadData];
    } andFailure:^(id desc) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self refresh];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Info_s"])
    {
        BookInfo* info = [DriftBooks getBookAt:self.tableView.indexPathForSelectedRow.row withFailure:^(id desc) {
        }];
        [segue.destinationViewController setValue:info forKey:@"info"];
        selectedRow = self.tableView.indexPathForSelectedRow;
    }
}


@end
