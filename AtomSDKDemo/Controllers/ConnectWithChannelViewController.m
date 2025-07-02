//
//  ConnectWithChannelViewController.m
//  AtomSDKDemo
//
//  Created by Atom By Secure on 17/10/2019.
//  Copyright © 2019 Atom By Secure. All rights reserved.
//

#import "ConnectWithChannelViewController.h"

#import "ConnectWithParamsViewController.h"
#import <AtomSDK/AtomSDK.h>
#import <AtomCore/AtomCore.h>
#import "AppDelegate.h"
#import "PopOverViewController.h"


@interface ConnectWithChannelViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, AtomManagerDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic) IBOutlet UITextField *textfieldProtocol1;
@property (nonatomic) IBOutlet UITextField *textfieldProtocol2;
@property (nonatomic) IBOutlet UITextField *textfieldProtocol3;
@property (weak, nonatomic) IBOutlet UITextField *textfieldChannel;
@property (nonatomic) UIPickerView *protocolPicker;
@property (nonatomic) IBOutlet UIButton *buttonConnect;
@property (nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic) IBOutlet UITableView *tableViewStatus;

@property (nonatomic) NSMutableArray *vpnStatus;
@property (assign) NSInteger selectedTextfield;
@property (assign) NSString *protocol1;
@property (assign) NSString * protocol2;
@property (assign) NSString * protocol3;
@property (nonatomic) AtomChannel *atomChannel;

@property (nonatomic) NSArray *protocolList;

@property (nonatomic) NSArray *allChannelsList;
@property (nonatomic) NSArray *filteredChannels;

@end

@implementation ConnectWithChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"Atom SDK Demo";
    _protocol1 = _protocol2 = _protocol3 = @"";
    
    _vpnStatus = [NSMutableArray new];
    [self statusDidChangedHandler];
    [self getProtocols];
    [self getChannels];
    [self setupTextfields];
    [AtomManager sharedInstance].delegate = self;
    
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

-(void)setupTextfields {
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
    
    self.textfieldProtocol1.inputView = inputView;
    self.textfieldProtocol2.inputView = inputView;
    self.textfieldProtocol3.inputView = inputView;
    self.textfieldChannel.inputView = inputView;
    
    self.tableViewStatus.layer.borderWidth = 1.0;
    self.tableViewStatus.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableViewStatus.layer.cornerRadius = 10.0;
    
}

-(void)endEditing {
    [self.textfieldProtocol1 resignFirstResponder];
    [self.textfieldProtocol2 resignFirstResponder];
    [self.textfieldProtocol3 resignFirstResponder];
    [self.textfieldChannel resignFirstResponder];
}

#pragma mark - Get Protocols and Countries from Atom SDK

-(void)getProtocols {
    [[AtomManager sharedInstance] getProtocolsWithSuccess:^(NSArray<AtomProtocol *> *protocolsList) {
        self.protocolList = protocolsList;
        
        [self.protocolPicker selectedRowInComponent:0];
        AtomProtocol *protocol = [AtomProtocol new];
        protocol = self.protocolList[0];
        _textfieldProtocol1.text = protocol.name;
        _protocol1 = protocol.protocol;
        
    } errorBlock:^(NSError *error) {
        //NSLog(@"%@",error.description);
    }];
}

