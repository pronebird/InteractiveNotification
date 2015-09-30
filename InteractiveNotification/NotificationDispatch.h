//
//  NotificationDispatch.h
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDispatch : NSObject

+ (void)registerForAction:(NSString *)identifier handler:(void(^)(NSDictionary *userInfo, NSDictionary *responseInfo, void (^completionHandler)()))handler;
+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(void(^)(UILocalNotification *notification))handler;
+ (void)registerForRemoteNotificationCategory:(NSString *)identifier handler:(void(^)(NSDictionary *userInfo, void(^completionHanlder)(UIBackgroundFetchResult result)))handler;

+ (void)dispatchAction:(NSString *)identifier userInfo:(NSDictionary *)userInfo responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler;

+ (void)dispatchLocalNotification:(UILocalNotification *)notification;

+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo;
+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult result))completionHandler;

@end
