//
//  WTAuthorizationTool.h
//  WTAuthorizationTool
//
//  Created by wentianen on 16/7/28.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WTAuthorizationStatus) {
    WTAuthorizationStatusAuthorized = 0,    // 已授权
    WTAuthorizationStatusDenied,            // 拒绝
    WTAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    WTAuthorizationStatusNotSupport         // 硬件等不支持
};




/**
 全部采用类方法，不会因为此处代码带来循环引用
 */
@interface WTAuthorizationTool : NSObject

/**
 *  请求相册访问权限
 *
 *  @param callback 授权回调
 */
+ (void)requestImagePickerAuthorization:(void(^)(WTAuthorizationStatus status))callback;

/**
 *  请求相机权限
 *
 *  @param callback 授权回调
 */
+ (void)requestCameraAuthorization:(void(^)(WTAuthorizationStatus status))callback;

+ (void)requestAddressBookAuthorization:(void (^)(WTAuthorizationStatus))callback;

@end
