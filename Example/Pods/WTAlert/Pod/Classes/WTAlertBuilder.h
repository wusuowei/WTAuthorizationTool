//
//  WTAlertBuilder.h
//  Pods
//
//  Created by 无所谓 on 16/4/11.
//
//

#import <Foundation/Foundation.h>

typedef void(^WTAlertActionBlock)();

@interface WTAlertBuilder : NSObject

/**
 *  ios8 以上从这个控制器modal出alertController
 *
 *  不能为空
 */
@property (nonatomic, weak, nullable) UIViewController *viewController;
/**
 *  alert标题
 */
@property (nonatomic, copy) NSString * _Nullable title;
/**
 *  alert文本内容
 */
@property (nonatomic, copy) NSString * _Nullable message;
/**
 *  取消按钮标题
 */
@property (nonatomic, copy) NSString * _Nullable cancelTitle;
/**
 *  取消动作处理
 */
@property (nonatomic, copy) WTAlertActionBlock _Nullable cancelBlock;
/**
 *  确认按钮标题
 */
@property (nonatomic, copy) NSString * _Nullable confirmTitle;
/**
 *  确认动作处理
 */
@property (nonatomic, copy) WTAlertActionBlock _Nullable confirmBlock;

@end
