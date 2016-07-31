//
//  WTAlert.h
//  Pods
//
//  Created by 无所谓 on 16/4/11.
//
//

#import <Foundation/Foundation.h>
#import "WTAlertBuilder.h"

@interface WTAlert : NSObject

+ (void)showAlertWithBuilder:(nonnull void(^)(WTAlertBuilder * _Nonnull builder))builderBlock;

+ (void)showAlertFrom:(nonnull UIViewController *)viewController title:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancle:(nullable WTAlertActionBlock)cancle confirmButtonTitle:(nullable NSString *)confirmButtonTitle confirm:(nullable WTAlertActionBlock)confirm;

@end
