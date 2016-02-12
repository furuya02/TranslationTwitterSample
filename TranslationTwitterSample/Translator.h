//
//  Translator.h
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/12.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TranslatorDelegate;

@interface Translator : NSObject

@property (nonatomic,weak) id <TranslatorDelegate> delegate;
// 翻訳の実行
- (void)conversion:(NSString*)message;

@end

@protocol TranslatorDelegate <NSObject>

- (void)didFinishConversion:(NSString *)message;

@end


