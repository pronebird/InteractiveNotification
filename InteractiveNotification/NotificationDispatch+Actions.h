//
//  NotificationDispatch+Actions.h
//  InteractiveNotification
//
//  Created by pronebird on 9/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "NotificationDispatch.h"

extern NSString * const NotificationCategoryIdent;
extern NSString * const NotificationActionReplyIdent;
extern NSString * const NotificationActionIgnoreIndent;

@interface NotificationDispatch (Actions)

+ (UIUserNotificationCategory *)categoryForIncomingMessageNotification;

@end
