//
//  NotificationDispatch.h
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LocalNotificationHandler)(UILocalNotification *notification);
typedef void(^RemoteNotificationHandler)(NSDictionary *userInfo, void(^completionHanlder)(UIBackgroundFetchResult result));

typedef void(^LocalNotificationActionHandler)(UILocalNotification *notification, NSDictionary *responseInfo, void (^completionHandler)());
typedef void(^RemoteNotificationActionHandler)(NSDictionary *userInfo, NSDictionary *responseInfo, void (^completionHandler)());

@interface NotificationDispatch : NSObject

/**
 *  Set a handler for local notification without category set.
 *
 *  @param handler
 */
+ (void)setDefaultLocalNotificationHandler:(LocalNotificationHandler)handler;

/**
 *  Set a handler for remote notification without category set.
 *
 *  @param handler
 */
+ (void)setDefaultRemoteNotificationHandler:(RemoteNotificationHandler)handler;

/**
 *  Register a handler for local notification.
 *  Dispatch happens based on notification category.
 *
 *  @param identifier UIUserNotificationCategory identifier
 *  @param handler
 */
+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(LocalNotificationHandler)handler;

/**
 *  Register a handler for remote notification.
 *  Dispatch happens based on notification category.
 *
 *  @param identifier UIUserNotificationCategory identifier
 *  @param handler
 */
+ (void)registerForRemoteNotificationCategory:(NSString *)identifier handler:(RemoteNotificationHandler)handler;

/**
 *  Register for local notification action.
 *  Dispatch happens based on notification action identifier.
 *
 *  @param identifier UIUserNotificationAction identifier
 *  @param handler
 */
+ (void)registerForLocalNotificationAction:(NSString *)identifier handler:(LocalNotificationActionHandler)handler;


/**
 *  Register for remote notification action.
 *  Dispatch happens based on notification action identifier.
 *
 *  @param identifier UIUserNotificationAction identifier
 *  @param handler
 */
+ (void)registerForRemoteNotificationAction:(NSString *)identifier handler:(RemoteNotificationActionHandler)handler;

/**
 *  Dispatch notifications carried along with launch options.
 *  Use this method from -application:didFinishLaunchingWithOptions: to dispatch pending notifications.
 *
 *  @param launchOptions launch options dictionary passed along to application delegate
 */
+ (void)dispatchFromLaunchOptions:(NSDictionary *)launchOptions;

/**
 *  Dispatch local notification.
 *  Call this method from -application:didReceiveLocalNotification:
 *
 *  @param notification
 */
+ (void)dispatchLocalNotification:(UILocalNotification *)notification;

/**
 *  Dispatch remote notification.
 *  Call this method from -application:didReceiveRemoteNotification:.
 *  Essentially, this method calls -dispatchRemoteNotification:fetchCompletionHandler: with dummy fetchCompletionHandler.
 *
 *  @param userInfo a remote notification payload
 */
+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo;

/**
 *  Dispatch remote notification.
 *  Call this method from -application:didReceiveRemoteNotification:fetchCompletionHandler:.
 *
 *  @param userInfo          a remote notification payload
 *  @param completionHandler a completion handler you should call upon completion (see apple docs)
 */
+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult result))completionHandler;

/**
 *  Dispatch action for remote notification.
 *  Call this method from -application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:
 *
 *  @param identifier
 *  @param userInfo
 *  @param responseInfo
 *  @param completionHandler
 */
+ (void)dispatchAction:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler;

/**
 *  Dispatch action for remote notification.
 *  Call this method from -application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:
 *
 *  @param identifier
 *  @param userInfo
 *  @param responseInfo
 *  @param completionHandler
 */
+ (void)dispatchAction:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler;

@end
