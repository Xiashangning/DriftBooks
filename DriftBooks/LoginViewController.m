//
//  LoginViewController.m
//  DriftBooks
//
//  Created by apple on 16/4/22.
//  Copyright (c) 2016年 x. All rights reserved.
//

#import "LoginViewController.h"
#import "DriftBooks.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *labelTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forget:)];
    UITapGestureRecognizer *labelTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regist:)];
    UITapGestureRecognizer *labelTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visit:)];
    [self.forgetPass addGestureRecognizer:labelTap1];
    [self.registNew addGestureRecognizer:labelTap2];
    [self.visitor addGestureRecognizer:labelTap3];
    self.name.text = self->user_name;
}
-(void)viewDidAppear:(BOOL)animated{
    [self retry];
}
- (IBAction)done:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)login:(id)sender {
    [DriftBooks login:self.name.text pass:self.pass.text withSuccess:^(NSString* desc){
        [self performSegueWithIdentifier:@"Enter_s" sender:self];
    }andFailure:^(NSString *desc) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
-(void)retry{
    [DriftBooks connectToWeb:^{
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"网络无法连接，请检查后再试！" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            exit(0);
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self retry];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
-(void) forget:(UITapGestureRecognizer *)recognizer{
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"找回密码" message:@"请选择找回方式" preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}
-(void) regist:(UITapGestureRecognizer *)recognizer{
    [self performSegueWithIdentifier:@"Regist_s" sender:self];
}
-(void) visit:(UITapGestureRecognizer *)recognizer{
    [DriftBooks setVisitMod];
    [self performSegueWithIdentifier:@"Enter_s" sender:self];
}
- (IBAction)touchBg:(UIControl *)sender {
    [self.view endEditing:YES];
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