#pragma mark Channels
-(void) getChannels {
    [[AtomManager sharedInstance] getChannelsWithSuccess:^(NSArray<AtomChannel *> *channelsList) {
        self.allChannelsList = channelsList;
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - IB Actions -

-(void)done {
    [self endEditing];
    AtomProtocol *protocol = [AtomProtocol new];
    NSInteger row = [_protocolPicker selectedRowInComponent:0];
    switch (_selectedTextfield) {
        case 0:
            protocol = self.protocolList[row];
            _textfieldProtocol1.text = protocol.name;
            _protocol1 = protocol.protocol;
            
            break;
        case 1:
            protocol = self.protocolList[row];
            _textfieldProtocol2.text = protocol.name;
            _protocol2 = protocol.protocol;
            
            break;
        case 2:
            protocol = self.protocolList[row];
            _textfieldProtocol3.text = protocol.name;
            _protocol3 = protocol.protocol;
            
            break;
        case 5:
            _atomChannel = _allChannelsList[row];
            _textfieldChannel.text = _atomChannel.name;
            _filteredChannels = [self filterChannelsWithProtocol1:_atomChannel.name];
            break;
        default:
            break;
    }
}

-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)buttonActionReconnect:(id)sender {
    [[AtomManager sharedInstance] reconnectVPN];
//    NSLog(@"getCurrentVPNStatus : %ld",(long)[[AtomManager sharedInstance] getCurrentVPNStatus]);
}

-(IBAction)connect{
    [self endEditing];
    switch (self.buttonConnect.tag) {
        case 0:
            if (_atomChannel == nil || _atomChannel.channelId <= 0) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please select source Channel" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [alert dismissViewControllerAnimated:true completion:nil];
                    }];
                
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion: nil];
            }
            else {
                [_vpnStatus removeAllObjects];
                [_tableViewStatus reloadData];
                [self connectionWithChannel];
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

#pragma mark - UIPickerView DataSource -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    switch (_selectedTextfield) {
        case 5:
            count = _filteredChannels.count;
            break;
        default:
            count = self.protocolList.count;
            break;
    }
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    AtomProtocol *protocol = [AtomProtocol new];
    
    switch (_selectedTextfield) {
        case 5:
            title = ((AtomChannel *)_filteredChannels[row]).name;
            break;
        default:
            protocol = self.protocolList[row];
            title = protocol.name;
            break;
    }
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    AtomProtocol *protocol = [AtomProtocol new];
    switch (_selectedTextfield) {
        case 0:
            protocol = self.protocolList[row];
            _textfieldProtocol1.text = protocol.name;
            _protocol1 = protocol.protocol;
            _filteredChannels = [self filterChannelsWithProtocol1:self.protocol1];
            break;
        case 1:
            protocol = self.protocolList[row];
            _textfieldProtocol2.text = protocol.name;
            _protocol2 = protocol.protocol;
            
            break;
        case 2:
            protocol = self.protocolList[row];
            _textfieldProtocol3.text = protocol.name;
            _protocol3 = protocol.protocol;
            
            break;
            
        case 5:
            _atomChannel = _allChannelsList[row];
            _textfieldChannel.text = _atomChannel.name;
            break;
        default:
        break;
    }
}

-(NSArray<AtomChannel *> *) filterChannelsWithProtocol1:(NSString *) protocol {
    NSMutableArray *channels = [NSMutableArray new];
    for (AtomChannel *channel in self.allChannelsList) {
        if ([channel.protocols filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  evaluatedObject, NSDictionary *bindings) {
            AtomProtocol *selectedProtocol = (AtomProtocol *) evaluatedObject;
            return [selectedProtocol.protocol isEqualToString: protocol];
        }]].firstObject != nil) {
            [channels addObject:channel];
        }
    }
    return channels;
}

#pragma mark - UITextfield Delegate -

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _selectedTextfield = textField.tag;
    [_protocolPicker reloadAllComponents];
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
    UIButton *infoButton = sender;
    PopOverViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    if (infoButton.tag == 1)
        controller.tooltipText = @"If enabled, fastest servers will be fetched based on the smartest ping response.";
    else if (infoButton.tag == 2)
        controller.tooltipText = @"If enabled, ATOM SDK will use smart dialing mechanism to connect to desired country.";
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

#pragma mark - Connection with Params -

