//
//  LandscapeViewController.m
//  StoreSearch
//
//  Created by Zhang Honghao on 2/6/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "LandscapeViewController.h"
#import "SearchResult.h"
#import "AFImageCache.h"
#import "DetailViewController.h"

@interface LandscapeViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

- (IBAction)pageChanged:(UIPageControl *)sender;

@end

@implementation LandscapeViewController {
    NSOperationQueue *imageRequestOperationQueue;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    return self;
}

- (void)downloadImageForSearchResult:(SearchResult *)searchResult andPlaceOnButton:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:searchResult.artworkURL100];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setHTTPShouldUsePipelining:YES];
    
    UIImage *cachedImage = [[AFImageCache sharedImageCache] cachedImageForURL:[urlRequest URL] cacheName:nil];
    if (cachedImage != nil) {
        [button setImage:cachedImage forState:UIControlStateNormal];
    } else {
        
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [button setImage:responseObject forState:UIControlStateNormal];
            [[AFImageCache sharedImageCache] cacheImageData:operation.responseData forURL:[urlRequest URL] cacheName:nil];
        } failure:nil];
        
        [imageRequestOperationQueue addOperation:requestOperation];
    }
}

- (void)tileButtons
{
    const CGFloat itemWidth = 96.0f;
    const CGFloat itemHeight = 88.0f;
    const CGFloat buttonWidth = 82.0f;
    const CGFloat buttonHeight = 82.0f;
    const CGFloat marginHorz = (itemWidth - buttonWidth)/2.0f;
    const CGFloat marginVert = (itemHeight - buttonHeight)/2.0f;
    
    int index = 0;
    int row = 0;
    int column = 0;
    
    for (SearchResult *searchResult in self.searchResults) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(column*itemWidth + marginHorz, row*itemHeight + marginVert, buttonWidth, buttonHeight);
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton"] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
		[self downloadImageForSearchResult:searchResult andPlaceOnButton:button];
        
        button.tag = 2000 + index;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        index++;
        row++;
        if (row == 3) {
            row = 0;
            column++;
        }
    }
    
    int numPages = ceilf([self.searchResults count] / 15.0f);
    self.scrollView.contentSize = CGSizeMake(numPages*480.0f, self.scrollView.bounds.size.height);
    
    NSLog(@"Number of pages: %d", numPages);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
}

- (void)buttonPressed:(UIButton *)sender {
    DetailViewController *controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    SearchResult *searchResult = [self.searchResults objectAtIndex:sender.tag - 2000];
    controller.searchResult = searchResult;
    [controller presentInParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
    
    [self tileButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width/2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

- (IBAction)pageChanged:(UIPageControl *)sender{
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * sender.currentPage, 0);
                     }
                     completion:nil];
}

- (void)dealloc {
    [imageRequestOperationQueue cancelAllOperations];
}

@end
