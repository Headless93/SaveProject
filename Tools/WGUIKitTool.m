//
//  Utilities.m
//  
//
//  Created by avantech on 2018/1/30.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "WGUIKitTool.h"

#define UILABEL_LINE_SPACE 6
@implementation WGUIKitTool

@end
@implementation NSDictionary (Helper)

- (id)kObjectForKey:(id)aKey {
    id obj = [self objectForKey:aKey];
    if (obj) {
        return obj;
    }
    return @"";
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        WGLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    if (dic == nil) {
        return nil;
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end

@implementation NSMutableDictionary (Helper)

- (void)kSetObject:(id)obj forKey:(id)key {
    if (obj) {
        [self setObject:obj forKey:key];
    } else {
        [self setObject:@"" forKey:key];
    }
}

@end
@implementation NSArray (Helper)





+ (NSArray *)arrWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        WGLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}


+ (NSString*)arrToJson:(NSArray *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end


@implementation NSString (Helper)

/**
 *  动态计算文字的宽高（单行）
 *  @param font 文字的字体
 *  @return 计算的宽高
 */
- (CGSize)WG_sizeWithFont:(UIFont *)font
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}


- (CGSize)WG_sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}


- (CGSize)WG_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth
{
    return [self WG_sizeWithFont:font limitSize:WGCGSizeMake(limitWidth, MAXFLOAT)];
}


+ (CGFloat )widthWithString:(NSString *)string andStrFont:(UIFont *)font andMaxSize:(CGSize)size
{
   return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:0].size.width;
}

+ (CGSize )sizeWithString:(NSString *)string andStrFont:(UIFont *)font andMaxSize:(CGSize)size
{
     return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:0].size;
}
//
+ ( NSMutableAttributedString * )HTMLFromString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithData:[ string dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options:@{
                                                             NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                             }
                                                   documentAttributes:nil
                                                   error:nil];
    return attributedString;
}

@end

@implementation NSMutableString (Helper)

@end

@implementation UIView (Helper)

- (void)addLabelWithRect:(CGRect)rect
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                fontSize:(CGFloat)fontSize
                     tag:(NSInteger)tag
           textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = (UILabel *)[self viewWithTag:tag];
    if (!label) {
        label = [UILabel labelWithRect:rect
                                  text:text
                             textColor:textColor
                              fontSize:fontSize
                         textAlignment:textAlignment];
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
        label.tag = tag;
        [self addSubview:label];
    } else {
        label.frame = rect;
        label.text = text;
        label.textColor = textColor;
    }
}
-(UIView *)addHospitalViewWithRect:(CGRect)rect Dic:(NSDictionary *)dic andTag:(int )tag;
{
    
    UIView *view=[self viewWithTag:tag];
    if (!view) {
        UIView *view=[[UIView alloc]initWithFrame:rect];
        NSArray *allValus=[dic allValues];
        NSArray *allKeys=[dic allKeys];
        int k=0;
        for(int i=0;i<allValus.count;i++)
        {
            
            if ([[allValus objectAtIndex:i] intValue]>0) {
                
                [view addSubview: [self getkeyString:[allKeys objectAtIndex:i] andRect:CGRectMake(k*27, 0, 17, 17) andParentView:view]];
                k++;
            }
            
        }
        return view;
    }
    
    else
    {
        view.frame=rect;
        NSArray *allValus=[dic allValues];
        NSArray *allKeys=[dic allKeys];
        int k=0;
        [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        for(int i=0;i<allValus.count;i++)
        {
            
            if ([[allValus objectAtIndex:i] intValue]>0) {
                [view addSubview: [self getkeyString:[allKeys objectAtIndex:i] andRect:CGRectMake(k*27, 0, 17, 17) andParentView:view]];
                k++;
            }
            
        }
        return view;
        
    }
    return nil;
}

- (UIView *)getkeyString:(NSString *)string andRect:(CGRect)rect andParentView:(UIView *)parentView
{
//    if ([string isEqualToString:@"Registered"]) {
//        //挂号
//        UIView *view=[parentView viewWithTag:9000];
//        if (!view) {
//            view=[self getViewFromString:@"挂" Color:kColor_Register_Color];
//            view.tag=9000;
//            view.frame=rect;
//        }
//        else
//        {
//            view.frame=rect;
//        }
//        return view;
//        
//    }
//    else if([string isEqualToString:@"Queue"])
//    {
//        UIView *view=[parentView viewWithTag:9001];
//        if (!view) {
//            view=[self getViewFromString:@"排" Color:kColor_Queue_Color];
//            view.frame=rect;
//            view.tag=9001;
//            
//        }
//        else
//        {
//            view.frame=rect;
//            
//        }
//        return view;
//    }
//    else if([string isEqualToString:@"Account"])
//    {
//        UIView *view=[parentView viewWithTag:9003];
//        if (!view) {
//            view=[self getViewFromString:@"费" Color:kColor_Account_Color];
//            view.frame=rect;
//            view.tag=9003;
//        }
//        else
//        {
//            view.frame=rect;
//        }
//        
//        return view;
//    }
//    
//    else if([string isEqualToString:@"Assay"])
//    {
//        UIView *view=[parentView viewWithTag:9002];
//        if (!view) {
//            view=[self getViewFromString:@"化" Color:kColor_Assay_Color];
//            view.frame=rect;
//            view.tag=9002;
//        }
//        else
//        {
//            view.frame=rect;
//        }
//        
//        return view;
//    }
    return nil;
}

- (UIView *)getViewFromString:(NSString *)string Color:(UIColor *)color
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    UIView  *corView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    corView.layer.masksToBounds=YES;
    corView.layer.cornerRadius=8.5;
    corView.layer.borderColor=color.CGColor;
    corView.layer.borderWidth=8.5;
    [bgView addSubview:corView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    titleLable.center=corView.center;
    titleLable.text=string;
    titleLable.font=WGFOND(10);
    titleLable.textColor=[UIColor whiteColor];
    [bgView addSubview:titleLable];
    
    
    return bgView;
}
+ (void)cornerView:(UIView *)view andUpLeft:(UIRectCorner )upleft andUpRight:(UIRectCorner )upright andBottomLeft:(UIRectCorner )bottomleft  andBottomRight:(UIRectCorner )bottomright andSizeMake:(int) cornerlayerSize;
{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:upleft | upright|bottomleft|bottomright cornerRadii:WGCGSizeMake(cornerlayerSize, cornerlayerSize)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}



- (void)addEdgingViewWithRect:(CGRect)rect
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)width
                    viewColor:(UIColor *)viewColor
                      viewTag:(int)tag;
{
    UIView *view = [self viewWithTag:tag];
    if (!view) {
        view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = viewColor;
        view.tag = tag;
        view.layer.borderColor = borderColor.CGColor;
        view.layer.borderWidth = width;
        [self addSubview:view];
    } else {
        view.backgroundColor = viewColor;
        view.layer.borderColor = borderColor.CGColor;
        view.layer.borderWidth = width;
    }
}

