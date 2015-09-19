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

@implementation NotificationDispatch

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationActionHandlersDictionary = [[NSMutableDictionary alloc] init];
        localNotificationHandlersDictionary = [[NSMutableDictionary alloc] init];
    });
}

+ (void)registerForAction:(NSString *)identifier handler:(void(^)(NSDictionary *responseInfo))handler {
    @synchronized(self) {
        notificationActionHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)registerForLocalNotificationCategory:(NSString *)identifier handler:(void(^)(UILocalNotification *notification))handler {
    @synchronized(self) {
        localNotificationHandlersDictionary[identifier] = [handler copy];
    }
}

+ (void)dispatchAction:(NSString *)identifier responseInfo:(NSDictionary *)responseInfo {
    @synchronized(self) {
        void(^handler)(NSDictionary *) = notificationActionHandlersDictionary[identifier];
        if(handler) {
            handler(responseInfo);
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

@end
