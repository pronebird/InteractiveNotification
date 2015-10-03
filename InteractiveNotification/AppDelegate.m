//
//  AppDelegate.m
//  InteractiveNotification
//
//  Created by pronebird on 7/26/15.
//  Copyright (c) 2015 pronebird. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "NotificationDispatch.h"
#import "NotificationDispatch+Actions.h"

@implementation AppDelegate

- (ViewController *)rootViewController {
    return (ViewController *)self.window.rootViewController;
}

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
    
    [NotificationDispatch registerForLocalNotificationAction:NotificationActionReplyIdent handler:^(UILocalNotification *notification, NSDictionary *responseInfo, void (^completionHandler)()) {
        NSString *message = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        
        [self.rootViewController showReplyAlertWithMessage:message completion:completionHandler];
    }];
    
    [NotificationDispatch registerForLocalNotificationCategory:NotificationCategoryIdent handler:^(UILocalNotification *notification) {
        [self.rootViewController showReplyPromptForNotification:notification];
    }];
    
    // we must do this to make sure that our root view controller
    // is on screen and ready to present alert controllers from dispatch
    [self.window makeKeyAndVisible];
    
    // dispatch notifications when opening app from push notification
    [NotificationDispatch dispatchFromLaunchOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Local notification = %@", notification);
    
    [NotificationDispatch dispatchLocalNotification:notification];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"Handle local notification = %@. Action Identifier = %@. Response = %@", notification, identifier, responseInfo);
    
    [NotificationDispatch dispatchAction:identifier
                    forLocalNotification:notification
                            responseInfo:responseInfo
                       completionHandler:completionHandler];
}

@end
