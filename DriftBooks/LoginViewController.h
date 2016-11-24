//
//  LoginViewController.h
//  DriftBooks
//
//  Created by apple on 16/4/22.
//  Copyright (c) 2016年 x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface LoginViewController : UIViewController
{
    NSString* user_name;
}
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property (strong, nonatomic) IBOutlet UILabel *forgetPass;
@property (strong, nonatomic) IBOutlet UILabel *registNew;
@property (strong, nonatomic) IBOutlet UILabel *visitor;
@end
