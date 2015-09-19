//
//  AppDelegate.m
//  InteractiveNotification
//
//  Created by pronebird on 7/26/15.
//  Copyright (c) 2015 pronebird. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationDispatch.h"
#import "NotificationDispatch+Actions.h"

@implementation AppDelegate

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"Registered user notification settings = %@", notificationSettings);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIUserNotificationCategory *incomingMessageCategory = [NotificationDispatch categoryForIncomingMessageNotification];
    
    NSSet *categories = [NSSet setWithObject:incomingMessageCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings;
    settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Local notification = %@", notification);
    
    [NotificationDispatch dispatchLocalNotification:notification];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"Handle local notification = %@. Action Identifier = %@. Response = %@", notification, identifier, responseInfo);
    
    [NotificationDispatch dispatchAction:identifier responseInfo:responseInfo];
    
    completionHandler();
}

@end
