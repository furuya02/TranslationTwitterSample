//
//  ViewController.m
//  TranslationTwitterSample
//
//  Created by hirauchi.shinichi on 2016/02/11.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "ViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "Twitter.h"
#import "Translator.h"

@interface ViewController()<UITableViewDataSource,UITableViewDelegate,TwitterDelegate,TranslatorDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Translator *translator;

@property Twitter *twitter;


@end

@implementation ViewController


// 翻訳作業中のtweetのインデックス
NSIndexPath *convert_in_index = nil;

- (void)viewDidLoad {
    [super viewDidLoad];

    // 翻訳クラス
    _translator = [[Translator alloc] init];
    _translator.delegate = self;

     // Twitterクラス
    _twitter = [[Twitter alloc] init];
    _twitter.delegate = self;

    // 検索
    [_twitter timeline];
}


// 検索結果取得完了
- (void) didFinishLoad {
    [self.tableView reloadData];
}

// 翻訳完了
- (void)didFinishConversion:(NSString *)message {
    if (convert_in_index != nil){
        Tweet *tweet = [_twitter.tweets objectAtIndex: convert_in_index.row];
        tweet.text = message;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:convert_in_index] withRowAnimation:YES];
        convert_in_index = nil;
    }
}

// 更新ボタン
- (IBAction)tapRefreshButton:(id)sender {
    [_twitter timeline];
}

// 検索ボタン
- (IBAction)tapSearchButton:(id)sender {
//    NSString *message = @"A swift-flying insectivorous bird with long, slender wings and a superficial resemblance to a swallow, spending most of its life on the wing.Family Apodidae: several genera and numerous species, in particular the common Eurasian swift (Apus apus)";
//
//    [_translator conversion:message];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _twitter.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Tweet *tweet = [_twitter.tweets objectAtIndex:indexPath.row];
    [cell refeshhWithTweet:tweet];
    return cell;
}

// Tweet.textの文字数でセルの高さを調整する
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [_twitter.tweets objectAtIndex:indexPath.row];
    float height = (float)tweet.text.length / 50.0;
    return height * 12 + 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //UITableViewRowAction の backgroundColor プロパティでカスタマイズできる。

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                       title:@"翻訳"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         Tweet *tweet = [_twitter.tweets objectAtIndex:indexPath.row];
                                         [_translator conversion:tweet.text];
                                         convert_in_index = indexPath;
                                     }];
    action.backgroundColor = [UIColor colorWithRed:0 green:0.2 blue:0 alpha:1];
    return @[action];

//    return @[
//             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
//                                                title:@"翻訳"
//                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//                                                  Tweet *tweet = [_twitter.tweets objectAtIndex:indexPath.row];
//                                                  [_translator conversion:tweet.text];
//                                                  convert_in_index = indexPath;
//                                              }],
//             ];
}


@end
