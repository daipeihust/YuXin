//
//  UIViewController+MailComposer.h
//  PopU
//
//  Created by zhao wei on 13-11-14.
//  Copyright (c) 2013年 Pinssible. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface UIViewController (MailComposer) <MFMailComposeViewControllerDelegate>

- (void)sendContactMessageWithSubject:(NSString*)subject;

@end
