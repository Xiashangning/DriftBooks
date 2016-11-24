//
//  AddBookViewController.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "AddBookViewController.h"
#import "DriftBooks.h"

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image.layer.cornerRadius = 3;
    self.image.layer.borderColor = [UIColor grayColor].CGColor;
    self.image.layer.borderWidth = 2.5f;
    self.image.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchBackground:(id)sender {
    [self.name resignFirstResponder];
    [self.desc resignFirstResponder];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)upload:(id)sender {
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* icon = [info objectForKey:UIImagePickerControllerEditedImage];
    if(icon!=nil){
        self.image.image = icon;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)done:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)submit:(id)sender {
    if([DriftBooks getUser].name == nil){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    [DriftBooks submitBook:self.name.text desc:self.desc.text image:self.image.image withSuccess:^(id desc) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:desc preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    } andFailure:^(id desc) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:desc preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
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
