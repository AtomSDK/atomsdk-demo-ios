 //
//  ConnectWithDedicatedIPViewController.m
//  AtomSDK Demo

#import "ConnectWithDedicatedIPViewController.h"
#import <AtomSDK/AtomManager.h>
#import "AppDelegate.h"
#import "PopOverViewController.h"

@interface ConnectWithDedicatedIPViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AtomManagerDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic) NSArray *protocolList;
@property (assign) NSString * selectedProtocolNumber;
@property (nonatomic) NSMutableArray *vpnStatus;

@property (nonatomic) IBOutlet UITableView *tableViewStatus;
@property (nonatomic) IBOutlet UITextField *textfieldDedicatedIP;
@property (nonatomic) IBOutlet UITextField *textfieldProtocol;
@property (nonatomic) UIPickerView *protocolPicker;
@property (nonatomic) IBOutlet UIButton *buttonConnect;
@property (nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic) IBOutlet UISwitch *switchSkipUserVerification;

@end

@implementation ConnectWithDedicatedIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"Atom SDK Demo";
    _vpnStatus = [NSMutableArray new];
    [self statusDidChangedHandler];
    [self getProtocols];
    [self normalUI];
    [self setupTextfield];
    
    //_selectedProtocolNumber = 0;
    self.textfieldDedicatedIP.text = @"us-ovpn-udp.ptoserver.com";
    self.tableViewStatus.layer.borderWidth = 1.0;
    self.tableViewStatus.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableViewStatus.layer.cornerRadius = 10.0;
    
    AtomVPNStatus state = [[AtomManager sharedInstance] getCurrentVPNStatus];
    switch (state) {
        case DISCONNECTED:
            [self normalUI];
        break;
            
        case CONNECTED:
            [self connectedUI];
        break;
        
        default:
            [self connectingUI];
        break;
    }
    
}

-(void)setupTextfield {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    toolBar.items = @[flex, barButtonDone];
    barButtonDone.tintColor = [UIColor blackColor];
    
    _protocolPicker = [UIPickerView new];
    _protocolPicker.dataSource = self;
    _protocolPicker.delegate = self;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, toolBar.frame.size.height + _protocolPicker.frame.size.height)];
    inputView.backgroundColor = [UIColor clearColor];
    [inputView addSubview:_protocolPicker];
    [inputView addSubview:toolBar];
    
    _textfieldProtocol.inputView = inputView;
}

-(void)endEditing {
    [self.textfieldProtocol resignFirstResponder];
    [self.textfieldDedicatedIP resignFirstResponder];
}

#pragma mark - Get Protocols from Atom SDK -

-(void)getProtocols {
    [[AtomManager sharedInstance] getProtocolsWithSuccess:^(NSArray<AtomProtocol *> *protocolsList) {
        self.protocolList = protocolsList;
        
        [self.protocolPicker selectedRowInComponent:0];
        AtomProtocol *protocol = [AtomProtocol new];
        protocol = self.protocolList[0];
        _textfieldProtocol.text = protocol.name;
        _selectedProtocolNumber = protocol.protocol;
    } errorBlock:^(NSError *error) {
        //NSLog(@"%@",error.description);
    }];
}

#pragma mark - IB Actions -

-(void)done {
    [self endEditing];
}

-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)connect:(id)sender {
    [self endEditing];
    switch (self.buttonConnect.tag) {
        case 0:
            if(self.textfieldDedicatedIP.text.length == 0) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter any host" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [alert dismissViewControllerAnimated:true completion:nil];
                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (_selectedProtocolNumber == 0) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Select a protocol to continue" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [alert dismissViewControllerAnimated:true completion:nil];
                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [_vpnStatus removeAllObjects];
                [_tableViewStatus reloadData];
                [self connectionWithDedicatedIP];
            }
            break;
        case 1:
            [[AtomManager sharedInstance] disconnectVPN];
            [self normalUI];
            break;
        case 2:
            [[AtomManager sharedInstance] cancelVPN];
            [self normalUI];
            break;
        default:
            break;
    }
}

-(IBAction)switchChangeAction:(id)sender {
    
}

#pragma mark - UIPickerView DataSource -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.protocolList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    AtomProtocol *protocol = [AtomProtocol new];
    protocol = self.protocolList[row];
    return protocol.name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    AtomProtocol *protocol = [AtomProtocol new];
    protocol = self.protocolList[row];
    _textfieldProtocol.text = protocol.name;
    _selectedProtocolNumber = protocol.protocol;
}

