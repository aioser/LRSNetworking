//
//  LRSViewController.m
//  LRSNetworking
//
//  Created by 刘sama on 10/12/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import "LRSViewController.h"
#import "LRSSecurityNetworkingClient.h"

@import SDWebImage;
@import SDWebImageWebPCoder;

@interface LRSViewController ()

@end

@implementation LRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];

	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)securuty:(id)sender {
    [[[LRSSecurityNetworkingClient instance] login] subscribeNext:^(LRSLoginResponseModel * _Nullable x) {
        NSLog(@"security === %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}

- (IBAction)system:(id)sender {

}

- (IBAction)user:(id)sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
