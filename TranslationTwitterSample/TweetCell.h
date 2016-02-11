//
//  TweetCell.h
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/12.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

- (void) refeshhWithTweet:(Tweet *)tweet;

@end
