//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by Zhang Honghao on 2/5/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import "UIImageView+AFNetworking.h"

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    UIImage *image = [UIImage imageNamed:@"TableCellGradient"];
//    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:image];
//    self.backgroundView = backgroundImageView;
//    
//    UIImage *selectedImage = [UIImage imageNamed:@"SelectedTableCellGradient"];
//    UIImageView *selectedBackgroundImageView = [[UIImageView alloc]initWithImage:selectedImage];
//    self.selectedBackgroundView = selectedBackgroundImageView;
}

- (void)configureForSearchResult:(SearchResult *)searchResult {
    self.nameLabel.text = searchResult.name;
    NSString *artistName = searchResult.artistName;
    if (artistName == nil){
        artistName = @"Unknown";
    }
    NSString *kind = [searchResult kindForDisplay];
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistName, kind];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.artworkImageView cancelImageRequestOperation];
    self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
}

@end
