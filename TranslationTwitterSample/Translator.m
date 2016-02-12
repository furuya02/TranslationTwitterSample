//
//  Translator.m
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/12.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "Translator.h"
#import "AFNetworking.h"
#import "Secret.h"

@interface Translator()

@end

@implementation Translator
    NSString *token = nil;

- (id)init {

    self = [super init];
    if (self != nil) {
        if (token == nil) {
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"client_id" : clientId,
                                    @"client_secret" : clientSecret,
                                    @"scope" : @"http://api.microsofttranslator.com",
                                    @"grant_type" : @"client_credentials"};
            [manager POST:@"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
               parameters:param success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                   token = [responseObject objectForKey:@"access_token"];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
               }];
        }
    }
    return self;
}



@end
