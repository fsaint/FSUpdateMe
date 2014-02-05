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
-(void)updateMeEnterprise:(NSString *)url updateURL:(NSString *)update;
-(void)updateMeAppStore:(NSString *)app_id;
+ (FSUpdateMe *)sharedInstance;
@end
