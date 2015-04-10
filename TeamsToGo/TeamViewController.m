//
//  TeamViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "TeamViewController.h"
#import "TeamCowboyService.h"
#import "TeamCowboyClient.h"
#import "User.h"
#import "TeamMember.h"
#import "Team.h"
#import "RosterCell.h"
#import "Fonts.h"


@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *teamMembers;
@property (strong, nonatomic) NSMutableDictionary *membersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSString *selectedContactPhone;
@property (strong, nonatomic) NSString *selectedContactEmail;

@end

@implementation TeamViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.tableView = [[UITableView alloc] init];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = [self.team name];
    title.font = [[Fonts alloc] titleFont];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.backButton];
    
    NSDictionary *views = @{@"title" : title,
                            @"tableView" : self.tableView,
                            @"back" : self.backButton};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[title]-[tableView]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[back(20)]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(20)]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:RosterCell.class forCellReuseIdentifier:@"ROSTER_CELL"];

}

-(void)viewDidAppear:(BOOL)animated {
    [self getMembers];
}

-(void)getMembers {
    [[TeamCowboyClient sharedService] teamGetRoster:self.team.teamId];
    self.teamMembers = [[TeamCowboyService sharedService] fetchAllTeamMembersForTeam:self.team];
    [self groupPlayersByType];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTypes count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groupTypes[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.membersGrouped[self.groupTypes[section]] count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = self.groupTypes[indexPath.section];
    
    
    TeamMember *member = (TeamMember*)self.membersGrouped[type][indexPath.row];
    User *user = (User*)member.user;

    RosterCell *cell = (RosterCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ROSTER_CELL" forIndexPath:indexPath];
    
    cell.nameLabel.text = user.name;
    
    if (![user.phoneNumber isEqualToString:@""]){
        cell.phoneLabel.text = [self formatUsPhoneNumber:[self numbersOnlyFromString:user.phoneNumber]];
        cell.phoneLabel.hidden = NO;
        cell.phoneIcon.hidden = NO;
    } else {
        cell.phoneLabel.text = @"";
        cell.phoneLabel.hidden = YES;
        cell.phoneIcon.hidden = YES;
    }
    if (![user.emailAddress isEqualToString:@""]) {
        cell.emailLabel.text = user.emailAddress;
        cell.emailLabel.hidden = NO;
        cell.emailIcon.hidden = NO;
    } else {
        cell.emailLabel.text = @"";
        cell.emailLabel.hidden = YES;
        cell.emailIcon.hidden = YES;
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    
    [header addSubview:headerLabel];
    
    header.backgroundColor = [UIColor grayColor];
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    headerLabel.text = self.groupTypes[section];
    
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = self.groupTypes[indexPath.section];
    
    TeamMember *member = (TeamMember*)self.membersGrouped[type][indexPath.row];
    User *user = (User*)member.user;
    
    NSString *actionSheetTitle = [NSString stringWithFormat:@"Contact %@", user.name];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    if (![user.phoneNumber isEqualToString:@""]) {
        self.selectedContactPhone = [self numbersOnlyFromString:user.phoneNumber];
        [actionSheet addButtonWithTitle:@"Call"];
        [actionSheet addButtonWithTitle:@"Text"];
    } else {
        self.selectedContactPhone = @"";
    }
    
    if (![user.emailAddress isEqualToString:@""]) {
        self.selectedContactEmail = user.emailAddress;
        [actionSheet addButtonWithTitle:@"Email"];
    } else {
        self.selectedContactEmail = @"";
    }

    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Call"]) {
        [self callPhone:self.selectedContactPhone];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Text"]) {
        [self textPhone:self.selectedContactPhone];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Email"]) {
        [self emailPlayer:self.selectedContactEmail];
    }
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed: {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)callPhone:(NSString*)phone {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Phone Calls!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    if (![phone isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone]];
        [[UIApplication  sharedApplication] openURL:url];
    }
}

-(void)textPhone:(NSString*)phone {
    if (![phone isEqualToString:@""] && ![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[phone];
    NSString *message = [NSString stringWithFormat:@"[%@]", self.team.name];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    

}

-(void)emailPlayer:(NSString*)email {
    
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    if (![email isEqualToString:@""] && [self validateEmail:email]) {

        NSString *emailSubject = [NSString stringWithFormat:@"[%@]", self.team.name];
        // Email Content
        NSString *messageBody = @"";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:email];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailSubject];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];

    }
}


#pragma mark - group players by type
-(void)groupPlayersByType {
    self.membersGrouped = [[NSMutableDictionary alloc] init];
    self.groupTypes = [[NSMutableArray alloc] init];
    
    for (TeamMember *member in self.teamMembers) {

        if (![self.membersGrouped objectForKey:member.memberType]) {
            [self.groupTypes addObject:member.memberType];
            [self.membersGrouped setObject:[[NSMutableArray alloc] initWithArray:@[member]]
                                    forKey:member.memberType];
        } else {
            [[self.membersGrouped objectForKey:member.memberType] addObject:member];
        }
    }
    
    NSArray *sortOrder = @[@"Manager",
                           @"Full-time",
                           @"Part-time",
                           @"Sub",
                           @"Injured"];

    [self.groupTypes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger indexOfObj1 = [sortOrder indexOfObject: obj1];
        NSUInteger indexOfObj2 = [sortOrder indexOfObject: obj2];
        
        if (indexOfObj1 == NSNotFound && indexOfObj2 == NSNotFound){
            return NSOrderedSame;
        } else if (indexOfObj1 != NSNotFound && indexOfObj2 == NSNotFound){
            return NSOrderedAscending;
        } else if (indexOfObj1 == NSNotFound && indexOfObj2 != NSNotFound){
            return NSOrderedDescending;
        } else if (indexOfObj1 > indexOfObj2){
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
}

#pragma mark - button actions
-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - misc
-(NSString*)numbersOnlyFromString:(NSString*)originalString {
    return [[originalString componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                  componentsJoinedByString:@""];
}

-(NSString*)formatUsPhoneNumber:(NSString*)originalString {
    return [NSString stringWithFormat:@"(%@) %@-%@",
            [originalString  substringToIndex:3],
            [originalString substringWithRange:NSMakeRange(3,3)],
            [originalString substringFromIndex:6]];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