+ (UIView *)getNewButtonWithImage:(UIImage *)img title:(NSString *)title clickAction:(SEL)clickAction ViewController:(id)viewController;
{
    UIView *tapView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 150, 45)];
    tapView.backgroundColor=[UIColor whiteColor];
    tapView.layer.cornerRadius=22.5;
    tapView.layer.masksToBounds=YES;
    UIImageView *lightView=[[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 30, 30)];
   // lightView.backgroundColor=kColor_Line_Color;
    lightView.layer.cornerRadius=15;
    lightView.layer.masksToBounds=YES;
    lightView.image=img;
    [tapView addSubview:lightView];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(lightView.frame.size.width+lightView.frame.origin.x+5, 5,tapView.frame.size.width-60, 35)];
    lable.text=title;
 //   lable.textColor=kColor_Main_Color;
    lable.font=WGFOND(16);
    lable.textAlignment=NSTextAlignmentCenter;
    [tapView addSubview:lable];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:viewController action:clickAction];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    tapView.userInteractionEnabled=YES;
    [tapView addGestureRecognizer:tap];
    return tapView;
}

@end

@implementation UILabel (Helper)

-(void)setLabelSpaceWithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    self.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
-(CGSize)getSpaceLabelSize:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    CGSize size = [str boundingRectWithSize:WGCGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+(UILabel *)labelWithTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.font = font;
    label.textAlignment = alignment;
    label.text = title;
    return label;
}

+(UILabel *)labelWithPoint:(CGPoint)point maxWidth:(CGFloat)maxWidth text:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)fontSize spaceLine:(BOOL)spaceLine
{
    UILabel *label = [[UILabel alloc] init];
    label.origin = point;
    label.textColor = color;
    label.font = WGFOND(fontSize);
    if (spaceLine) {
        [label setLabelSpaceWithValue:text withFont:WGFOND(fontSize)];
        label.size = [label getSpaceLabelSize:text withFont:WGFOND(fontSize) withWidth:maxWidth];
    }else
    {
        label.text = text;
        label.size = [NSString sizeWithString:text andStrFont:WGFOND(fontSize) andMaxSize:WGCGSizeMake(maxWidth, MAXFLOAT)];
    }
    label.numberOfLines = 0;
    return label;
}
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (UILabel *)labelWithRect:(CGRect)rect
                      text:(NSString *)text
                 textColor:(UIColor *)textColor
                  fontSize:(CGFloat)fontSize
             textAlignment:(NSTextAlignment)textAlignment {
    __autoreleasing UILabel *label = [[UILabel alloc] init];
    label.frame = rect;
    label.text = text;
    label.textColor = textColor;
    label.font = WGFOND(fontSize);
    label.textAlignment = textAlignment;
    label.numberOfLines = 0;
    return label;
}

