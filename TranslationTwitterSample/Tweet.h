//
//  Tweet.h
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/11.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tweet : NSObject

@property NSString *name;//表示名
@property NSString *text;//メッセージ
@property NSString *screen_name;//アカウント名
@property NSString *created_at;//作成日時
@property NSString *icon;//アイコン
@property NSString *profile_image_url;//アイコン
@property long tweetId;//Id

@end