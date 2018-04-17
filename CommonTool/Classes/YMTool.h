//
//  YMTool.h
//  YEMA
//
//  Created by YZ-PC on 2018/3/16.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "BaseObject.h"

@interface YMTool : BaseObject
//添加textfield内左边距离8px
+(void)addUITextFieldLeftDistance:(UITextField *)textField;
//设置textfieldPlaceholderText颜色
+(void)setPlaceholderTextColor:(UITextField *)textField;
//获取根URl
+(NSString *)getBaseURL;
//获取UUID
+(NSString *)getUUID;
//MD5加密
+(NSString *)stringWithMD5:(NSString *)str;
//获取version
+(NSString *)getVersion;
//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string;
/**车乐拍WIFI是否连接*/
+ (BOOL)isCLPWifiConnected;
/**获取当前WIFI ESSID*/
+ (NSString *)getCurrentWifiSSID;
/**获取连接的wifi*/
+ (NSString *)getCurrentWifiBSSID;

//保存字符串到NSUserDefault
+(void)setStringWithNSUserDefaults:(NSString *)str key:(NSString *)key;


/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str;

+(BOOL)validateIsChineseText:(NSString *)targetString;
/**
 * 字母、数字正则判断
 */
+ (BOOL)isNumeralOrLetter:(NSString *)str;
+(NSString *)getNowDateString;
/**获取缓存大小*/
+ (NSString *)getCacheSize;
/**  清楚缓存*/
+(void)deleteCache;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+(int)getImageW;
@end
