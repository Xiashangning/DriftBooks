//
//  NoticeViewController.m
//  DriftBooks
//
//  Created by ios11 on 16/5/18.
//  Copyright © 2016年 x. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeInfo.h"
#import "DriftBooks.h"
static BOOL refreshing;
@interface NoticeViewController ()

@end

@implementation NoticeViewController
@synthesize userNews;
@synthesize allNews;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.allNews = [NSMutableArray array];
    self.userNews = [NSMutableArray array];
    [self refresh];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)refresh{
    refreshing = YES;
    NSMutableArray* allt = self.allNews;
    NSMutableArray* usert = self.userNews;
    self.allNews = [NSMutableArray array];
    self.userNews = [NSMutableArray array];
    [self.tableView reloadData];
    [DriftBooks getNewsWithSuccess:^(NSArray *arr) {
        self.allNews = arr[0];
        self.userNews = arr[1];
        refreshing = NO;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } andFailure:^(NSString *desc) {
        self.allNews = allt;
        self.userNews = usert;
        refreshing = NO;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"刷新失败" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return self.allNews.count+1;
    }else{
        return self.userNews.count+1;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"系统通知";
    }else{
        return @"用户通知";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row!=self.allNews.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell" forIndexPath:indexPath];
            NoticeInfo* info = (NoticeInfo*)[self.allNews objectAtIndex:indexPath.row];
            cell.textLabel.text = info.text;
            cell.detailTextLabel.text = info.detail;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noMoreCell" forIndexPath:indexPath];
            if(refreshing){
                ((UILabel*)[cell viewWithTag:1]).text = @"加载中。。。。";
            }else{
                ((UILabel*)[cell viewWithTag:1]).text = @"没有更多了";
            }
            return cell;
        }
    }else{
        if(indexPath.row!=self.userNews.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell" forIndexPath:indexPath];
            NoticeInfo* info = (NoticeInfo*)[self.userNews objectAtIndex:indexPath.row];
            cell.textLabel.text = info.text;
            cell.detailTextLabel.text = info.detail;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noMoreCell" forIndexPath:indexPath];
            if(refreshing){
                ((UILabel*)[cell viewWithTag:1]).text = @"加载中。。。。";
            }else{
                ((UILabel*)[cell viewWithTag:1]).text = @"没有更多了";
            }
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0?indexPath.row>=self.allNews.count:indexPath.row>=self.userNews.count){
        return;
    }
    NoticeInfo* news = indexPath.section==0?self.allNews[indexPath.row]:self.userNews[indexPath.row];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:news.text message:[NSString stringWithFormat:@"%@\n发布时间：%@\n将于 %@ 过期",news.detail,news.time,news.expiredTime] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
    if([news.action isEqualToString:@"REMOVE"]){
        [ac addAction:[UIAlertAction actionWithTitle:@"已交换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DriftBooks removeNews:news.ID withSuccess:^(id desc) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定成功" preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
                if(indexPath.section==0){
                    [self.allNews removeObjectAtIndex:indexPath.row];
                }else{
                    [self.userNews removeObjectAtIndex:indexPath.row];
                }
                [self.tableView reloadData];
            } andFailure:^(id desc) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
            }];
        }]];
    }
    [self presentViewController:ac animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.section==0&&indexPath.row!=self.allNews.count)||(indexPath.section==1&&indexPath.row!=self.userNews.count)){
        return 44;
    }else{
        return 23;
    }
}
@end
