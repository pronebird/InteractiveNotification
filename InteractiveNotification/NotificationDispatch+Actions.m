//
//  NotificationDispatch+Actions.m
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "NotificationDispatch+Actions.h"

NSString * const NotificationCategoryIdent  = @"IncomingMessage";
NSString * const NotificationActionReplyIdent = @"Reply";
NSString * const NotificationActionIgnoreIndent = @"Ignore";

@implementation NotificationDispatch (Actions)

+ (UIUserNotificationCategory *)categoryForIncomingMessageNotification {
    UIMutableUserNotificationAction *replyAction;
    UIMutableUserNotificationAction *ignoreAction;
    UIMutableUserNotificationCategory *actionCategory;
    
    replyAction = [[UIMutableUserNotificationAction alloc] init];
    replyAction.activationMode = UIUserNotificationActivationModeForeground;
    replyAction.title = @"Reply";
    replyAction.identifier = NotificationActionReplyIdent;
    replyAction.destructive = NO;
    replyAction.authenticationRequired = NO;
    replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
    replyAction.parameters = @{ UIUserNotificationTextInputActionButtonTitleKey: @"Reply" };
    
    ignoreAction = [[UIMutableUserNotificationAction alloc] init];
    ignoreAction.activationMode = UIUserNotificationActivationModeBackground;
    ignoreAction.title = @"Ignore";
    ignoreAction.identifier = NotificationActionIgnoreIndent;
    ignoreAction.destructive = NO;
    ignoreAction.authenticationRequired = NO;
    
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory.identifier = NotificationCategoryIdent;
    [actionCategory setActions:@[ ignoreAction, replyAction ] forContext:UIUserNotificationActionContextDefault];
    
    return actionCategory;
}

@end
