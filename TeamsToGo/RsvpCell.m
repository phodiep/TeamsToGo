//
//  RsvpCell.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/31/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RsvpCell.h"
#import "Fonts.h"

@implementation RsvpCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.label = [[UILabel alloc] init];
        [self.label setTranslatesAutoresizingMaskIntoConstraints:false];
        self.label.font = [[Fonts alloc] textFont];
        self.label.numberOfLines = 0;
        
        self.typeLabel = [[UILabel alloc] init];
        [self.typeLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        self.typeLabel.font = [[Fonts alloc] textFont];
        
        self.comments = [[UILabel alloc] init];
        [self.comments setTranslatesAutoresizingMaskIntoConstraints:false];
        self.comments.numberOfLines = 0;
        self.comments.font = [[Fonts alloc] textFont];
        
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.comments];
        
        NSDictionary *views = @{@"label" : self.label,
                                @"type" : self.typeLabel,
                                @"comment" : self.comments};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]-8-[comment]-8-|" options:0 metrics:0 views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[label]-(>=8)-[type]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[comment]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];

    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
