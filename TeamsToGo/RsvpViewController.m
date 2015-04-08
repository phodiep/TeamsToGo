//
//  RsvpViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RsvpViewController.h"
#import "TeamCowboyService.h"
#import "EditRsvpCell.h"
#import "Fonts.h"
#import "HeaderView.h"
#import "TeamCowboyClient.h"

@interface RsvpViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Rsvp *rsvp;

@property (strong, nonatomic) NSString *status;
@property (nonatomic) NSUInteger addlMale;
@property (nonatomic) NSUInteger addlFemale;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *rsvpAsUserId;




@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) HeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *headerTableViewConstraint;
@property (nonatomic) BOOL headerOverlapIsMaxed;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSDictionary *views;

@end

@implementation RsvpViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.tableView = [[UITableView alloc] init];
    
    self.headerView = [[HeaderView alloc] init];
    self.headerView.event = self.event;
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];


    [self.headerView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];

    [self.rootView addSubview:self.headerView];
    [self.rootView addSubview:self.tableView];
    [self.headerView addSubview:self.backButton];
    
    self.views = @{@"header" : self.headerView,
                   @"tableView" : self.tableView,
                   @"back" : self.backButton};

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]" options:0 metrics:0 views:self.views]];
    
    self.headerOverlapIsMaxed = false;
    [self setHeaderOverlap:0];
    
    [self.headerView setupObjectsForAutolayout];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:0 views:self.views]];
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[back(25)]" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(25)]" options:0 metrics:0 views:self.views]];

    
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headerView setHeaderValues];
    
    self.rsvp = [[TeamCowboyService sharedService] fetchRsvpForUserId:self.userId forEvent:self.event];
    
    if (self.rsvp != nil) {
        if (self.rsvp.status == Yes) {
            self.status = self.event.rsvpStatusDisplayYes;
        }
        if (self.rsvp.status == Maybe) {
            self.status = self.event.rsvpStatusDisplayMaybe;
        }
        if (self.rsvp.status == Available) {
            self.status = self.event.rsvpStatusDisplayAvailable;
        }
        if (self.rsvp.status == No) {
            self.status = self.event.rsvpStatusDisplayNo;
        }
        self.addlFemale = [self.rsvp.addlFemale integerValue];
        self.addlMale = [self.rsvp.addlMale integerValue];
        self.comments = self.rsvp.comments;
    }
    
    [self.tableView reloadData];
}

-(void)setHeaderOverlap:(double)spacing {
    
    if (self.headerOverlapIsMaxed && spacing >= self.headerView.subHeaderView.frame.size.height) {
        return;
    }
    
    //TODO: refactor for case: spacing (-) and header at max view... constraints would not need to be reset!
    
    self.headerOverlapIsMaxed = spacing >= self.headerView.subHeaderView.frame.size.height;
    double constrainedValue = MAX(spacing, 0);
    constrainedValue = MIN(constrainedValue, self.headerView.subHeaderView.frame.size.height);
    
    
    [self.rootView removeConstraints:self.headerTableViewConstraint];
    NSDictionary *metrics = @{@"space" : [NSNumber numberWithDouble:-constrainedValue] };
    self.headerTableViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[header]-(space)-[tableView]|" options:0 metrics:metrics views:self.views];
    [self.rootView addConstraints:self.headerTableViewConstraint];
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint scrollPos = scrollView.contentOffset;
    
    //scroll from origin down ... move table up and make bigger ... until
    if (scrollPos.y > 0) {
        [self setHeaderOverlap: scrollPos.y];
    } else {
        [self setHeaderOverlap: 0];
    }
}

