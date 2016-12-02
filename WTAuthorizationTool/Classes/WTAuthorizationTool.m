//
//  WTAuthorizationTool.m
//  WTAuthorizationTool
//
//  Created by wentianen on 16/7/28.
//  Copyright © 2016年. All rights reserved.
//

#import "WTAuthorizationTool.h"

@import AssetsLibrary;
@import Photos;
@import AddressBook;
@import Contacts;

@implementation WTAuthorizationTool

#pragma mark - 相册
+ (void)requestImagePickerAuthorization:(void(^)(WTAuthorizationStatus status))callback {
    // check 是否支持相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            switch (authStatus) {
                case ALAuthorizationStatusNotDetermined: { // 未授权
                        // iOS7 没有相应的代码
                        [self executeCallback:callback status:WTAuthorizationStatusAuthorized]; // 代码
                }
                    break;
                case ALAuthorizationStatusAuthorized:
                    [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    break;
                case ALAuthorizationStatusDenied:
                    [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    break;
                case ALAuthorizationStatusRestricted:
                    [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                    break;
            }
        } else {
            switch ([PHPhotoLibrary authorizationStatus]) {
                case PHAuthorizationStatusDenied:
                    [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    break;
                case PHAuthorizationStatusAuthorized:
                    [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    break;
                case PHAuthorizationStatusRestricted:
                    [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                    break;
                case PHAuthorizationStatusNotDetermined: {
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        if (status == PHAuthorizationStatusAuthorized) {
                            [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                        } else if (status == PHAuthorizationStatusDenied) {
                            [self executeCallback:callback status:WTAuthorizationStatusDenied];
                        } else if (status == PHAuthorizationStatusRestricted) {
                            [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                        }
                    }];
                }
                    break;
            }
        }
    } else {
        [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
    }
}

#pragma mark - 相机
// iOS7之前都可以访问相机，iOS7之后访问相机有权限设置
+ (void)requestCameraAuthorization:(void (^)(WTAuthorizationStatus))callback {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    } else {
                        [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    }
                }];
            }
                break;
            case AVAuthorizationStatusDenied:
                [self executeCallback:callback status:WTAuthorizationStatusDenied];
                break;
            case AVAuthorizationStatusAuthorized:
                [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                break;
            case AVAuthorizationStatusRestricted:
                [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                break;
        }
    } else {
        [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
    }
}

#pragma mark - 通讯录
+ (void)requestAddressBookAuthorization:(void (^)(WTAuthorizationStatus))callback {
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        switch (ABAddressBookGetAuthorizationStatus()) {
            case kABAuthorizationStatusDenied:
                [self executeCallback:callback status:WTAuthorizationStatusDenied];
                break;
            case kABAuthorizationStatusAuthorized:
                [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                break;
            case kABAuthorizationStatusRestricted:
                [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                break;
            case kABAuthorizationStatusNotDetermined: {
                __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                if (addressBook == NULL) {
                    [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
                    return;
                }
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted) {
                        [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    } else {
                        [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    }
                    if (addressBook) {
                        CFRelease(addressBook);
                        addressBook = NULL;
                    }
                });
            }
                break;
        }
    } else {
        CNAuthorizationStatus authorization = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authorization) {
            case CNAuthorizationStatusDenied:
                [self executeCallback:callback status:WTAuthorizationStatusDenied];
                break;
            case CNAuthorizationStatusAuthorized:
                [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                break;
            case CNAuthorizationStatusRestricted:
                [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                break;
            case CNAuthorizationStatusNotDetermined: {
                CNContactStore * store = [[CNContactStore alloc] init];
                if (store) {
                    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted) {
                            [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                        } else {
                            [self executeCallback:callback status:WTAuthorizationStatusDenied];
                        }
                    }];
                } else {
                    [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
                }
            }
                break;
        }
    }
}

#pragma mark - callback
+ (void)executeCallback:(void (^)(WTAuthorizationStatus))callback status:(WTAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

@end
