//
//  FSUpdateMe.h
//  FSUpdateMe
//
//  Created by Felipe Saint-Jean on 2/5/14.
//  Copyright (c) 2014 bContext. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSUpdateMe : NSObject

@property (nonatomic,assign) BOOL show_in_simulator;

- (void)updateMeEnterprise:(NSString *)string_url updateURL:(NSString *)update completion:(void (^)(UIAlertController *))completion;
-(void)updateMeAppStore:(NSString *)app_id;
+ (FSUpdateMe *)sharedInstance;

@end
