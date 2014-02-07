//
//  DetailViewController.h
//  StoreSearch
//
//  Created by Zhang Honghao on 2/6/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

typedef enum {
    DetailViewControllerAnimationTypeSlide,
    DetailViewControllerAnimationTypeFade
} DetailViewControllerAnimationType;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) SearchResult *searchResult;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType;

@end
