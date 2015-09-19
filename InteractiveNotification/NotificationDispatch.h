//
//  NotificationDispatch.h
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDispatch : NSObject

+ (void)registerForAction:(NSString *)identifier handler:(void(^)(NSDictionary *responseInfo))handler;
+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(void(^)(UILocalNotification *notification))handler;

+ (void)dispatchAction:(NSString *)identifier responseInfo:(NSDictionary *)responseInfo;
+ (void)dispatchLocalNotification:(UILocalNotification *)notification;

@end
