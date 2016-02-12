//
//  TweetCell.m
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/12.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//
    
#import "TweetCell.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation TweetCell



- (void) refeshhWithTweet:(Tweet *)tweet {

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tweet.profile_image_url]];
    _iconImage.image = [UIImage imageWithData:data];
    _nameLabel.text = tweet.name;
    //_createAtLabel.text = tweet.created_at;
    _createAtLabel.text = [NSString stringWithFormat:@"%l",tweet.tweetId];
    _bodyLabel.text = tweet.text;
}

@end
