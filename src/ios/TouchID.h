//
//  TouchID.h
//  Copyright (c) 2014 Simon Smith - http://www.hestor.com
//

#import <Cordova/CDVPlugin.h>

@interface TouchID : CDVPlugin

- (void) authenticate:(CDVInvokedUrlCommand*)command;

- (void) checkSupport:(CDVInvokedUrlCommand*)command;

@end
