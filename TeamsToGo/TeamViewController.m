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

#pragma mark - Interface
@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *teamMembers;
@property (strong, nonatomic) NSMutableDictionary *membersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;

@property (strong, nonatomic) NSMutableArray *selectedMembers;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *multiContactButton;
@property (strong, nonatomic) UIButton *cancelMultiSelectButton;
@property (strong, nonatomic) UIButton *contactButton;

@property (strong, nonatomic) NSString *selectedContactPhone;
@property (strong, nonatomic) NSString *selectedContactEmail;

@end

#pragma mark - Implemenation
@implementation TeamViewController

#pragma mark - UIViewController Lifecycle
-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.selectedMembers = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] init];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = [self.team name];
    title.font = [[Fonts alloc] titleFont];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.multiContactButton = [[UIButton alloc] init];
    self.multiContactButton.titleLabel.font = [[Fonts alloc] subTitleFont];
    [self.multiContactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.multiContactButton setTitle:@"Select" forState:UIControlStateNormal];
    [self.multiContactButton addTarget:self action:@selector(multiContactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelMultiSelectButton = [[UIButton alloc] init];
    self.cancelMultiSelectButton.titleLabel.font = [[Fonts alloc] subTitleFont];
    self.cancelMultiSelectButton.hidden = YES;
    [self.cancelMultiSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelMultiSelectButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelMultiSelectButton addTarget:self action:@selector(cancelMultiSelectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.contactButton = [[UIButton alloc] init];
    self.contactButton.titleLabel.font = [[Fonts alloc] subTitleFont];
    self.contactButton.hidden = YES;
    [self.contactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contactButton setTitle:@"Message" forState:UIControlStateNormal];
    [self.contactButton addTarget:self action:@selector(contactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.multiContactButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.cancelMultiSelectButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.contactButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.backButton];
    [self.rootView addSubview:self.multiContactButton];
    [self.rootView addSubview:self.cancelMultiSelectButton];
    [self.rootView addSubview:self.contactButton];
    
    NSDictionary *views = @{@"title" : title,
                            @"tableView" : self.tableView,
                            @"back" : self.backButton,
                            @"multi" : self.multiContactButton,
                            @"cancel" : self.cancelMultiSelectButton,
                            @"message" : self.contactButton};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[title]-[tableView]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[back(20)]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[cancel]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[multi]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[message]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(20)]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[cancel]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[multi]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[message]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) {

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
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.tableView.editing) {
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
    
    if (self.tableView.editing) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Text"]) {
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            for (TeamMember *member in self.selectedMembers) {
                if (![member.user.phoneNumber isEqualToString:@""]) {
                    [phoneNumbers addObject:[self numbersOnlyFromString:member.user.phoneNumber]];
                }
            }
            [self textMultiplePhones:phoneNumbers];
        }
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: @"Email"]) {
            NSMutableArray *emailAddresses = [[NSMutableArray alloc] init];
            for (TeamMember *member in self.selectedMembers) {
                if (![member.user.emailAddress isEqualToString:@""]) {
                    [emailAddresses addObject:member.user.emailAddress];
                }
            }
            [self emailMultiplePlayers:emailAddresses];
        }
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
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

#pragma mark - MFMessageComposeViewControllerDelegate
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

#pragma mark - contact methods
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
    [self textMultiplePhones:@[phone]];
}

-(void)textMultiplePhones:(NSArray*)phones {
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    if (phones == nil) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No phone numbers selected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    for (NSString *phone in phones) {
        if (![phone isEqualToString:@""]) {
            [phoneNumbers addObject:phone];
        }
    }

    if ([phoneNumbers count] == 0) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No phone numbers selected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = phoneNumbers;
    NSString *message = [NSString stringWithFormat:@"[%@]", self.team.name];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}

-(void)emailPlayer:(NSString*)email {
    [self emailMultiplePlayers:@[email]];
}

-(void)emailMultiplePlayers:(NSArray*)emails {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSMutableArray *emailAddresses = [[NSMutableArray alloc] init];
    for (NSString *email in emails) {
        if (![email isEqualToString:@""] && [self validateEmail:email]) {
            [emailAddresses addObject:email];
        }
    }
    
    if ([emailAddresses count] == 0) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No email addresses selected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *emailSubject = [NSString stringWithFormat:@"[%@]", self.team.name];
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = emailAddresses;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailSubject];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
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

-(void)multiContactButtonPressed {
    self.backButton.hidden = YES;
    self.multiContactButton.hidden = YES;
    self.cancelMultiSelectButton.hidden = NO;
    self.contactButton.hidden = NO;
    [self.tableView setEditing:YES animated:YES];
}

-(void)cancelMultiSelectButtonPressed {
    self.backButton.hidden = NO;
    self.multiContactButton.hidden = NO;
    self.cancelMultiSelectButton.hidden = YES;
    self.contactButton.hidden = YES;
    [self.tableView setEditing:NO animated:YES];
}

-(void)contactButtonPressed {
    [self.selectedMembers removeAllObjects];
    NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    
    if (selectedIndexPaths == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Members Selected" message:@"Select at least 1 member to message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        NSString *section = self.groupTypes[indexPath.section];
        TeamMember *selectedMember = self.membersGrouped[section][indexPath.row];
        [self.selectedMembers addObject:selectedMember];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select way to contact" delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Text"];
    [actionSheet addButtonWithTitle:@"Email"];
    
    [actionSheet showInView:self.view];
    
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
