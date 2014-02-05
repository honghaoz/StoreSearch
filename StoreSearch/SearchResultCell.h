//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Zhang Honghao on 2/5/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

@end
