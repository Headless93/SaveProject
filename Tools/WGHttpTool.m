//
//  WGHttpTool.m
//  UP优屏后台监控
//
//  Created by avantech on 2018/1/30.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "WGHttpTool.h"
#import "WGNetClicnet.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#define kTimeOut 5.0
static AFHTTPSessionManager *manger_;
@interface WGHttpTool ()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>
{
    //下载
    HttpToolProgressBlock _dowloadProgressBlock;
    HttpToolCompletionBlock _downladCompletionBlock;
    NSURL *_downloadURL;
    
    
    //上传
    HttpToolProgressBlock _uploadProgressBlock;
    HttpToolCompletionBlock _uploadCompletionBlock;
}
@end
@implementation WGHttpTool

+ (instancetype)sharedManager {
    static WGHttpTool *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

+(void)initialize
{
    
    if (!manger_) {
        manger_ =[AFHTTPSessionManager manager];
        manger_.requestSerializer.timeoutInterval =10.0;
        manger_.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain",
         @"text/html", nil];
        
    }
    
}
/**
 *  通用方法GET
 *
 *  @param params 传入所需要的参数
 */
-(void)requestGET_WithParams:(id)params andBlock:(void (^)(id responseData, NSError *error))block
{
    [[WGNetClicnet sharedJsonClient] requestJsonDataWithPath:@"" withParams:params withMethodType:Get andBlock:^(id responseData, NSError *error)
     {
         if(responseData)
         {
             block(responseData,nil);
         }
         else
         {
             block(nil,error);
         }
     }];
}

/**
 *  通用方法
 *
 *  @param params 传入所需要的参数
 */
-(void)request_WithParams:(id)params andBlock:(void (^)(id responseData, NSError *error))block
{
    [[WGNetClicnet sharedJsonClient] requestJsonDataWithPath:@"" withParams:params withMethodType:Post andBlock:^(id responseData, NSError *error)
     {
         WGLog(@"responseData = %@",responseData);
         if(responseData)
         {
             block(responseData,nil);
         }
         else
         {
             block(nil,error);
         }
     }];
}

+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id respondObj))success failure:(void (^)(NSError *error))failure
{
    
    
    [manger_ GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

/*通用put请求 */
+(void)put:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id respondObj ))success failure:(void(^)(NSError *error))failure
{
    [manger_ PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id respondObj   ))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray * httpArr = [WGLogicTool getHttpTokenAndReqtime];
    [dict setValue:httpArr[0] forKey:@"token"];
    [dict setValue:httpArr[1] forKey:@"reqtime"];

//    if (!url) {
//        url = WGTestBaseUrl;
//    }
    WGLog(@"url:%@",url);
    [manger_ POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress * _Nonnull))progress success:(void (^)(id))success failure:(void (^)(NSError *))fail
{
    [manger_ POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}

+(void)uploadWithData:(NSData *)data url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress * _Nonnull))progress success:(void (^)(id))success failure:(void (^)(NSError *))fail
{
    
    [manger_ POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark - 上传
-(void)uploadData:(NSData *)data url:(NSURL *)url progressBlock:(HttpToolProgressBlock)progressBlock completion:(HttpToolCompletionBlock)completionBlock{
    
    NSAssert(data != nil, @"上传数据不能为空");
    NSAssert(url != nil, @"上传文件路径不能为空");
    
    _uploadProgressBlock = progressBlock;
    _uploadCompletionBlock = completionBlock;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeOut];
    request.HTTPMethod = @"PUT";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //NSURLSessionDownloadDelegate
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    //定义下载操作
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data];
    
    [uploadTask resume];
}

#pragma mark - 上传代理

#pragma mark - 上传进度
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    if (_uploadProgressBlock) {
        CGFloat progress = (CGFloat) totalBytesSent / totalBytesExpectedToSend;
        _uploadProgressBlock(progress);
    }
}

