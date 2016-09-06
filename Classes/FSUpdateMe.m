//
//  FSUpdateMe.m
//  FSUpdateMe
//
//  Created by Felipe Saint-Jean on 2/5/14.
//  Copyright (c) 2014 bContext. All rights reserved.
//

#import "FSUpdateMe.h"
#import <AFNetworking/AFNetworking.h>

@interface FSUpdateMe ()

@property (nonatomic,strong) NSString *update_url;

@end

@implementation FSUpdateMe

static FSUpdateMe *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (FSUpdateMe *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.show_in_simulator = NO;
    }
    return sharedInstance;
}
+(BOOL)needsUpdateFrom:(NSString *)current_version to:(NSString *)update_version{
    
    
    // Gonna try to do an smarter update
    return ([current_version compare:update_version] == NSOrderedAscending);
   
}

-(void)updateMeEnterprise:(NSString *)string_url updateURL:(NSString *)update completion:(void (^)(UIAlertController *))completion;
{
#if TARGET_IPHONE_SIMULATOR
    // No need to bother the developers with dumb questions.
    if (![FSUpdateMe sharedInstance].show_in_simulator)
        return;
#endif
    
    if (!completion) return;
    
    NSURL *URL = [NSURL URLWithString:string_url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [FSUpdateMe sharedInstance].update_url = update;
    manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([FSUpdateMe needsUpdateFrom:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                                     to:responseObject[@"items"][0][@"metadata"][@"bundle-version"]]) {
            
            NSString *app_name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            
            UIAlertController *message = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"There is a new version of %@",app_name]
                                                                             message:@"by updating you will get new features and error fixes."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            [message addAction:[UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:nil]];
            [message addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.update_url]];
            }]];
            completion(message);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s %d %@",__FILE__,__LINE__, error);
    }];
}

-(void)updateMeAppStore:(NSString *)app_id;
{
// TODO implement this
}

@end
