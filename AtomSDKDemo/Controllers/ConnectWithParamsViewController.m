//
//  ConnectWithParamsViewController.m
//  AtomSDK Demo

#import "ConnectWithParamsViewController.h"
#import <AtomSDK/AtomManager.h>
#import <AtomSDK/AtomProtocol.h>
#import "AppDelegate.h"
#import "PopOverViewController.h"

@interface ConnectWithParamsViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, AtomManagerDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic) IBOutlet UITextField *textfieldProtocol1;
@property (nonatomic) IBOutlet UITextField *textfieldProtocol2;
@property (nonatomic) IBOutlet UITextField *textfieldProtocol3;
@property (nonatomic) IBOutlet UITextField *textfieldCountry;
@property (nonatomic) UIPickerView *protocolPicker;
@property (nonatomic) IBOutlet UIButton *buttonConnect;
@property (nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic) IBOutlet UITableView *tableViewStatus;
@property (nonatomic) IBOutlet UISwitch *optimizeCountry;

@property (nonatomic) NSMutableArray *vpnStatus;
@property (assign) NSInteger selectedTextfield;
@property (assign) NSInteger protocol1;
@property (assign) NSInteger protocol2;
@property (assign) NSInteger protocol3;
@property (assign) NSInteger countryId;

@property (nonatomic) NSArray *protocolList;
@property (nonatomic) NSArray *allCountriesList;
@property (nonatomic) NSMutableArray *filteredCountriesList;

@end

@implementation ConnectWithParamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"Atom SDK Demo";
    _countryId = _protocol1 = _protocol2 = _protocol3 = 0;
    self.filteredCountriesList = [NSMutableArray new];
    
    _vpnStatus = [NSMutableArray new];
    [self statusDidChangedHandler];
    [self getProtocols];
    [self setupTextfields];
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
    self.textfieldCountry.inputView = inputView;
    
    self.tableViewStatus.layer.borderWidth = 1.0;
    self.tableViewStatus.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableViewStatus.layer.cornerRadius = 10.0;
    
}

-(void)endEditing {
    [self.textfieldProtocol1 resignFirstResponder];
    [self.textfieldProtocol2 resignFirstResponder];
    [self.textfieldProtocol3 resignFirstResponder];
    [self.textfieldCountry resignFirstResponder];
}

#pragma mark - Get Protocols and Countries from Atom SDK