+ (CGSize)sizeWithText:(NSString *)text
                  font:(UIFont *)font
               maxSize:(CGSize)maxSize {
    return [text length] > 0
    ? [text boundingRectWithSize:maxSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{
                                   NSFontAttributeName : font
                                   } context:nil].size
    : CGSizeZero;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [UILabel sizeWithText:self.text font:font maxSize:maxSize];
}


- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

+ (CGFloat)getStingWidth:(NSString *)string
{
    UILabel *lable=[UILabel new];
    lable.text=string;
    lable.font=WGFOND(12);
    CGSize size=[lable boundingRectWithSize:WGCGSizeMake(0, 24)];
    return size.width;
    
}


@end

@implementation UITextField (Helper)
+(UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                    Font:(UIFont *)font
                               TextColor:(UIColor *)textColor
                             HorderColor:(UIColor *)horderColor
                         BottomLineColor:(UIColor *)lineColor
                                  TfType:(UITextAutocorrectionType)tfType
{
    UITextField *textF = [UITextField new];
    textF.placeholder = placeholder;
    textF.font = font;
    textF.textColor = textColor;
    if (horderColor) {
        [textF setValue:horderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (lineColor) {
        [textF bottomLineforViewWithColor:[UIColor grayColor]];
    }
    textF.autocorrectionType = UITextAutocorrectionTypeNo;
    return textF;
}
+ (UITextField *)textFieldWithRect:(CGRect)rect
                              text:(NSString *)text
                       placeholder:(NSString *)placeholder
                         textColor:(UIColor *)textColor
                          fontSize:(CGFloat)fontSize
                     textAlignment:(NSTextAlignment)textAlignment {
    __autoreleasing UITextField *textField = [[UITextField alloc] init];
    textField.frame = rect;
    textField.text = text;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.font = WGFOND(fontSize);
    textField.textAlignment = textAlignment;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    return textField;
}
- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end

@implementation UIButton (Helper)
+(UIButton *)buttonWithImage:(UIImage *)image
                   highLightImg:(UIImage *)highLightImg
                     BGColor:(UIColor *)bgColor
                 clickAction:(SEL)clickAction
              viewController:(id)viewController
                cornerRadius:(CGFloat)radius
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highLightImg forState:UIControlStateHighlighted];
    if (bgColor) {
        [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    }
    if (radius) {
        btn.layer.cornerRadius =radius;
        btn.clipsToBounds =YES;
    }
    [btn addTarget:viewController action:clickAction forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+(UIButton *)buttonWithTitle:(NSString *)title
                        font:(UIFont *)font
                  TitleColor:(UIColor *)titleColor
                     BGColor:(UIColor *)bgColor
                 clickAction:(SEL)clickAction
              viewController:(id)viewController
                cornerRadius:(CGFloat)radius
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (bgColor) {
        [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    }
    if (radius) {
        btn.layer.cornerRadius =radius;
        btn.clipsToBounds =YES;
    }
    [btn addTarget:viewController action:clickAction forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
+ (UIButton *)ButtonWithRect:(CGRect)rect
                       title:(NSString *)title
                  titleColor:(UIColor *)color
    BackgroundImageWithColor:(UIColor *)imageColor
                 clickAction:(SEL)clickAction
              viewController:(id)viewController
                   titleFont:(CGFloat)font contentEdgeInsets:(UIEdgeInsets )contentEdgeInsets;
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:imageColor]
                      forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.contentEdgeInsets=contentEdgeInsets;
    button.titleLabel.font = WGFOND(font);
    if (clickAction) {
        [button addTarget:viewController
                   action:clickAction
         forControlEvents:UIControlEventTouchUpInside];
    }
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    return button;
}

+ (UIButton *)ButtonWithRect:(CGRect)rect
                       title:(NSString *)title
                  titleColor:(UIColor *)color
    BackgroundImageWithColor:(UIColor *)imageColor
                 clickAction:(SEL)clickAction
              viewController:(id)viewController
                   titleFont:(CGFloat)font contentEdgeInsets:(UIEdgeInsets )contentEdgeInsets cornerRadius:(float)radius
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:imageColor]
                      forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.contentEdgeInsets=contentEdgeInsets;
    button.titleLabel.font = WGFOND(font);
    if (clickAction) {
        [button addTarget:viewController
                   action:clickAction
         forControlEvents:UIControlEventTouchUpInside];
    }
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = radius;
    return button;
}

+ (UIButton *)ButtonWithRect:(CGRect)rect
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                 clickAction:(SEL)clickAction
                       image:(NSString *)image
              viewController:(id)viewController
                   titleFont:(CGFloat)font
             titleEdgeInsets:(UIEdgeInsets )titleEdgeInsets;
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = WGFOND(font);
    button.titleEdgeInsets=titleEdgeInsets;
    if (clickAction) {
        [button addTarget:viewController
                   action:clickAction
         forControlEvents:UIControlEventTouchUpInside];
    }
    
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 4;
    return button;
}

@end

@implementation UIImage (Helper)

+ (UIImage *)IMGCompressed:(UIImage *)o_image targetWidth:(CGFloat)width{
    
    // 如果传入的宽度比当前宽度还要大,就直接返回
    
    if (width > o_image.size.width) {
        
        return  o_image;
        
    }
    
    // 计算缩放之后的高度
    
    CGFloat height = (width / o_image.size.width) * o_image.size.height;
    
    // 初始化要画的大小
    
    CGRect  rect = CGRectMake(0, 0, width, height);
    
    // 1. 开启图形上下文
    
    UIGraphicsBeginImageContext(rect.size);
    
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    
    [o_image drawInRect:rect];
    
    // 3. 取到图片
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    
    UIGraphicsEndImageContext();
    
    // 5. 返回
    
    return image;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//剪切图片(从中心算起）
+ (UIImage *)getCutImageSize:(CGSize)size
               originalImage:(UIImage *)originalImage {
    originalImage = [self fixOrientation:originalImage];
    CGRect rect = [self getCutRectWithBigSize:originalImage.size cutSize:size];
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, cutImageRef);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(cutImageRef);
    
    return cutImage;
}

//获取截图区域(从中心算起）
+ (CGRect)getCutRectWithBigSize:(CGSize)bigSize cutSize:(CGSize)cutSize {
    CGFloat scale = [self getCompressScaleWithBigSize:bigSize smallSize:cutSize];
    CGPoint bigPoint = CGPointMake(bigSize.width / 2.0f, bigSize.height / 2.0f);
    CGSize scaleSize = WGCGSizeMake(cutSize.width / scale, cutSize.height / scale);
    CGRect Rect = CGRectMake(bigPoint.x - scaleSize.width / 2.0f,
                             bigPoint.y - scaleSize.height / 2.0f,
                             scaleSize.width, scaleSize.height);
    return Rect;
}

+(UIImage *)setNewImage:(NSString *)name
{
    UIImage * img = [UIImage imageNamed:name];
    CGFloat  w = img.size.width *0.5;
    //CGFloat  h = img.size.height *0.5;
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(0,w, 0, w)];
}
//获取压缩比scale
+ (CGFloat)getCompressScaleWithBigSize:(CGSize)bigSize
                             smallSize:(CGSize)smallSize {
    CGFloat scale;
    if (bigSize.height / bigSize.width >= smallSize.height / smallSize.width) {
        scale = smallSize.width / bigSize.width;
    } else {
        scale = smallSize.height / bigSize.height;
    }
    return scale;
}

