//
//  NotificationDispatch.m
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "NotificationDispatch.h"

static NSMutableDictionary *notificationActionHandlersDictionary;
static NSMutableDictionary *localNotificationHandlersDictionary;
static NSMutableDictionary *remoteNotificationHandlersDictionary;

@implementation NotificationDispatch

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationActionHandlersDictionary = [[NSMutableDictionary alloc] init];
        localNotificationHandlersDictionary = [[NSMutableDictionary alloc] init];
        remoteNotificationHandlersDictionary = [[NSMutableDictionary alloc] init];
    });
}

+ (void)registerForAction:(NSString *)identifier handler:(void(^)(NSDictionary *userInfo, NSDictionary *responseInfo, void (^completionHandler)()))handler {
    @synchronized(self) {
        notificationActionHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(void(^)(UILocalNotification *notification))handler {
    @synchronized(self) {
        localNotificationHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForRemoteNotificationCategory:(NSString *)identifier handler:(void(^)(NSDictionary *userInfo, void(^completionHandler)(UIBackgroundFetchResult result)))handler {
    @synchronized(self) {
        remoteNotificationHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)dispatchAction:(NSString *)identifier userInfo:(NSDictionary *)userInfo responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    @synchronized(self) {
        void(^handler)(NSDictionary *, NSDictionary *, void (^completionHandler)()) = notificationActionHandlersDictionary[identifier];
        
        if(handler) {
            handler(userInfo, responseInfo, completionHandler);
        }
        else {
            completionHandler();
        }
    }
}

+ (void)dispatchLocalNotification:(UILocalNotification *)notification {
    @synchronized(self) {
        NSString *identifier = notification.category;
        
        if(identifier) {
            void(^handler)(UILocalNotification *) = localNotificationHandlersDictionary[identifier];
            
            if(handler) {
                handler(notification);
            }
        }
    }
}

+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo {
    @synchronized(self) {
        void(^completionHandler)() = ^() {};
        
        NSString *identifier = [userInfo valueForKeyPath:@"aps.category"];
        
        if(identifier) {
            void(^handler)(NSDictionary *, void(^)()) = remoteNotificationHandlersDictionary[identifier];
            
            if(handler) {
                handler(userInfo, completionHandler);
            }
        }
    }
}

+ (void)dispatchRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult result))completionHandler {
    @synchronized(self) {
        NSString *identifier = [userInfo valueForKeyPath:@"aps.category"];
        
        if(identifier) {
            void(^handler)(NSDictionary *, void(^)()) = remoteNotificationHandlersDictionary[identifier];
            
            if(handler) {
                handler(userInfo, completionHandler);
            }
            
            return;
        }
        
        completionHandler(UIBackgroundFetchResultFailed);
    }
}

@end
