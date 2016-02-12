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

@interface ViewController()<UITableViewDataSource,UITableViewDelegate,TwitterDelegate,TranslatorDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Translator *translator;
@property Twitter *twitter;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

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
    [_twitter seach:@"ios swift"];

    // 検索ビュー
    self.searchView.hidden = true;
    self.searchBar.delegate = self;
}


// 検索結果取得完了（Twitterクラスのデリゲート）
- (void) didFinishLoad {
    [self.tableView reloadData];
}

// 翻訳完了（翻訳クラスのデリゲート）
- (void)didFinishConversion:(NSString *)message {
    if (convert_in_index != nil){
        Tweet *tweet = [_twitter.tweets objectAtIndex: convert_in_index.row];
        tweet.text = message;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:convert_in_index] withRowAnimation:YES];
        convert_in_index = nil;
    }
}

// 検索ボタン
- (IBAction)tapSearchButton:(id)sender {
    // 検索ビュー表示
    self.searchView.hidden = false;
    [self.view endEditing: NO];
}

// 検索開始
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [_twitter seach:self.searchBar.text];
    self.searchView.hidden = true;
    [self.view endEditing: YES];
}

// tableViewのデリゲート（必須）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _twitter.tweets.count;
}

// tableViewのデリゲート（必須）
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


// tableViewのセルをスワイプした時のメニューの編集のため必要
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}


// tableViewのセルをスワイプした際の処理
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                       title:@"翻訳"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         Tweet *tweet = [_twitter.tweets objectAtIndex:indexPath.row];
                                         //非同期で、翻訳クラスに翻訳を依頼する
                                         [_translator conversion:tweet.text];
                                         convert_in_index = indexPath;
                                     }];
    action.backgroundColor = [UIColor colorWithRed:0 green:0.2 blue:0 alpha:1];
    return @[action];
}


@end