//修改图片处理后旋转问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,
                                                   aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the
    // transform
    // calculated above.
    CGContextRef ctx =
    CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                          CGImageGetBitsPerComponent(aImage.CGImage), 0,
                          CGImageGetColorSpace(aImage.CGImage),
                          CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,
                               CGRectMake(0, 0, aImage.size.height, aImage.size.width),
                               aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,
                               CGRectMake(0, 0, aImage.size.width, aImage.size.height),
                               aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

@implementation NSDate (Helper)

+ (NSDate *)FromString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

@end

@implementation UIImageView(Helper)

+ (UIImageView *)ImageViewWithRect:(CGRect)rect imageName:(NSString *)name tag:(int )tag parentId:(id)body;
{
    UIImageView *img = (UIImageView *)[body viewWithTag:tag];
    if (!img) {
        img=[[UIImageView alloc]initWithFrame:rect];
        img.image=[UIImage imageNamed:name];
        img.tag=tag;
    }
    else
    {
        img.image=[UIImage imageNamed:name];
        img.tag=tag;
        img.frame=rect;
    }
    
    return img;
}
- (void)fillImage
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

- (void)changeCircleCornerRadius:(CGFloat )cornerRadius andborderWidth:(CGFloat)width
{
    self.layer.cornerRadius=cornerRadius;
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=width;
    self.layer.borderColor=[UIColor whiteColor].CGColor;
}



//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color image:(NSString *)image
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO,2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIImage *loadImage=[UIImage imageNamed:image];
    CGImageRef cgimage=loadImage.CGImage;
    CGContextClipToMask(context, rect,cgimage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)imageWithColor:(UIColor *)color UIImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO,2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGImageRef cgimage=image.CGImage;
    CGContextClipToMask(context, rect,cgimage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





@end

@implementation UITableView(Helper)

- (void)UIEdgeInsetsZero
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end


@implementation UITableViewCell(Helper)

- (void)setEdgeInsetsZero
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
}



@end