#pragma mark - 上传完成
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (_uploadCompletionBlock) {
        _uploadCompletionBlock(error);
        
        _uploadProgressBlock = nil;
        _uploadCompletionBlock = nil;
    }
}

#pragma mark - 下载
-(void)downLoadFromURL:(NSURL *)url progressBlock:(HttpToolProgressBlock)progressBlock completion:(HttpToolCompletionBlock)completionBlock{
    
    NSAssert(url != nil, @"下载URL不能传空");
    
    _downloadURL = url;
    _dowloadProgressBlock = progressBlock;
    _downladCompletionBlock = completionBlock;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeOut];
    
    //session 大多数使用单例即可
    NSURLResponse *response = nil;
    
    //发达同步请求
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //WGLog(@"%lld",response.expectedContentLength);
    if (response.expectedContentLength <= 0) {
        if (_downladCompletionBlock) {
            NSError *error =[NSError errorWithDomain:@"文件不存在" code:404 userInfo:nil];
            _downladCompletionBlock(error);
            
            //清除block
            _downladCompletionBlock = nil;
            _dowloadProgressBlock = nil;
        }
        return;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //NSURLSessionDownloadDelegate
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    //定义下载操作
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    
    [downloadTask resume];
    
}

#pragma mark -NSURLSessionDownloadDelegate
#pragma mark 下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    //图片保存在沙盒的Doucument下
    NSString *fileSavePath = [self fileSavePath:[_downloadURL lastPathComponent]];
    
    //文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtURL:location toURL:[NSURL fileURLWithPath:fileSavePath] error:nil];
    
    if (_downladCompletionBlock) {
        //通知下载成功，没有没有错误
        _downladCompletionBlock(nil);
        
        //清空block
        _downladCompletionBlock = nil;
        _dowloadProgressBlock = nil;
    }
}

#pragma mark 下载进度
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    
    if (_dowloadProgressBlock) {
        //已写数据字节数除以总字节数就是下载进度
        CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
        
        _dowloadProgressBlock(progress);
        
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

#pragma mark -传一个文件名，返回一个在沙盒Document下的文件路径
-(NSString *)fileSavePath:(NSString *)fileName{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //图片保存在沙盒的Doucument下
    return [document stringByAppendingPathComponent:fileName];
}


+(AFHTTPSessionManager*)getHttpM{
    static AFHTTPSessionManager*manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[AFHTTPSessionManager manager] ;
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager .requestSerializer.timeoutInterval=8;
    });
    return manager;
}

+(void)UploadURl:(NSString *)url andParms:(NSMutableDictionary *)parms andData:(NSData*)data success:(void(^)(NSDictionary*result))success failure:(void(^)(NSError * _Nonnull error))failure{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager] ;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager .requestSerializer.timeoutInterval=15;
    NSString* hideHub=parms[HIDEMBHUBKEY];
    if(!hideHub){
        //[MBHUDTool hideHUD];
        // [MBHUDTool showMessage:@""];
    }
    // 设置上传图片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        if ([[retDic allKeys] count]>0) {
        //            //这里解密
        //            NSString*  json=[StringEncryption DecryptString:[retDic valueForKey:[[retDic allKeys] objectAtIndex:0]] key:APP_AMEI_KEY];
        //            // WGLog(@"str%@",json);
        //
        //            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        //            NSError *err;
        //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
        //                                                                options:NSJSONReadingMutableContainers
        //                                                                  error:&err];
        //            if(err)
        //            {
        //                WGLog(@"json解析失败：%@",err);
        //                success(nil);
        //            }else{
        //                if ([NSObject responseSusOrNot:dic]) {
        //
        //                    success(dic);
        //                }else{
        //                    success(nil);
        //                    [NSObject showResponseErrorMsg:dic];
        //                }
        //
        //            }
        //        }
        //
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WGLog(@"%@",error);
        
        failure(error);
        
    }];
}

@end
