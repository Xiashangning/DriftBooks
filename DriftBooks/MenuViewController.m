//
//  MenuViewController.m
//  DriftBooks
//
//  Created by ios11 on 16/4/27.
//  Copyright © 2016年 x. All rights reserved.
//

#import "MenuViewController.h"
#import "DriftBooks.h"
#import "BookListTableViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.icon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    NSURL* url;
    if([DriftBooks getUser].name){
        url = [NSURL URLWithString:[[@"photo.jsp?mode=user&name=" stringByAppendingString:[DriftBooks getUser].name]stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] relativeToURL:BASE_URL];
    }else{
        url = [NSURL URLWithString:@"photo.jsp?mode=user" relativeToURL:BASE_URL];
    }
    [self.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"wait.gif"] options:SDWebImageRetryFailed];
    self.icon.layer.cornerRadius = 63;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.icon.layer.borderWidth = 3.0f;
    self.icon.clipsToBounds = YES;
    if([DriftBooks getUser].name!=nil){
        self.uname.text = [DriftBooks getUser].name;
    }else{
        self.uname.text = @"访客";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4){
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"设置" message:[NSString stringWithFormat:@"当前用户 %@",[DriftBooks getUser].name] preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"修改密码" message:@"敬请期待。。。" preferredStyle:UIAlertControllerStyleAlert];
            [a addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:a animated:YES completion:nil];
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"个人信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"个人信息" message:[NSString stringWithFormat:@"地址：%@\n电话：%ld\nQQ：%ld",[DriftBooks getUser].addr,(long)[DriftBooks getUser].phone,(long)[DriftBooks getUser].QQ] preferredStyle:UIAlertControllerStyleAlert];
            [a addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:a animated:YES completion:nil];
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"关于本程序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"关于本程序" message:@"作者：夏尚宁(Ritchie Xia) QQ:1750546761" preferredStyle:UIAlertControllerStyleAlert];
            [a addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:a animated:YES completion:nil];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }else if(indexPath.row == 5){
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DriftBooks quitUserWithSuccess:^(id desc) {
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"entryView"] animated:YES completion:nil];
            } andFailure:^(id desc) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
            }];
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return NO;
    }
    return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *t;
    if([segue.identifier isEqualToString:@"notices"])
    {
        return;
    }else if([segue.identifier isEqualToString:@"lent"])
    {
        t = @"我加入漂流的书";
    }else if([segue.identifier isEqualToString:@"borrowed"])
    {
        t = @"我借的书";
    }else if([segue.identifier isEqualToString:@"booklist"]){
        t = @"我的书单";
    }
    [segue.destinationViewController setValue:t forKey:@"t"];
}
@end
