//
//  UIImageView+Extension.m
//  Avantech
//
//  Created by avantech on 2018/1/30.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)


-(void)initErCodeWithString:(NSString *)dataString withSize:(CGFloat)size{
    
    // 1.创建滤镜
    
    CIFilter *filter = [CIFilter   filterWithName:@"CIQRCodeGenerator"];
    
    // 2.还原滤镜默认属性
    
    [filter setDefaults];
    
    // 3.设置需要生成二维码的数据到滤镜中
    
    // OC中要求设置的是一个二进制数据
    
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"InputMessage"];
    
    // 4.从滤镜从取出生成好的二维码图片
    
    CIImage *ciImage = [filter outputImage];
    
    self.layer.shadowOffset = WGCGSizeMake(0, 0.5);          // 设置阴影的偏移量
    
    self.layer.shadowRadius = 1;  // 设置阴影的半径
    
    self.layer.shadowColor = [UIColor  blackColor].CGColor; // 设置阴影的颜色为黑色
    
    self.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
    
    self.image = [self createNonInterpolatedUIImageFormCIImage:ciImage size:size];
    
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight
{
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return [self imageBlackToTransparent:newImage withRed:0.0f andGreen:0.0f andBlue:0.0f];
}


void ProviderReleaseData (void *info, const void *data, size_t size){
    
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    
    const int imageWidth = image.size.width;
    
    const int imageHeight = image.size.height;
    
    size_t      bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
            
        {
            
            // 改成下面的代码，会将图片转成想要的颜色
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[3] = red; //0~255
            
            ptr[2] = green;
            
            ptr[1] = blue;
            
        }
        
        else
            
        {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[0] = 0;
            
        }
        
    }
    
    // 输出图片
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

- (void)setHeader:(NSString *)url
{
    //    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    //    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        self.image = image ? [image circleImage] : placeholder;
    //    }];
}

@end
