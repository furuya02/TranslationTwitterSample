//
//  Twitter.m
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/11.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "Twitter.h"

@interface Twitter()

@property ACAccount *acaccount;


@end




@implementation Twitter


- (id)init {

    self = [super init];
    if (self != nil) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountTypeTwitter
                                              options:nil
                                           completion:^(BOOL granted, NSError *error) {
                                               if (granted) {
                                                   NSArray *accountArray = [accountStore accountsWithAccountType:accountTypeTwitter];
                                                   if (accountArray.count > 0) {
                                                       _acaccount = [accountArray objectAtIndex:0];
                                                   }
                                               }
                                           }];

        _tweets = [NSMutableArray array];
    }
    return self;
}


- (void) seach:(NSString *)word {

    while (_acaccount == nil ){
        NSLog(@"account = nil waiting...");
        [NSThread sleepForTimeInterval:0.5];
    }

    [_tweets removeAllObjects];
    [self.delegate didFinishLoad];

    // 検索
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"count" : @"100",
                             @"q":word};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    // アカウントをセット
    request.account = _acaccount;

    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
         if (data) {
             if (response.statusCode >= 200 &&
                 response.statusCode < 300) {

                 // JSONデータのデコード
                 NSError *error;
                 NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:&error];
                 NSArray *tweets = [result objectForKey:@"statuses"];
                 for (NSDictionary *t in tweets) {
                     Tweet *tweet = [Tweet alloc];
                     tweet.created_at = [t objectForKey:@"created_at"];
                     tweet.text = [t objectForKey:@"text"];
                     tweet.tweetId = [t objectForKey:@"id"];
                     NSDictionary *user = [t objectForKey:@"user"];
                     tweet.profile_image_url = [user objectForKey:@"profile_image_url"];
                     tweet.name = [user objectForKey:@"name"];
                     tweet.screen_name = [user objectForKey:@"screen_name"];
                     [_tweets addObject:tweet];
                 }

                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.delegate didFinishLoad];
                 });

             } else {
                 NSLog(@"statusCode %ld",(long)response.statusCode);
             }
         }
     }];
}




@end