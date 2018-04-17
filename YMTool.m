//
//  YMTool.m
//  YEMA
//
//  Created by YZ-PC on 2018/3/16.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "YMTool.h"
#import "SSKeychain.h"
#import<CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation YMTool
//获取根URl
+(NSString *)getBaseURL{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"BaseUrl"];
}

//获取UUID
+(NSString *)getUUID{
    NSString *uuidStr = [SSKeychain passwordForService:@"com.carlt.chelepai" account:@"user"];
    if (!uuidStr || [uuidStr isEqualToString:@""])
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuidStr = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault ,uuidRef);
        [SSKeychain setPassword:[NSString stringWithFormat:@"%@", uuidStr] forService:@"com.carlt.chelepai" account:@"user"];
    }
    return uuidStr;
    
}

+(NSString *)stringWithMD5:(NSString *)str{
    
    // Create pointer to the string as UTF8
    const char *ptr = [str UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
    
}
//获取version
+(NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (appVersion && appVersion.length > 0) {
        return [appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    
    return @"100";
}

//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
    }
    return NO;
}

/**
 *  车乐拍WIFI是否连接
 */
+ (BOOL)isCLPWifiConnected {
    if (/*[[self getCurrentWifiSSID] hasPrefix:@"A3-"]*/[[self getCurrentWifiSSID] hasPrefix:@"Domy-DVR-"]) {
        return YES;
    }
    return NO;
}

/**
 *  获取当前WIFI名称
 */
+ (NSString *)getCurrentWifiSSID
{
    NSString *ssid = @"";
    CFArrayRef ifs = CNCopySupportedInterfaces();
    if (ifs != nil)
    {
        CFDictionaryRef dic = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(ifs, 0));
        if (dic != nil)
        {
            NSDictionary *info = (__bridge_transfer NSDictionary*)dic;
            ssid = [info objectForKey:(__bridge_transfer NSString*)kCNNetworkInfoKeySSID];
        }
    }
    return ssid;
}

+ (NSString *)getCurrentWifiBSSID {
    NSString *bssid = @"";
    CFArrayRef ifs = CNCopySupportedInterfaces();
    
    if (ifs != nil) {
        CFDictionaryRef dic = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(ifs, 0));
        if (dic != nil) {
            NSDictionary *info = (__bridge_transfer NSDictionary*)dic;
            bssid = info[@"BSSID"];
        }
    }
    
    return bssid;
}

//保存字符串到NSUserDefault
+(void)setStringWithNSUserDefaults:(NSString *)str key:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:str forKey:key];
    [ud synchronize];
}

/**
 * 字母、数字正则判断
 */
+ (BOOL)isNumeralOrLetter:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"[a-zA-Z\u4e00-\u9fa5]|[a-zA-Z0-9\u4e00-\u9fa5]+";//^[a-zA-Z0-9\u4e00-\u9fa5]*$  //@"^[\a-zA-Z\u4E00-\u9FA5\\d]*$"  @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
//验证字符串是否为中文
+(BOOL)validateIsChineseText:(NSString *)targetString{
    
    NSString *regex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:targetString];
}
//添加textfield内左边距离8px
+(void)addUITextFieldLeftDistance:(UITextField *)textField{
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
 
    textField.leftViewMode = UITextFieldViewModeAlways;
}
//设置textfieldPlaceholderText颜色
+(void)setPlaceholderTextColor:(UITextField *)textField{
    [textField setValue:HexColor(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
}
// 获取当前时间
+(NSString *)getNowDateString{
    NSString *timeString = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];
    timeString = [formatter stringFromDate:date];
    
    return timeString;
}
+ (NSString *)getCacheSize {
    NSString *cacheSizeString = @"0 B";
    NSInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    if (cacheSize < 1024) {
        cacheSizeString = [NSString stringWithFormat:@"%ld B",cacheSize];
    } else if (cacheSize >= 1024 && cacheSize < 1024 * 1024) {
        cacheSizeString = [NSString stringWithFormat:@"%.2f KB",(CGFloat)cacheSize/1024];
    } else if (cacheSize >= 1024 * 1024 && cacheSize < 1024 * 1024 * 1024){
        cacheSizeString = [NSString stringWithFormat:@"%.2f MB",(CGFloat)cacheSize/1024/1024];
    } else {
        cacheSizeString = [NSString stringWithFormat:@"%.2f MB",(CGFloat)cacheSize/1024/1024/1024];
    }
    return cacheSizeString;
}

+(void)deleteCache{
    
    
    // 获取Library文件夹路径
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    // 获取Library下Caches文件夹路径
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    // 实例化NSFileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取Caches文件夹下的所有文件及文件夹
    NSArray *array = [fileManager contentsOfDirectoryAtPath:cachePath error:nil];
    // 循环删除Caches下的所有文件及文件夹
    for (NSString *fileName in array) {
        [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName] error:nil];
    }
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+(int)getImageW{
    if (SCREEN_WIDTH == 320) {
        return 45;
    }else if(SCREEN_WIDTH == 375){
        return 49;
    }else{
        return 54;
    }
    
}
@end
