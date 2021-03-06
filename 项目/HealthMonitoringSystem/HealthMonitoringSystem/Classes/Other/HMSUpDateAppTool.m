//
//  HMSUpDateAppTool.m
//  HealthMonitoringSystem
//
//  Created by gw on 2017/7/12.
//  Copyright © 2017年 mirahome. All rights reserved.
//

#import "HMSUpDateAppTool.h"

@implementation HMSUpDateAppTool
+(void)hs_updateWithAPPID:(NSString *)appid error:(void(^)(NSString *error))error block:(void(^)(NSString *currentVersion,NSString *storeVersion,NSString *openUrl, BOOL isUpdate))block{
    //1先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    //2从网络获取appStore版本号
    NSError *errorMessage;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appid]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        if (error) {
            error(@"你没有连接网络哦");
        }
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&errorMessage];
    if (errorMessage) {
        NSLog(@"hsUpdateAppError:%@",errorMessage);
        if (error) {
            error(errorMessage.domain);
        }
        return;
    }
    //    NSLog(@"%@",appInfoDic);
    NSArray *array = appInfoDic[@"results"];
    
    if (array.count < 1) {
        if (error) {
            error(@"此APPID为未上架的APP或者查询不到");
        }
        NSLog(@"此APPID为未上架的APP或者查询不到");
        return;
    }
    
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    //3打印版本号
    //    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    //4设置版本号
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (currentVersion.length==2) {
        currentVersion  = [currentVersion stringByAppendingString:@"0"];
    }else if (currentVersion.length==1){
        currentVersion  = [currentVersion stringByAppendingString:@"00"];
    }
    appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appStoreVersion.length==2) {
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
    }else if (appStoreVersion.length==1){
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
    }
    
    //5当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        block(currentVersion,dic[@"version"],[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid],YES);
    }else{
        //        NSLog(@"版本号好像比商店大噢!检测到不需要更新");
        block(currentVersion,dic[@"version"],[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid],NO);
    }
    
}
@end
