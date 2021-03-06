//
//  MBProgressHUD+tips.h
//  Avantech
//
//  Created by avantech on 2018/1/30.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (tips)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