#pragma mark - UITextfield Delegate -

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [_protocolPicker reloadAllComponents];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vpnStatus.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _vpnStatus[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

#pragma mark - Show Popover -

-(IBAction)showPopOver:(UIButton *)sender {
    PopOverViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    controller.tooltipText = @"Connects to your specified host even if not allowed to your username (or when using Auto Generate user credentials)";
    controller.preferredContentSize = CGSizeMake(280,70);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popoverController = controller.popoverPresentationController;
    popoverController.sourceRect = sender.frame;
    popoverController.sourceView = self.view;
    popoverController.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - VPN UI States

-(void)normalUI {
    [self.buttonConnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    self.buttonConnect.tag = 0;
    self.navigationController.navigationItem.hidesBackButton = false;
    self.navigationItem.leftBarButtonItem = self.leftBarButton;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    self.navigationItem.hidesBackButton = false;
}

-(void)connectedUI {
    [self.buttonConnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
    self.buttonConnect.tag = 1;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    self.navigationItem.hidesBackButton = true;
}

-(void)connectingUI {
    [self.buttonConnect setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.buttonConnect.tag = 2;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    self.navigationItem.hidesBackButton = true;
}

#pragma mark - Connection with Dedicated IP -

-(void)connectionWithDedicatedIP {
    [self connectingUI];
    
    [AtomManager sharedInstance].delegate = self;
    AtomCredential *atomCredential;
    atomCredential = [[AtomCredential alloc] initWithUsername:[AppDelegate sharedInstance].username password:[AppDelegate sharedInstance].password];
    [[AtomManager sharedInstance] setAtomCredential:atomCredential];
    
    AtomProtocol *protocol = [AtomProtocol new];
    protocol.protocol = self.selectedProtocolNumber;
    
    AtomProperties *properties = [[AtomProperties alloc] initWithDedicatedHostName:self.textfieldDedicatedIP.text protocol:protocol];
//    properties.skipUserVerification = self.switchSkipUserVerification.isOn;
    
    [[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {
        
    } errorBlock:^(NSError *error) {
        NSLog(@"ERROR IN CONNECTING : %@",error.description);
        [self normalUI];
    }];
}

#pragma mark - Atom Manager Delegates

-(void)atomManagerDidConnect:(AtomConnectionDetails *)atomConnectionDetails {
    //NSLog(@"VPN CONNECTED");
    [self connectedUI];
}

-(void)atomManagerDidDisconnect:(AtomConnectionDetails *)atomConnectionDetails {
    //NSLog(@"VPN DISCONNECTED");
    [self normalUI];
}

-(void)atomManagerOnRedialing:(AtomConnectionDetails *)atomConnectionDetails withError:(NSError *)error {
    //NSLog(@"REDIALING CONNECTION");
    [self connectingUI];
}

-(void)atomManagerDialErrorReceived:(NSError *)error withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails {
    //NSLog(@"DIALED ERROR: %@",error.description);
    [_vpnStatus addObject:[NSString stringWithFormat:@"Error: %ld - %@",(long)error.code,error.localizedDescription]];
    [_tableViewStatus reloadData];
    [self normalUI];
}

#pragma mark - Atom Status Handler -

-(void)statusDidChangedHandler {
    [AtomManager sharedInstance].stateDidChangedHandler = ^(AtomVPNState status) {
        switch (status) {
            case AtomStatusInvalid:
                [_vpnStatus addObject:@"Invalid"];
                break;
            case AtomStatusConnected:
                [_vpnStatus addObject:@"Connected"];
                break;
            case AtomStatusConnecting:
                [_vpnStatus addObject:@"Connecting"];
                break;
            case AtomStatusValidating:
                [_vpnStatus addObject:@"Validating"];
                break;
            case AtomStatusReasserting:
                [_vpnStatus addObject:@"Reasserting"];
                break;
            case AtomStatusDisconnected:
                [_vpnStatus addObject:@"Disconnected"];
                break;
            case AtomStatusDisconnecting:
                [_vpnStatus addObject:@"Disconnecting"];
                break;
            case AtomStatusAuthenticating:
                [_vpnStatus addObject:@"Authenticating"];
                break;
            case AtomStatusVerifyingHostName:
                [_vpnStatus addObject:@"Verifying Hostname"];
                break;
            case AtomStatusGettingFastestServer:
                [_vpnStatus addObject:@"Getting Faster Server"];
                break;
            case AtomStatusOptimizingConnection:
                [_vpnStatus addObject:@"Optimizing Connection"];
                break;
            case AtomStatusGeneratingCredentials:
                [_vpnStatus addObject:@"Generating Credentials"];
                break;
            default:
                break;
        }
        [_tableViewStatus reloadData];
    };
}

@end

