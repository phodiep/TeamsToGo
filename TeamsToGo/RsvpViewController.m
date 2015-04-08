//
//  RsvpViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RsvpViewController.h"
#import "EditRsvpCell.h"
#import "Fonts.h"

@interface RsvpViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *status;
@property (nonatomic) NSInteger addlMale;
@property (nonatomic) NSInteger addlFemale;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *rsvpAsUserId;




@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveRsvpButton;
@property (strong, nonatomic) UIButton *removeRsvpButton;

@end

@implementation RsvpViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.tableView = [[UITableView alloc] init];
    
    self.saveRsvpButton = [[UIButton alloc] init];
    [self.saveRsvpButton setTitle:@"Save RSVP" forState:UIControlStateNormal];
    [self.saveRsvpButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.removeRsvpButton = [[UIButton alloc] init];
    [self.removeRsvpButton setTitle:@"Remover RSVP" forState:UIControlStateNormal];
    [self.removeRsvpButton addTarget:self action:@selector(removeButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.saveRsvpButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.removeRsvpButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:self.saveRsvpButton];
    [self.rootView addSubview:self.removeRsvpButton];
    
    NSDictionary *views = @{@"tableView" : self.tableView,
                            @"save" : self.saveRsvpButton,
                            @"remove" : self.removeRsvpButton};

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[tableView]|" options:0 metrics:0 views:views]];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:views]];
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:EditRsvpCell.class forCellReuseIdentifier:@"RSVP_CELL"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    switch (indexPath.row) {
        case 0: //status cell
            cell = [self statusCell];
            break;
        case 1: //male cell
            cell = [self addlMaleCell];
            break;
        case 2: //female cell
            cell = [self addFemaleCell];
            break;
        case 3:
            cell = [self commentCell];
            break;
        case 4:
            cell.backgroundColor = [UIColor lightGrayColor];
            break;
        case 5:
            cell = [self saveCell];
            break;
        case 6:
            cell = [self removeCell];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self statusCellSelected];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        default:
            break;
    }
}

#pragma mark - Cell types
-(EditRsvpCell*)statusCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Status";
    label.font = [[Fonts alloc] titleFont];

    UILabel *selectedStatus = [[UILabel alloc] init];
    selectedStatus.textAlignment = NSTextAlignmentRight;
    if ([self.status isEqualToString:@""] || self.status == nil) {
        selectedStatus.text = @"select status";
        selectedStatus.textColor = [UIColor lightGrayColor];
    
    } else {
        selectedStatus.text = self.status;
        selectedStatus.textColor = [UIColor blackColor];
    }

    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    [selectedStatus setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:selectedStatus];
    
    NSDictionary *views = @{@"label" : label,
                            @"status" : selectedStatus
                            };

    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-(>=8)-[status]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];

    
    
    return cell;
}

-(EditRsvpCell*)addlMaleCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+ Male";
    label.font = [[Fonts alloc] titleFont];
    
    UIStepper* stepper = [[UIStepper alloc] init];

    [stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview: stepper];
    
    NSDictionary *views = @{@"label" : label,
                            @"stepper" : stepper,
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-(>=8)-[stepper]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];

    
    return cell;
    
}

-(EditRsvpCell*)addFemaleCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+ Female";
    label.font = [[Fonts alloc] titleFont];
    
    UIStepper* stepper = [[UIStepper alloc] init];
    
    [stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview: stepper];
    
    NSDictionary *views = @{@"label" : label,
                            @"stepper" : stepper,
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-(>=8)-[stepper]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];

    
    return cell;
    
}

-(EditRsvpCell*)commentCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Comment";
    label.font = [[Fonts alloc] titleFont];
    
    
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    
    NSDictionary *views = @{@"label" : label
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:0 views:views]];

    
    return cell;
    
}

-(EditRsvpCell*)saveCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    cell.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Save RSVP";
    label.font = [[Fonts alloc] titleFont];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    
    NSDictionary *views = @{@"label" : label
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:0 views:views]];

    
    return cell;
    
}

-(EditRsvpCell*)removeCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    cell.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Remove RSVP";
    label.font = [[Fonts alloc] titleFont];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    
    NSDictionary *views = @{@"label" : label
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:0 views:views]];

    
    return cell;
    
}

#pragma mark - Cell Actions
-(void)statusCellSelected {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select status" delegate:self
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:self.event.rsvpStatusDisplayYes, self.event.rsvpStatusDisplayMaybe, self.event.rsvpStatusDisplayAvailable, self.event.rsvpStatusDisplayNo, nil];
    
    [actionSheet setTag: 0];
    
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (actionSheet.tag) {
        case 0: //Status cell
            
            switch (buttonIndex) {
                case 0:
                    self.status = self.event.rsvpStatusDisplayYes;
                    break;
                case 1:
                    self.status = self.event.rsvpStatusDisplayMaybe;
                    break;
                case 2:
                    self.status = self.event.rsvpStatusDisplayAvailable;
                    break;
                case 3:
                    self.status = self.event.rsvpStatusDisplayNo;
                    break;
                    
                default:
                    break;
            }
            
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Button Actions
-(void)saveButtonPressed {
    NSLog(@"save");
}

-(void)removeButtonPressed {
    NSLog(@"remove");
}
@end
