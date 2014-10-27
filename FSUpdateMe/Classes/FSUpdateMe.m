//
//  FSUpdateMe.m
//  FSUpdateMe
//
//  Created by Felipe Saint-Jean on 2/5/14.
//  Copyright (c) 2014 bContext. All rights reserved.
//

#import "FSUpdateMe.h"
#import <AFNetworking/AFNetworking.h>

@interface FSUpdateMe () <UIAlertViewDelegate>

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
-(void)updateMeEnterprise:(NSString *)string_url updateURL:(NSString *)update;
{
#if TARGET_IPHONE_SIMULATOR
    // No need to bother the developers with dumb questions.
    if (![FSUpdateMe sharedInstance].show_in_simulator)
        return;
#endif
    
    NSURL *URL = [NSURL URLWithString:string_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    [FSUpdateMe sharedInstance].update_url = update;
    operation.responseSerializer = [AFPropertyListResponseSerializer serializer];
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    //[AFPropertyListRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/xml"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([FSUpdateMe needsUpdateFrom:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] to:responseObject[@"items"][0][@"metadata"][@"bundle-version"]]){
            
            
            
            NSString *app_name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"There is a new version of %@",app_name]
                                                              message:@"by updating you will get new features and error fixes."
                                                             delegate:[FSUpdateMe sharedInstance]
                                                    cancelButtonTitle:@"Not now"
                                                    otherButtonTitles:@"Update", nil];
            [message show];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%s %d %@",__FILE__,__LINE__, error);
    }];
    [operation start];
    
}
-(void)updateMeAppStore:(NSString *)app_id;
{
// TODO implement this
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (buttonIndex){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.update_url]];
    }
    
}


@end
