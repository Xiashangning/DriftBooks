//
//  BookInfoViewController.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "BookInfoViewController.h"
#import "DriftBooks.h"
#import "CommentTableViewCell.h"
#import "LayoutContainerView.h"
#import "CommentModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "BlurCommentView.h"
@interface BookInfoViewController ()

@end

@implementation BookInfoViewController
@synthesize info;
@synthesize comment;
@synthesize content;
@synthesize hasAdd;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* url = [NSURL URLWithString:[[@"photo.jsp?mode=book&name=" stringByAppendingString:self.info.name] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]relativeToURL:BASE_URL];
    [self.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"wait.gif"] options:SDWebImageRetryFailed];
    self.image.layer.cornerRadius = 3;
    self.image.layer.borderColor = [UIColor grayColor].CGColor;
    self.image.layer.borderWidth = 2.5f;
    self.image.clipsToBounds = YES;
    self.name.text = [self.name.text stringByAppendingString:self.info.name];
    self.from.text = [self.from.text stringByAppendingString:self.info.from.name];
    self.holder.text = [[@"现在在 " stringByAppendingString:self.info.hold.name]stringByAppendingString:@" 手上阅读"];
    self.pos.text = [self.pos.text stringByAppendingString:self.info.hold.addr];
    self.wantNum.text = [[@"有 " stringByAppendingString:[NSString stringWithFormat:@"%d",self.info.wanting]]stringByAppendingString:@" 人表示想要"];

    self.content.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.content.text = [@"内容：\n" stringByAppendingString:self.info.content];
    CGSize s = self.content.contentSize;
    
    self.comment = [[UITableView alloc]initWithFrame:self.content.frame style:UITableViewStylePlain];
    self.comment.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.comment.backgroundView = nil;
    self.comment.delegate = self;
    self.comment.dataSource = self;
    self.comment.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.conOrcom setSelectedSegmentIndex:0];
    [self.v addSubview:self.content];
    if([self.info.hold.name isEqualToString:[DriftBooks getUser].name]){
        if([self.info.from.name isEqualToString:[DriftBooks getUser].name]){
            self.beforeNum.text = @"请等待感兴趣的人来借哦！";
        }else{
            [DriftBooks getReturnDate:self.info.bookId withSuccess:^(id desc) {
                self.beforeNum.text = [@"应还日期：" stringByAppendingString:desc];
            } andFailure:^(id desc) {
                self.beforeNum.text = @"应还日期：";
            }];
        }
        [self.button setTitle:@"还书" forState:UIControlStateNormal];
    }else{
        [DriftBooks getNumsBefore:self.info.bookId withSuccess:^(id desc) {
            self.beforeNum.text = [@"您前面排队的人数：" stringByAppendingString:[NSString stringWithFormat:@"%d",[desc[@"waitingNum"] intValue]]];
            if([desc[@"isWaiting"] isEqualToString:@"YES"]){
                [self.button setTitle:@"取消排队" forState:UIControlStateNormal];
            }
        } andFailure:^(id desc) {
            self.beforeNum.text = @"您前面排队的人数：";
        }];
        [self.button setTitle:@"借书" forState:UIControlStateNormal];
    }
    NSArray* booklist = [DriftBooks getCachedBookList];
    if(booklist!=nil){
        if([booklist containsObject:self.info]){
            self.addToList.title = @"从我的书单中移除";
            self.hasAdd = YES;
        }else{
            self.addToList.title = @"添加到我的书单";
            self.hasAdd = NO;
        }
    }else{
        [DriftBooks getBookListWithSuccess:^(id desc) {
            NSArray* booklist = [DriftBooks getCachedBookList];
            if([booklist containsObject:self.info]){
                self.addToList.title = @"从我的书单中移除";
                self.hasAdd = YES;
            }else{
                self.addToList.title = @"添加到我的书单";
                self.hasAdd = NO;
            }
        } andFailure:^(id desc) {
            self.addToList.title = @"添加到我的书单";
            self.hasAdd = NO;
        }];
    }
}
- (IBAction)addToList:(UIBarButtonItem *)sender {
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    NSString* t = sender.title;
    if([t isEqualToString:@"添加到我的书单"])
    {
        [DriftBooks addToBookList:self.info.bookId withSuccess:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
            sender.title = @"从我的书单中移除";
        } andFailure:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"添加失败" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }else if([t isEqualToString:@"从我的书单中移除"]){
        [DriftBooks removeFromBookList:self.info.bookId withSuccess:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"移除成功" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
            sender.title = @"添加到我的书单";
        } andFailure:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"移除失败" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }
}
- (IBAction)commenting:(id)sender {
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    __weak BookInfoViewController* ref = self;
    [BlurCommentView commentshowInView:self.view success:^(NSString *commentText) {
        if([commentText isEqualToString:@""]){
            return;
        }
        [self.info addComment:commentText below:-1 withSuccess:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [ref presentViewController:ac animated:YES completion:nil];
            [ref.comment reloadData];
        } andFailure:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [ref presentViewController:ac animated:YES completion:nil];
        }];
    }];
}
- (IBAction)change:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==0){
        [self.comment removeFromSuperview];
        [self.v addSubview:self.content];
    }else{
        [self.content removeFromSuperview];
        [self.v addSubview:self.comment];
    }
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)borrowOrRet:(UIButton *)sender {
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    if([self.button.currentTitle isEqualToString:@"借书"]){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"借书" message:[NSString stringWithFormat:@"您确定要借《%@》吗？",self.info.name] preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DriftBooks borrowBook:self.info.bookId withSuccess:^(id desc) {
                self.info.wanting++;
                if(desc!=nil){//排队
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:desc preferredStyle:UIAlertControllerStyleAlert];
                    [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:ac animated:YES completion:nil];
                }else{//借到
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"借到《%@》啦，赶快和持有者(%@)联系吧~\n他/她的地址是%@",self.info.name,self.info.hold.name,self.info.hold.addr] preferredStyle:UIAlertControllerStyleAlert];
                    [ac addAction:[UIAlertAction actionWithTitle:@"电话或短信联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"联系" message:[NSString stringWithFormat:@"他/她的电话号码是：%ld",(long)self.info.hold.phone] preferredStyle:UIAlertControllerStyleAlert];
                        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:ac animated:YES completion:nil];
                    }]];
                    [ac addAction:[UIAlertAction actionWithTitle:@"QQ联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"联系" message:[NSString stringWithFormat:@"他/她的QQ号码是：%ld",(long)self.info.hold.QQ] preferredStyle:UIAlertControllerStyleAlert];
                        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:ac animated:YES completion:nil];
                    }]];
                    [ac addAction:[UIAlertAction actionWithTitle:@"稍后联系" style:
                        UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"联系" message:@"您还可以在通知界面中查看哦" preferredStyle:UIAlertControllerStyleAlert];
                            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                            [self presentViewController:ac animated:YES completion:nil];
                    }]];
                    [self presentViewController:ac animated:YES completion:nil];
                }
            } andFailure:^(id desc) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
            }];
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }else if([self.button.currentTitle isEqualToString:@"还书"]){
        [DriftBooks returnBook:self.info.bookId withSuccess:^(id desc) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        } andFailure:^(id desc) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }else if ([self.button.currentTitle isEqualToString:@"取消排队"]){
        [DriftBooks cancelWaiting:self.info.bookId withSuccess:^(id desc) {
            self.info.wanting--;
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        } andFailure:^(id desc) {
            UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
        [self.button setTitle:@"借书" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == [self.info getCommentCount]){
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.textAlignment = NSTextAlignmentJustified;
        cell.textLabel.text = @"                                          没有更多了";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        [cell.contentView bringSubviewToFront:cell.textLabel];
        return cell;
    }else{
        CommentTableViewCell* cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LayoutContainerView * container =[[LayoutContainerView alloc] initWithModelArray:[self.info getCommentAt:indexPath.row withFailure:^(id desc) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }]];
        [cell.contentView addSubview:container];
        [cell.contentView bringSubviewToFront:container];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.info getCommentCount]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != [self.info getCommentCount]){
        LayoutContainerView * container = [((CommentTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath]).contentView.subviews objectAtIndex:0];
        return container.frame.size.height;
    }else{
        return 23;
    }
}

@end
