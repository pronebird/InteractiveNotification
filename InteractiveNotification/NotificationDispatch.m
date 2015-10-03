//
//  NotificationDispatch.m
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "NotificationDispatch.h"

static NSMutableDictionary<NSString *, LocalNotificationActionHandler> *localNotificationActionHandlersDictionary;
static NSMutableDictionary<NSString *, RemoteNotificationActionHandler> *remoteNotificationActionHandlersDictionary;

static NSMutableDictionary<NSString *, LocalNotificationHandler> *localNotificationHandlersDictionary;
static NSMutableDictionary<NSString *, RemoteNotificationHandler> *remoteNotificationHandlersDictionary;

static LocalNotificationHandler defaultLocalNotificationHandler;
static RemoteNotificationHandler defaultRemoteNotificationHandler;

@implementation NotificationDispatch

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localNotificationActionHandlersDictionary = [[NSMutableDictionary alloc] init];
        remoteNotificationActionHandlersDictionary = [[NSMutableDictionary alloc] init];
        
        localNotificationHandlersDictionary = [[NSMutableDictionary alloc] init];
        remoteNotificationHandlersDictionary = [[NSMutableDictionary alloc] init];
    });
}

#pragma mark - Registration

+ (void)setDefaultLocalNotificationHandler:(LocalNotificationHandler)handler {
    @synchronized(self) {
        defaultLocalNotificationHandler = [handler copy];
    }
}

+ (void)setDefaultRemoteNotificationHandler:(RemoteNotificationHandler)handler {
    @synchronized(self) {
        defaultRemoteNotificationHandler = [handler copy];
    }
}

+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(LocalNotificationHandler)handler {
    @synchronized(self) {
        localNotificationHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForRemoteNotificationCategory:(NSString *)identifier handler:(RemoteNotificationHandler)handler {
    @synchronized(self) {
        remoteNotificationHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForLocalNotificationAction:(NSString *)identifier handler:(LocalNotificationActionHandler)handler {
    @synchronized(self) {
        localNotificationActionHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForRemoteNotificationAction:(NSString *)identifier handler:(RemoteNotificationActionHandler)handler {
    @synchronized(self) {
        remoteNotificationActionHandlersDictionary[identifier] = [handler copy];
    }
}

#pragma mark - Dispatch

+ (void)dispatchFromLaunchOptions:(NSDictionary *)launchOptions {
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(localNotification) {
        [self dispatchLocalNotification:localNotification];
    }
    
    if(remoteNotification) {
        [self dispatchRemoteNotification:remoteNotification];
    }
}

+ (void)dispatchLocalNotification:(UILocalNotification *)notification {
    @synchronized(self) {
        NSString *identifier = notification.category;
        
        if(identifier) {
            LocalNotificationHandler handler = localNotificationHandlersDictionary[identifier];
            
            if(handler) {
                handler(notification);
            }
        }
        else if(defaultLocalNotificationHandler) {
            defaultLocalNotificationHandler(notification);
        }
    }
}

+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo {
    return [self dispatchRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {}];
}

+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult result))completionHandler {
    @synchronized(self) {
        NSString *identifier = [userInfo valueForKeyPath:@"aps.category"];
        
        if(identifier) {
            RemoteNotificationHandler handler = remoteNotificationHandlersDictionary[identifier];
            
            if(handler) {
                return handler(userInfo, completionHandler);
            }
        }
        else if(defaultRemoteNotificationHandler) {
            return defaultRemoteNotificationHandler(userInfo, completionHandler);
        }
        
        completionHandler(UIBackgroundFetchResultFailed);
    }
}

+ (void)dispatchAction:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    @synchronized(self) {
        LocalNotificationActionHandler handler = localNotificationActionHandlersDictionary[identifier];
        
        if(handler) {
            return handler(notification, responseInfo, completionHandler);
        }
        
        completionHandler();
    }
}

+ (void)dispatchAction:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    @synchronized(self) {
        RemoteNotificationActionHandler handler = remoteNotificationActionHandlersDictionary[identifier];
        
        if(handler) {
            return handler(userInfo, responseInfo, completionHandler);
        }
        
        completionHandler();
    }
}

@end