#pragma mark - UITableViewDataSource

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
            [self saveButtonPressed];
            break;
        case 6:
            [self removeButtonPressed];
            break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    
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
    
    UILabel *addlMaleLabel = [[UILabel alloc] init];
    addlMaleLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.addlMale];
    
    
    UIStepper* stepper = [[UIStepper alloc] init];
        stepper.minimumValue = 0;
    if (self.addlMale > 0) {
        stepper.value = self.addlMale;
    }
    [stepper addTarget:self action:@selector(addlMaleStepperChanged:) forControlEvents:UIControlEventValueChanged];

    [stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    [addlMaleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview: stepper];
    [cell.contentView addSubview:addlMaleLabel];
    
    NSDictionary *views = @{@"label" : label,
                            @"stepper" : stepper,
                            @"male" : addlMaleLabel
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-(>=8)-[male]-16-[stepper]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    
    return cell;
    
}

-(EditRsvpCell*)addFemaleCell {
    EditRsvpCell *cell = [[EditRsvpCell alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+ Female";
    label.font = [[Fonts alloc] titleFont];
    
    UILabel *addlFemaleLabel = [[UILabel alloc] init];
    addlFemaleLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.addlFemale];
    
    
    UIStepper* stepper = [[UIStepper alloc] init];
    stepper.minimumValue = 0;
    if (self.addlFemale > 0) {
        stepper.value = self.addlFemale;
    }
    [stepper addTarget:self action:@selector(addlFemaleStepperChanged:) forControlEvents:UIControlEventValueChanged];
    
    [stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    [addlFemaleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview: stepper];
    [cell.contentView addSubview:addlFemaleLabel];
    
    NSDictionary *views = @{@"label" : label,
                            @"stepper" : stepper,
                            @"female" : addlFemaleLabel
                            };
    
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:0 views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-(>=8)-[female]-16-[stepper]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];

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
    label.textAlignment = NSTextAlignmentCenter;
    
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
    label.textAlignment = NSTextAlignmentCenter;
    
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

-(void)addlMaleStepperChanged:(UIStepper*)stepper {
    self.addlMale = stepper.value;
    [self.tableView reloadData];
}

-(void)addlFemaleStepperChanged:(UIStepper*)stepper {
    self.addlFemale = stepper.value;
    [self.tableView reloadData];
}


#pragma mark - Button Actions
-(void)saveButtonPressed {
    NSString *status = [self getStatusLowercaseString];
    
    NSString *teamId = self.event.team.teamId;
    NSString *eventId = self.event.eventId;
    
    NSString *addlMale = [NSString stringWithFormat:@"%lu", (unsigned long)self.addlMale];
    NSString *addFemale = [NSString stringWithFormat:@"%lu", (unsigned long)self.addlFemale];
    NSString *comments = self.comments;
    NSString *userId = self.userId;
    
    [[TeamCowboyClient sharedService] eventSaveRsvp:status forTeam:teamId forEvent:eventId addlMale:addlMale addlFemale:addFemale withComments:comments rsvpAsUserId:userId];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)removeButtonPressed {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove RSVP" message:@"Please confirm. \nYour status will be set to \n\"No Response\"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    
    [alertView show];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        switch (buttonIndex) {
            case 1:
                [self removeRsvpFromEvent];
                break;
                
            default:
                break;
        }
        
    }
}

-(void)removeRsvpFromEvent {
    NSString *teamId = self.event.team.teamId;
    NSString *eventId = self.event.eventId;
    NSString *userId = self.userId;
    
    [[TeamCowboyClient sharedService] eventSaveRsvp:@"noresponse" forTeam:teamId forEvent:eventId addlMale:0 addlFemale:0 withComments:@"" rsvpAsUserId:userId];
    [self dismissViewControllerAnimated:true completion:nil];

}

-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - misc

-(NSString*)getStatusLowercaseString {
    
    if ([self.status isEqualToString:self.event.rsvpStatusDisplayYes]) {
        return @"yes";
    }
    if ([self.status isEqualToString:self.event.rsvpStatusDisplayMaybe]) {
        return @"maybe";
    }
    if ([self.status isEqualToString:self.event.rsvpStatusDisplayAvailable]) {
        return @"available";
    }
    if ([self.status isEqualToString:self.event.rsvpStatusDisplayNo]) {
        return @"no";
    }
    if ([self.status isEqualToString:self.event.rsvpStatusDisplayNoResponse]) {
        return @"noresponse";
    }
    
    return nil;
}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yyyy '@' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}



@end
