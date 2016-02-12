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
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        // アクセストークン取得
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
    return self;
}

- (void)conversion:(NSString*)message {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    // JSONでパースしない
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // Authorizationヘッダの追加
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    // ％文字への変換
    NSString* encodeString = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *url = [NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/Http.svc/Translate?text=%@&to=ja",encodeString];
    [manager GET:url
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //NSData から NSString　への変換
          NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          // XMLをパース
          NSCharacterSet *spr = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
          NSArray *array = [str componentsSeparatedByCharactersInSet:spr];
          if(array.count == 5){
              [self.delegate didFinishConversion:[array objectAtIndex:2]];
          }else{
              [self.delegate didFinishConversion:@"ERROR"];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self.delegate didFinishConversion:[NSString stringWithFormat:@"ERROR: %@",error]];
      }];
}




@end
