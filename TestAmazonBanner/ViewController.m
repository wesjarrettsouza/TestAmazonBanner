//
//  ViewController.m
//  TestAmazonBanner
//
//  Created by Wes Souza on 1/7/15.
//  Copyright (c) 2015 Wes Souza. All rights reserved.
//

#import "ViewController.h"
#import "MPAdView.h"

NSString *const IdleBannerTitle = @"Load Banner";
NSString *const LoadingBannerTitle = @"Loading Banner";
NSString *const DisplayingBannerTitle = @"Hide Banner";

NSString *const AmazonTestBanner = @"e54bd4b1dabc41d389dca23ddb5bd5a0";
const float AmazonBannerWidth = 320;
const float AmazonBannerHeight = 50;

typedef enum {
    TestAmazonBannerStateIdle,
    TestAmazonBannerStateLoading,
    TestAmazonBannerStateDisplaying
} TestAmazonBannerState;

@interface ViewController () <MPAdViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loadOrHideButton;
@property (nonatomic) TestAmazonBannerState state;
@property (nonatomic) MPAdView *amazonBannerView;

- (void)loadAmazonBanner;
- (void)showAmazonBanner;
- (void)hideAndDestroyAmazonBanner;

- (void)changeStateTo:(TestAmazonBannerState)state;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.state = TestAmazonBannerStateIdle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadOrHideButtonPressed:(id)sender {
    switch (self.state) {
        case TestAmazonBannerStateIdle:
            [self changeStateTo:TestAmazonBannerStateLoading];
            break;
            
        case TestAmazonBannerStateDisplaying:
            [self changeStateTo:TestAmazonBannerStateIdle];
            break;
            
        case TestAmazonBannerStateLoading:
            break;
    }
}

#pragma mark State Management

- (void)changeStateTo:(TestAmazonBannerState)state
{
    switch (state) {
        case TestAmazonBannerStateIdle:
        {
            self.state = TestAmazonBannerStateIdle;

            [self hideAndDestroyAmazonBanner];

            self.loadOrHideButton.enabled = YES;
            [self.loadOrHideButton setTitle:IdleBannerTitle forState:UIControlStateNormal];
            break;
        }
            
        case TestAmazonBannerStateLoading:
        {
            self.state = TestAmazonBannerStateLoading;
            
            [self loadAmazonBanner];

            self.loadOrHideButton.enabled = NO;
            [self.loadOrHideButton setTitle:LoadingBannerTitle forState:UIControlStateNormal];
            break;
        }
            
        case TestAmazonBannerStateDisplaying:
        {
            self.state = TestAmazonBannerStateDisplaying;

            [self showAmazonBanner];

            self.loadOrHideButton.enabled = YES;
            [self.loadOrHideButton setTitle:DisplayingBannerTitle forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark Banner Management

- (void)loadAmazonBanner
{
    self.amazonBannerView = [[MPAdView alloc] initWithAdUnitId:AmazonTestBanner size:CGSizeMake(AmazonBannerWidth, AmazonBannerHeight)];
    self.amazonBannerView.delegate = self;
    
    // Ignoring Autorefresh works fine
    // [self.amazonBannerView setIgnoresAutorefresh:YES];
    
    // We want the banner to appear centered at 1/4 of device height and 1/2 of device width
    CGFloat bannerCenterX = ([[UIScreen mainScreen] bounds].size.width - AmazonBannerWidth)/2;
    CGFloat bannerCenterY = ([[UIScreen mainScreen] bounds].size.height/2 - AmazonBannerHeight)/2;
    self.amazonBannerView.frame = CGRectMake(bannerCenterX, bannerCenterY, AmazonBannerWidth, AmazonBannerHeight);
    [self.amazonBannerView loadAd];
}

- (void)showAmazonBanner
{
    self.amazonBannerView.hidden = NO;
    [self.view addSubview:self.amazonBannerView];
}

- (void)hideAndDestroyAmazonBanner
{
    self.amazonBannerView.hidden = YES;
    [self.amazonBannerView removeFromSuperview];
    self.amazonBannerView.delegate = nil;
    self.amazonBannerView = nil;
}


#pragma mark MoPub Delegate Methods

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"adViewDidLoadAd");
    if (self.state != TestAmazonBannerStateDisplaying)
        [self changeStateTo:TestAmazonBannerStateDisplaying];
}


- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"adViewDidFailToLoadAd");
    [self changeStateTo:TestAmazonBannerStateIdle];
}


- (void)willPresentModalViewForAd:(MPAdView *)view
{
    NSLog(@"willPresentModalViewForAd");
}


- (void)didDismissModalViewForAd:(MPAdView *)view
{
    NSLog(@"didDismissModalViewForAd");

}


- (void)willLeaveApplicationFromAd:(MPAdView *)view
{
    NSLog(@"willLeaveApplicationFromAd");
}

@end
