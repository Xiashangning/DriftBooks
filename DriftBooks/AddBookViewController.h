//
//  AddBookViewController.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *desc;

@end
