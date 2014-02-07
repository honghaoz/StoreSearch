//
//  DetailViewController.m
//  StoreSearch
//
//  Created by Zhang Honghao on 2/6/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchResult.h"
#import "UIImage+StackBlur.h"
#import "UIImageView+AFNetworking.h"
#import "GradientView.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *kindLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *storeButton;

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *blurBackground;

- (IBAction)close:(id)sender;
- (IBAction)openInStore:(id)sender;

@end

@implementation DetailViewController {
    GradientView *gradientView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.backgroundView.layer.borderWidth = 3.0f;
    self.backgroundView.layer.cornerRadius = 10.0f;
//    self.backgroundView.opaque = NO;
//    self.backgroundView.alpha = 0.5;
//    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
//    UIImage *backgroundImage = [UIImage imageNamed:@"asd.jpg"];
//    
//    self.blurBackground.image = backgroundImage;
//    self.blurBackground.image = [backgroundImage stackBlur:30.0f];
    
    //[self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    
    self.nameLabel.text = self.searchResult.name;
    
    NSString *artistName = self.searchResult.artistName;
    if (artistName == nil) {
        artistName = @"Unknown";
    }
    
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = [self.searchResult kindForDisplay];
    self.genreLabel.text = self.searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:self.searchResult.currency];
    self.priceLabel.text = [formatter stringFromNumber:self.searchResult.price];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"DetailPlaceholder"]];
    
}

//-(BOOL)shouldAutorotate{
//    return YES;
//}
//
//-(NSInteger)supportedInterfaceOrientations{
//    NSInteger orientationMask = 0;
//    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
//        orientationMask |= UIInterfaceOrientationMaskLandscapeLeft;
//    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
//        orientationMask |= UIInterfaceOrientationMaskLandscapeRight;
//    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
//        orientationMask |= UIInterfaceOrientationMaskPortrait;
//    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
//        orientationMask |= UIInterfaceOrientationMaskPortraitUpsideDown;
//    return orientationMask;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissFromParentViewControllerWithAnimationType:DetailViewControllerAnimationTypeSlide];
}

- (void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType {
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        if (animationType == DetailViewControllerAnimationTypeSlide) {
            CGRect rect = self.view.bounds;
            rect.origin.y += rect.size.height;
            self.view.frame = rect;
        } else {
            self.view.alpha = 0.0f;
        }
        gradientView.alpha = 0.0f;
    }
     completion:^(BOOL finished) {
         [self.view removeFromSuperview];
         [gradientView removeFromSuperview];
         [self removeFromParentViewController];
     }];
}

- (void)presentInParentViewController:(UIViewController *)parentViewController{
    gradientView = [[GradientView alloc] initWithFrame:parentViewController.view.bounds];
    [parentViewController.view addSubview:gradientView];
    
    self.view.frame = parentViewController.view.bounds;
    [self layoutForInterfaceOritation:parentViewController.interfaceOrientation];
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
//    bounceAnimation.values = [NSArray arrayWithObjects:
//                              [NSNumber numberWithFloat:0.7f],
//                              [NSNumber numberWithFloat:1.2f],
//                              [NSNumber numberWithFloat:0.9f],
//                              [NSNumber numberWithFloat:1.0f],
//                              nil];
    bounceAnimation.values = @[@0.7f, @1.2f, @0.9f, @1.0f];
    
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.334f],
                                [NSNumber numberWithFloat:0.666f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
    
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       nil];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.duration = 0.1;
    [gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    
//
//    
//    [self didMoveToParentViewController:parentViewController];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
    [self.artworkImageView cancelImageRequestOperation];
}

- (IBAction)openInStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutForInterfaceOritation:toInterfaceOrientation];
}

- (void)layoutForInterfaceOritation:(UIInterfaceOrientation)interfaceOrientation {
    CGRect rect = self.closeButton.frame;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        rect.origin = CGPointMake(28, 60);
    } else {
        rect.origin = CGPointMake(108, 7);
    }
    self.closeButton.frame = rect;
}
@end
