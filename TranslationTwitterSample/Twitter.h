//
//  Twitter.h
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/11.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Tweet.h"

@protocol TwitterDelegate;

@interface Twitter : NSObject

@property (nonatomic) NSMutableArray *tweets;

@property (nonatomic,weak) id <TwitterDelegate> delegate;
- (void) timeline;

@end


@protocol TwitterDelegate <NSObject>

- (void) didFinishLoad;

@end