-(void) connectionWithChannel {
    [self connectingUI];
    [AtomManager sharedInstance].delegate = self;
    AtomCredential *atomCredential;
    atomCredential = [[AtomCredential alloc] initWithUsername:[AppDelegate sharedInstance].username password:[AppDelegate sharedInstance].password];
    [[AtomManager sharedInstance] setAtomCredential:atomCredential];
    
    AtomProperties *properties = nil;

    AtomProtocol *protocol1 = [AtomProtocol new];
    protocol1.protocol = self.protocol1;
    
    if (_atomChannel != nil) {
        properties = [[AtomProperties alloc] initWithChannel:_atomChannel protocol:protocol1];
    }
    
    if (self.protocol2.length != 0) {
        AtomProtocol *protocol2 = [AtomProtocol new];
        protocol2.protocol = self.protocol2;
        properties.secondaryProtocol = protocol2;
    }
    
    if (self.protocol3.length != 0) {
        AtomProtocol *protocol3 = [AtomProtocol new];
        protocol3.protocol = self.protocol3;
        properties.tertiaryProtocol = protocol3;
    }
    
    AtomOnDemandConfiguration *configuration = [[AtomOnDemandConfiguration alloc] init];
    configuration.onDemandRulesEnabled = YES;
    
    [[AtomManager sharedInstance] setOnDemandConfiguration:configuration];
    
    [[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {
      
      
    } errorBlock:^(NSError *error) {
        NSLog(@"ERROR IN CONNECTING : %@",error.description);
        [self normalUI];
    }];
}

- (IBAction)buttonApplyConfigAction:(id)sender{
    AtomOnDemandConfiguration *configuration = [[AtomOnDemandConfiguration alloc] init];
    configuration.onDemandRulesEnabled = YES;
    [[AtomManager sharedInstance] setOnDemandConfiguration:configuration];
}

#pragma mark - Atom Manager Delegates

-(void)atomManagerDidConnect:(AtomConnectionDetails *)atomConnectionDetails {
    [self connectedUI];
    NSString *message = [NSString stringWithFormat:@"CONNECTED with IP\n%@", [[AtomManager sharedInstance] getConnectedIP]];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"VPN Status" message: message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
    NSLog(@"VPN Status: CONNECTED");
}

-(void)atomManagerDidDisconnect:(AtomConnectionDetails *)atomConnectionDetails {
    [self normalUI];
}

-(void)atomManagerOnRedialing:(AtomConnectionDetails *)atomConnectionDetails withError:(NSError *)error {
    [self connectingUI];
}

-(void)atomManagerDialErrorReceived:(NSError *)error withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails {
    [_vpnStatus addObject:[NSString stringWithFormat:@"Error: %ld - %@",(long)error.code,error.localizedDescription]];
    [_tableViewStatus reloadData];
    if(error.code != 5043 && [[AtomManager sharedInstance]getCurrentVPNStatus] == CONNECTED)
        [self normalUI];
}

#pragma mark - Atom Status Handler -

-(void)statusDidChangedHandler {
    [AtomManager sharedInstance].stateDidChangedHandler = ^(AtomVPNState status) {
        switch (status) {
            case AtomStatusInvalid:
                [_vpnStatus addObject:@"Invalid"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);
                break;
            case AtomStatusConnected:
                [_vpnStatus addObject:@"Connected"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusConnecting:
                [_vpnStatus addObject:@"Connecting"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusValidating:
                [_vpnStatus addObject:@"Validating"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusReasserting:
                [_vpnStatus addObject:@"Reasserting"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusDisconnected:
                [_vpnStatus addObject:@"Disconnected"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusDisconnecting:
                [_vpnStatus addObject:@"Disconnecting"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusAuthenticating:
                [_vpnStatus addObject:@"Authenticating"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusVerifyingHostName:
                [_vpnStatus addObject:@"Verifying Hostname"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusGettingFastestServer:
                [_vpnStatus addObject:@"Getting Faster Server"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusOptimizingConnection:
                [_vpnStatus addObject:@"Optimizing Connection"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            case AtomStatusGeneratingCredentials:
                [_vpnStatus addObject:@"Generating Credentials"];
                NSLog(@"%@ - %ld",_vpnStatus,(long)AtomManager.sharedInstance.getCurrentVPNStatus);

                break;
            default:
                break;
        }
        [_tableViewStatus reloadData];
        
    };
}

@end
