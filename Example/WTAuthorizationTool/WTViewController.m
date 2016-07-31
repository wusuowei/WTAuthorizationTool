//
//  WTViewController.m
//  WTAuthorizationTool
//
//  Created by wentianen on 07/28/2016.
//  Copyright (c) 2016 wentianen. All rights reserved.
//

#import "WTViewController.h"
#import "WTAuthorizationTool.h"
#import "WTAlert.h"

@interface WTViewController ()

@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self requestAddressBook];
}

- (void)requestAddressBook {
    [WTAuthorizationTool requestAddressBookAuthorization:^(WTAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}

- (void)requestCamera {
    [WTAuthorizationTool requestCameraAuthorization:^(WTAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}

- (void)requestAuthCallback:(WTAuthorizationStatus)status {
    switch (status) {
        case WTAuthorizationStatusAuthorized:
            [WTAlert showAlertFrom:self title:@"授权成功" message:@"可以访问你要访问的内容了" cancelButtonTitle:@"我知道了" cancle:^{
                
            } confirmButtonTitle:nil confirm:nil];
            break;
            
        case WTAuthorizationStatusDenied:
        case WTAuthorizationStatusRestricted:
            [WTAlert showAlertFrom:self title:@"授权失败" message:@"用户拒绝" cancelButtonTitle:@"我知道了" cancle:^{
                
            } confirmButtonTitle:@"现在设置" confirm:^{
                NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                    [[UIApplication sharedApplication] openURL:settingUrl];
                }
            }];
            break;
            
        case WTAuthorizationStatusNotSupport:
            [WTAlert showAlertFrom:self title:@"授权失败" message:@"设备不支持" cancelButtonTitle:@"我知道了" cancle:^{
                
            } confirmButtonTitle:nil confirm:nil];
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
