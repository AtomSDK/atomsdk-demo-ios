//
//  ViewController.m
//  AtomSDK Demo

#import "ViewController.h"
#import "AppDelegate.h"
#import "PopOverViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic) NSArray *connectionList;
@property (nonatomic) NSArray *viewControllerList;

@property (nonatomic) IBOutlet UITableView *tableViewConnectionList;
@property (nonatomic) IBOutlet UISwitch *switchUserCredentials;
@property (nonatomic) IBOutlet UISwitch *switchRemoveProfile;

@property (nonatomic) IBOutlet UILabel *labelUsername;
@property (nonatomic) IBOutlet UILabel *labelPassword;
@property (nonatomic) IBOutlet UILabel *labelUDID;
@property (nonatomic) IBOutlet UILabel *labelSecretKey;

@property (nonatomic) IBOutlet UITextField *textfieldUsername;
@property (nonatomic) IBOutlet UITextField *textfieldPassword;
@property (nonatomic) IBOutlet UITextField *textfieldUDID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Atom SDK Demo";
    
    self.connectionList = @[@"Connect with Params", @"Connect with Dedicated IP", @"Connect With Channel"];
    self.viewControllerList = @[@"ConnectWithParamsViewController", @"ConnectWithDedicatedIPViewController", @"ConnectWithChannelViewController"];
    
    self.labelSecretKey.text = [NSString stringWithFormat:@"Secret Key %@",[AppDelegate sharedInstance].secretKey];
    self.tableViewConnectionList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    [self performSelector:@selector(checkVPNStatus) withObject:nil afterDelay:0.6];
    
}

- (void) checkVPNStatus {
    AtomVPNStatus state = [[AtomManager sharedInstance] getCurrentVPNStatus];
    switch (state) {
        case DISCONNECTED:
        break;
            
        case CONNECTED: {
            NSString *message = [NSString stringWithFormat:@"CONNECTED with IP\n%@", [[AtomManager sharedInstance] getConnectedIP]];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"VPN Status" message: message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *disconnect = [UIAlertAction actionWithTitle: @"Disconnect" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[AtomManager sharedInstance] disconnectVPN];
            }];
            [controller addAction:action];
            [controller addAction:disconnect];
            [self presentViewController:controller animated:YES completion:nil];
        }
        break;
        default:
            break;
    }
}

-(void)moveToNextController:(NSIndexPath*)indexPath {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:self.viewControllerList[indexPath.row]];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - IB Actions -

-(IBAction)switchChangeAction:(id)sender {
    self.textfieldUsername.enabled = true;
    self.textfieldUsername.text = [AppDelegate sharedInstance].username;
    self.textfieldPassword.enabled = true;
    self.textfieldPassword.text = [AppDelegate sharedInstance].password;
    self.textfieldUDID.enabled = false;
    self.textfieldUDID.text = @"";
    
    self.labelUsername.textColor = [UIColor whiteColor];
    self.labelPassword.textColor = [UIColor whiteColor];
    self.labelUDID.textColor = [UIColor lightGrayColor];
}

-(IBAction)switchRemoveProfile: (id)sender {
    [[AtomManager sharedInstance] removeVPNProfileWithCompletion:^(BOOL isSuccess) {
        [self getAlertForRemovingProfileWithStatus: isSuccess ? @"YES" : @"NO"];
    }];
}

- (void) getAlertForRemovingProfileWithStatus: (NSString *) status {
    UIAlertController *controller = [UIAlertController new];
    [controller setTitle:@"VPN Profile"];
    [controller setMessage: [NSString stringWithFormat: @"VPN Profile Deleted: %@", status]];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.switchRemoveProfile setOn:NO];
    }];
    [controller addAction:defaultAction];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UITableView DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectionList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.connectionList[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self endEditing];
    
    if (self.textfieldUsername.text.length == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username is required for connecting VPN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (self.textfieldPassword.text.length == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password is required for connecting VPN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [AppDelegate sharedInstance].username = self.textfieldUsername.text;
        [AppDelegate sharedInstance].password = self.textfieldPassword.text;
        [self moveToNextController:indexPath];
    }
}

#pragma mark - UITextField Delegate -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textfieldUsername == textField) {
        [AppDelegate sharedInstance].username = self.textfieldUsername.text;
    }
    else if (self.textfieldPassword == textField) {
        [AppDelegate sharedInstance].password = self.textfieldPassword.text;

    }
    else if (self.textfieldUDID == textField) {
        [AppDelegate sharedInstance].UDID = self.textfieldUDID.text;

    }
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing];
    return YES;
}

-(void)endEditing {
    [self.textfieldUsername resignFirstResponder];
    [self.textfieldPassword resignFirstResponder];
    [self.textfieldUDID resignFirstResponder];
}

@end
