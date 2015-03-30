//
//  RosterCell.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RosterCell.h"

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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name]-8-[emailIcon(15)]-8-[phoneIcon(15)]-8-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[email]-8-[phone]" options:0 metrics:0 views:self.views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-(>=8)-[type]-8-|" options:NSLayoutFormatAlignAllTop metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[emailIcon(15)]-8-[email]-(>=8)-|" options:NSLayoutFormatAlignAllTop metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[phoneIcon(15)]-8-[phone]-(>=8)-|" options:NSLayoutFormatAlignAllTop metrics:0 views:self.views]];

}

-(void)initAllObjects {
    self.views = [[NSMutableDictionary alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPhone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhonePressed)];
    [self.phoneLabel addGestureRecognizer:tapPhone];
    
    self.phoneIcon = [[UIImageView alloc] init];
    self.phoneIcon.image = [UIImage imageNamed:@"phone"];
    self.phoneIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPhoneIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhonePressed)];
    [self.phoneIcon addGestureRecognizer:tapPhoneIcon];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEmail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmailPressed)];
    [self.emailLabel addGestureRecognizer:tapEmail];
    
    self.emailIcon = [[UIImageView alloc] init];
    self.emailIcon.image = [UIImage imageNamed:@"mail"];
    self.emailIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEmailIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmailPressed)];
    [self.emailIcon addGestureRecognizer:tapEmailIcon];
    
    self.typeLabel = [[UILabel alloc] init];
}

-(void)tapPhonePressed {
    NSLog(@"calling ... %@", self.phoneLabel.text);
}

-(void)tapEmailPressed {
    NSLog(@"emailing ... %@", self.emailLabel.text);
}

-(void)prepAllForAutoLayout {
    [self prepObjectForAutolayout:self.nameLabel addToSubview:self.contentView addToDictionary:@"name"];
    [self prepObjectForAutolayout:self.phoneLabel addToSubview:self.contentView addToDictionary:@"phone"];
    [self prepObjectForAutolayout:self.phoneIcon addToSubview:self.contentView addToDictionary:@"phoneIcon"];
    [self prepObjectForAutolayout:self.emailLabel addToSubview:self.contentView addToDictionary:@"email"];
    [self prepObjectForAutolayout:self.emailIcon addToSubview:self.contentView addToDictionary:@"emailIcon"];
    [self prepObjectForAutolayout:self.typeLabel addToSubview:self.contentView addToDictionary:@"type"];
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