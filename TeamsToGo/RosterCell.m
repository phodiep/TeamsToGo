//
//  RosterCell.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RosterCell.h"
#import "Fonts.h"

@interface RosterCell ()

@property (strong, nonatomic) NSMutableDictionary *views;

@end

@implementation RosterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initAllObjects];
        [self prepAllForAutoLayout];

        [self applyAutoLayout];
    }
    
    return self;
}

-(void)applyAutoLayout {
    if (![self.emailLabel.text isEqualToString:@""] && ![self.phoneLabel.text isEqualToString:@""]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name]-8-[email]-8-[phone]-8-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailIcon(15)]" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[phoneIcon(15)]" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-(>=8)-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[emailIcon(15)]-8-[email]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[phoneIcon(15)]-8-[phone]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
        
    } else if ([self.emailLabel.text isEqualToString:@""] && [self.phoneLabel.text isEqualToString:@""]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name]-8-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-(>=8)-|" options:0 metrics:0 views:self.views]];
    
    } else if ([self.emailLabel.text isEqualToString:@""]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name]-8-[phone]-8-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[phoneIcon(15)]" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-(>=8)-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[phoneIcon(15)]-8-[phone]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
        
    } else if ([self.phoneLabel.text isEqualToString:@""]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name]-8-[email]-8-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailIcon(15)]" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-(>=8)-|" options:0 metrics:0 views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[emailIcon(15)]-8-[email]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    }
}

-(void)removeAutoLayout {
    [self.contentView removeConstraints:[self.contentView constraints]];
}


-(void)initAllObjects {
    self.views = [[NSMutableDictionary alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [[Fonts alloc] textFont];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = [[Fonts alloc] textFont];
    
    self.phoneIcon = [[UIImageView alloc] init];
    self.phoneIcon.image = [UIImage imageNamed:@"phone"];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.font = [[Fonts alloc] textFont];
    
    self.emailIcon = [[UIImageView alloc] init];
    self.emailIcon.image = [UIImage imageNamed:@"mail"];
    
}

-(void)prepAllForAutoLayout {
    [self prepObjectForAutolayout:self.nameLabel addToSubview:self.contentView addToDictionary:@"name"];
    [self prepObjectForAutolayout:self.phoneLabel addToSubview:self.contentView addToDictionary:@"phone"];
    [self prepObjectForAutolayout:self.phoneIcon addToSubview:self.contentView addToDictionary:@"phoneIcon"];
    [self prepObjectForAutolayout:self.emailLabel addToSubview:self.contentView addToDictionary:@"email"];
    [self prepObjectForAutolayout:self.emailIcon addToSubview:self.contentView addToDictionary:@"emailIcon"];
}

-(void)prepObjectForAutolayout:(id)object addToSubview:(UIView*)view addToDictionary:(NSString*)reference {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
