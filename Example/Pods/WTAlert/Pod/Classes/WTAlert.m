//
//  WTAlert.m
//  Pods
//
//  Created by 无所谓 on 16/4/11.
//
//

#import "WTAlert.h"

typedef void(^WTAlertClickActionBlock)(NSInteger);
static NSMutableArray <WTAlertClickActionBlock> *_clickActionBlocks;

@implementation WTAlert

+ (void)initialize {
    [super initialize];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clickActionBlocks = [NSMutableArray array];
    });
}

+ (void)showAlertWithBuilder:(void (^)(WTAlertBuilder * _Nonnull))builderBlock {
    NSParameterAssert(builderBlock);
    
    WTAlertBuilder *builder = [[WTAlertBuilder alloc] init];
    builderBlock(builder);
    [self showAlertFrom:builder.viewController title:builder.title message:builder.message cancelButtonTitle:builder.cancelTitle cancle:builder.cancelBlock confirmButtonTitle:builder.confirmTitle confirm:builder.confirmBlock];
}

+ (void)showAlertFrom:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancle:(WTAlertActionBlock)cancle confirmButtonTitle:(NSString *)confirmButtonTitle confirm:(WTAlertActionBlock)confirm {
    
    NSParameterAssert(viewController);
    NSAssert(cancelButtonTitle.length != 0 || confirmButtonTitle.length != 0, @"cancel和conform不能同时为空");

    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:(title.length > 0 ? title : @"") message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (cancle) {
                    cancle();
                }
            }];
            [alertController addAction:cancelAction];
        }
        
        if (confirmButtonTitle && confirmButtonTitle.length > 0) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (confirm) {
                    confirm();
                }
            }];
            [alertController addAction:otherAction];
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        WTAlertClickActionBlock callbackBlock = ^(NSInteger buttonIndex){
            if (buttonIndex == 0) {
                if (cancelButtonTitle.length > 0) {
                    if (cancle != nil) {
                        cancle();
                    }
                } else if (confirmButtonTitle.length > 0) {
                    if (confirm != nil) {
                        confirm();
                    }
                }
            } else {
                if (confirm) {
                    confirm();
                }
            }
        };
        [_clickActionBlocks addObject:callbackBlock];
        UIAlertView *titleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
        [titleAlert show];
    }
}

#pragma mark - UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickActionBlocks.lastObject) {
        _clickActionBlocks.lastObject(buttonIndex);
        [_clickActionBlocks removeLastObject];
    }
}

@end
