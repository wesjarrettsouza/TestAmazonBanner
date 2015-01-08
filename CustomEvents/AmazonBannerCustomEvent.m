//
//  AmazonBannerCustomEvent.h
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//


#import "AmazonBannerCustomEvent.h"
#import "MPLogging.h"

#import <AmazonAd/AmazonAdRegistration.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdError.h>


@interface AmazonBannerCustomEvent ()

@property (nonatomic, strong) AmazonAdView *amazonAdView;

@end


@implementation AmazonBannerCustomEvent

- (void)dealloc
{
    self.amazonAdView.delegate = nil;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting Amazon banner");
    // Set your application ID
    [[AmazonAdRegistration sharedRegistration] setAppKey
     :[info objectForKey:@"network_id"]];


    self.amazonAdView = [AmazonAdView amazonAdViewWithAdSize:size];
    AmazonAdOptions *adOptions = [AmazonAdOptions options];
    
    // IMPORTANT - During development you should always set this flag to true.
    // Test traffic that doesn’t include this flag can result in blocked requests, fraud investigation, and potential account termination.
    adOptions.isTestRequest = ([[info objectForKey:@"test_mode"] intValue] == 1);
    self.amazonAdView.delegate = self;
    [self.amazonAdView loadAd:adOptions];
}

// #pragma mark AmazonAdViewDelegate
- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adViewWillExpand:(AmazonAdView *)view
{
    NSLog(@"Amazon will present modal view for an ad. Its time to pause other activities.");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)adViewDidCollapse:(AmazonAdView *)view
{
    NSLog(@"Amazon modal view has been dismissed, its time to resume the paused activities.");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)adViewDidLoad:(AmazonAdView *)view
{
    NSLog(@"Amazon successfully loaded an ad");
    [self.delegate bannerCustomEvent:self didLoadAd:self.amazonAdView];
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error
{
    NSLog(@"Amazon failed to load an ad %d %@", error.errorCode, error.errorDescription);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

@end
