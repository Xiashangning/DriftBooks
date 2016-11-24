//
//  InfoView.h
//  DriftBooks
//
//  Created by XiaShangning on 16/4/3.
//  Copyright © 2016年 XiaShangning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIPickerView<UIPickerViewDelegate,
                                UIPickerViewDataSource>
@property NSArray *infos;
@end
