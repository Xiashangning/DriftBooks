//
//  InfoView.m
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import "InfoView.h"
#import "DriftBooks.h"

@implementation InfoView
@synthesize infos;
-(void)myInit{
    self.infos = [NSArray arrayWithObjects:@"你好，欢迎进入漂流图书",@"点击用户图标可以进入菜单", nil];
    self.delegate = self;
    self.dataSource = self;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;}
-(id)init{
    self = [super init];
    if(self)
    {
        [self myInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self  = [super initWithCoder:aDecoder];
    if (self) {
        [self myInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self myInit];
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.infos.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, pickerView.frame.size.height)];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = [((InfoView *)pickerView).infos objectAtIndex:row];
    l.font = [UIFont systemFontOfSize:13];
    l.backgroundColor = [UIColor clearColor];
    return l;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 23;
}

@end
