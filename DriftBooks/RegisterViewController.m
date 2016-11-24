//
//  RegisterViewController.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "RegisterViewController.h"
#import "DriftBooks.h"
#import "ASIHTTPRequest.h"

@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.icon.layer.cornerRadius = 10;
    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpInside:)];
    [self.icon addGestureRecognizer:gr];
    self.icon.layer.borderColor = [UIColor colorWithRed:66./255 green:133./255 blue:200./255 alpha:1].CGColor;
    self.icon.layer.borderWidth = 2.5f;
    self.icon.clipsToBounds = YES;
    self.codeImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeImage.layer.borderWidth = 0;
}
- (IBAction)done:(id)sender {
    [sender resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)touchBg:(id)sender {
    [self.view endEditing:YES];
}
-(void)touchUpInside:(UITapGestureRecognizer *)gr{
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* icon = [info objectForKey:UIImagePickerControllerEditedImage];
    if(icon!=nil){
        self.icon.image = icon;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getVerityCode:(id)sender {
    NSURL* url = [NSURL URLWithString:@"auth.jpg" relativeToURL:BASE_URL];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:url];
    __weak ASIHTTPRequest* ref = request;
    [request setCompletionBlock:^{
        self.codeImage.image = [UIImage imageWithData:ref.responseData];
    }];
    [request setFailedBlock:nil];
    [request startAsynchronous];
}
- (IBAction)submit:(id)sender {
    [DriftBooks registNewUser:self.name.text pass:self.pass.text addr:self.addr.text phone:self.contact.text QQ:self.qq.text icon:UIImagePNGRepresentation(self.icon.image) vcode:self.vCode.text withSuccess:^(NSString* info) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:info preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performSegueWithIdentifier:@"Submit_s" sender:self];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    } andFailure:^(NSString* info) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"对不起" message:info preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self performSegueWithIdentifier:@"Return_s" sender:self];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Submit_s"])
    {
        [segue.destinationViewController setValue:self.name.text forKey:@"user_name"];
    }
}

@end
