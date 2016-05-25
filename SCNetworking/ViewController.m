//
//  ViewController.m
//  SCNetworking
//
//  Created by 孙程 on 16/5/25.
//  Copyright © 2016年 Suncheng. All rights reserved.
//

#import "ViewController.h"
#import "SCNetwork.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)startRequestClick:(id)sender {
    [self.activity startAnimating];
    [[SCNetwork sharedSCNetwork] requestV2withParam:@{@"id":@"280552"} completionBlock:^(NSDictionary *dic){
        
        NSError *error;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            self.textview.text = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        });
    } failureBlock:^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
        });

        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