-(void)getProtocols {
    [[AtomManager sharedInstance] getProtocolsWithSuccess:^(NSArray<AtomProtocol *> *protocolsList) {
        self.protocolList = protocolsList;
        
        [self.protocolPicker selectedRowInComponent:0];
        AtomProtocol *protocol = [AtomProtocol new];
        protocol = self.protocolList[0];
        _textfieldProtocol1.text = protocol.name;
        _protocol1 = protocol.number;
        
        [self getCountries];
        [self getOptimizeCountries];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)getCountries {
    [[AtomManager sharedInstance] getCountriesWithSuccess:^(NSArray<AtomCountry *> *countriesList) {
        self.allCountriesList = countriesList;
        [_protocolPicker reloadAllComponents];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)getOptimizeCountries {
    [[AtomManager sharedInstance] getOptimizedCountriesWithSuccess:^(NSArray<AtomCountry *> *countriesList) {
        for (AtomCountry *country in countriesList) {
            NSLog(@"Country ID: %d, Country Name: %@, Latency: %d",country.countryId, country.name, country.latency);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)filterCountriesWithProtocol1:(NSInteger)protocol1 {
    NSMutableArray *temp_countries = [NSMutableArray new];
    
    for (AtomCountry *country in self.allCountriesList) {
        for (AtomProtocol *protocol in country.protocol) {
            if (protocol.number == self.protocol1) {
                [temp_countries addObject:country];
                break;
            }
        }
    }
    
    NSLog(@"TOTAL FILTERED COUNTRIES %lu",(unsigned long)temp_countries.count);
}
-(void)filterCountriesWithProtocol2:(NSInteger)protocol2 {
    for (AtomCountry *country in self.allCountriesList) {
        for (AtomProtocol *protocol in country.protocol) {
            if (protocol.number == self.protocol2) {

                break;
            }
        }
    }
}
-(void)filterCountriesWithProtocol3:(NSInteger)protocol3 {
    for (AtomCountry *country in self.allCountriesList) {
        for (AtomProtocol *protocol in country.protocol) {
            if (protocol.number == self.protocol3) {

                break;
            }
        }
    }
}

#pragma mark - IB Actions -

-(void)done {
    [self endEditing];
    AtomProtocol *protocol = [AtomProtocol new];
    AtomCountry *country = [AtomCountry new];
    NSInteger row = [_protocolPicker selectedRowInComponent:0];
    switch (_selectedTextfield) {
        case 0:
            protocol = self.protocolList[row];
            _textfieldProtocol1.text = protocol.name;
            _protocol1 = protocol.number;

            break;
        case 1:
            protocol = self.protocolList[row];
            _textfieldProtocol2.text = protocol.name;
            _protocol2 = protocol.number;

            break;
        case 2:
            protocol = self.protocolList[row];
            _textfieldProtocol3.text = protocol.name;
            _protocol3 = protocol.number;

            break;
        case 3:
            country = self.allCountriesList[row];
            _textfieldCountry.text = country.name;
            _countryId = country.countryId;
            break;
        default:
            break;
    }
}

-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)connect{
    [self endEditing];
    switch (self.buttonConnect.tag) {
        case 0:
            if (self.countryId == 0) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please select country" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [alert dismissViewControllerAnimated:true completion:nil];
                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [_vpnStatus removeAllObjects];
                [_tableViewStatus reloadData];
                [self connectionWithParams];
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
        case 3:
            count = self.allCountriesList.count;
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
    AtomCountry *country = [AtomCountry new];
    
    switch (_selectedTextfield) {
        case 3:
            country = self.allCountriesList[row];
            title = country.name;
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
    AtomCountry *country = [AtomCountry new];

    switch (_selectedTextfield) {
        case 0:
            protocol = self.protocolList[row];
            _textfieldProtocol1.text = protocol.name;
            _protocol1 = protocol.number;
            [self filterCountriesWithProtocol1:self.protocol1];
            break;
        case 1:
            protocol = self.protocolList[row];
            _textfieldProtocol2.text = protocol.name;
            _protocol2 = protocol.number;

            break;
        case 2:
            protocol = self.protocolList[row];
            _textfieldProtocol3.text = protocol.name;
            _protocol3 = protocol.number;

            break;
        case 3:
            country = self.allCountriesList[row];
            _textfieldCountry.text = country.name;
            _countryId = country.countryId;
            break;
        default:
            break;
    }
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
    PopOverViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    controller.tooltipText = @"If checked, fastest servers will be fetched based on the smartest ping response.";
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

-(void)connectionWithParams {
    [self connectingUI];
    
    [AtomManager sharedInstance].delegate = self;
    AtomCredential *atomCredential;
    if ([AppDelegate sharedInstance].isAutoGeneratedUserCredentials) {
        [AtomManager sharedInstance].UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
    }
    else {
        atomCredential = [[AtomCredential alloc] initWithUsername:[AppDelegate sharedInstance].username password:[AppDelegate sharedInstance].password];
        [[AtomManager sharedInstance] setAtomCredential:atomCredential];
        
    }
    
    AtomProtocol *protocol1 = [AtomProtocol new];
    protocol1.number = (int)self.protocol1;
    
    AtomCountry *country = [AtomCountry new];
    country.countryId = (int)self.countryId;
    
    AtomProperties *properties = [[AtomProperties alloc] initWithCountry:country protocol:protocol1];
    properties.useOptimization = self.optimizeCountry.isOn;
    if (self.protocol2 != 0) {
        AtomProtocol *protocol2 = [AtomProtocol new];
        protocol2.number = (int)self.protocol2;
        properties.secondaryProtocol = protocol2;
    }
    
    if (self.protocol3 != 0) {
        AtomProtocol *protocol3 = [AtomProtocol new];
        protocol3.number = (int)self.protocol3;
        properties.tertiaryProtocol = protocol3;
    }
    
    [[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {
        NSLog(@"%@",success);
    } errorBlock:^(NSError *error) {
        NSLog(@"ERROR IN CONNECTING : %@",error.description);
        [self normalUI];
    }];
}

#pragma mark - Atom Manager Delegates

-(void)atomManagerDidConnect {
    NSLog(@"VPN CONNECTED");
    [self connectedUI];
}

-(void)atomManagerDidDisconnect:(BOOL)manuallyDisconnected {
    NSLog(@"VPN DISCONNECTED");
    [self normalUI];
}

-(void)atomManagerOnRedialing:(AtomConnectionDetails *)atomConnectionDetails withError:(NSError *)error {
    NSLog(@"REDIALING CONNECTION");
    [self connectingUI];
}

-(void)atomManagerDialErrorReceived:(NSError *)error withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails {
    NSLog(@"DIALED ERROR: %@",error.description);
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
