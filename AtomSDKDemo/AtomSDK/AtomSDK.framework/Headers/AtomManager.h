//
//  AtomManager.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomStatus.h"
#import "AtomCredential.h"
#import "AtomProperties.h"
#import "AtomCountry.h"
#import "AtomProtocol.h"
#import "AtomConnectionDetails.h"
#import "AtomConfiguration.h"

// This protocol represents the Atom Manager delegates. As such, it supplies information about connection and disconnection of the VPN tunnel.
@protocol AtomManagerDelegate <NSObject>

/*!
 * @method atomManagerDidConnect:
 * @discussion Invokes when a successful VPN Connection is made.
 * @param atomConnectionDetails Provides the details of the connection attempt.
 */

- (void)atomManagerDidConnect:(AtomConnectionDetails *)atomConnectionDetails;

/**
 Invokes when a VPN Connection is successfully disconnected.
 Note :
 @param atomConnectionDetails Provides the details of the connection attempt.
 */

- (void)atomManagerDidDisconnect:(AtomConnectionDetails *)atomConnectionDetails;


/*!
 * @method atomManagerDidDisconnect:withConnectionDetails:
 * @discussion Invokes when a VPN Connection is successfully disconnected.
 * @param manuallyDisconnected Identifying if the connection has been cancelled manually. The return value will be YES when using -cancelVPN otherwise the default value will be NO.
 * @param atomConnectionDetails Provides the details of the connection attempt.
 */

- (void)atomManagerDidDisconnect:(BOOL)manuallyDisconnected withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails __attribute__ ((unavailable("Don't use this method, instead use atomManagerDidDisconnect:")));

/*!
 * @method atomManagerOnRedialing:withError:
 * @discussion Invokes whenever ATOM SDK tries to redial automatically in case of a failed connection attempt.
 * @param atomConnectionDetails Provides the details of the connection attempt.
 * @param error Contains the exception occured during the dialing process.
 */
- (void)atomManagerOnRedialing:(AtomConnectionDetails *)atomConnectionDetails withError:(NSError *)error;

/*!
* @method atomManagerDialErrorReceived:withConnectionDetails:
* @discussion Invokes when the ATOM SDK is unable to connect with the provided VPNProperties.
* @param atomConnectionDetails Provides the details of the connection attempt.
* @param error Contains the error occured during dialing.
*/
- (void)atomManagerDialErrorReceived:(NSError *)error withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails;

@optional


/*!
 * @method atomManagerDidConnect
 * @discussion Invokes when a successful VPN Connection is made.
 */
- (void)atomManagerDidConnect __deprecated_msg("Use atomManagerDidConnect: instead.");

/*!
 * @method disconnectVPN:
 * @discussion This function is used to stop the VPN tunnel. The VPN tunnel disconnect process is started and this function returns immediately.
 */
- (void)VPNConnected:(id)sender __deprecated_msg("Use atomManagerDidConnect instead.");

/* -VPNDisconnected:isCancelled
 * @optional
 * @discussion This delegate method will fire when VPN connection is Disconnected. At this point, you can have the VPN disconnected state.
 * @param isCancelled Identifying if the connection has been cancelled manually. The return value will be YES when using -cancelVPNConnection otherwise the default value will be NO.
 */
- (void)VPNDisconnected:(BOOL)isCancelled __deprecated_msg("Use atomManagerDidDisconnect: instead.");

/* -VPNRedialingConnectionDetails:withError
 * @optional
 * @discussion This delegate method will fire when VPN connection is Redialing after unsuccessful connection try. At this point, you can have the VPN Redialing state.
 */
- (void)VPNRedialingConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails withError:(NSError *)error __deprecated_msg("Use atomManagerOnRedialing:withError: instead.");

/* -VPNDialedError:withConnectionDetails
 * @optional
 * @discussion This delegate method will fire when VPN is failed to establish connection. At this point, you can have the VPN connection failed state.
 */
- (void)VPNDialedError:(NSError *)error withConnectionDetails:(AtomConnectionDetails *)atomConnectionDetails __deprecated_msg("Use atomManagerDialErrorReceived:withError: instead.");

@end

/*!
 * @interface AtomManager
 * @discussion The main class used to connect and maintain VPN Connections.
 *
 * Instances of this class are thread safe.
 */

@interface AtomManager : NSObject

/*!
 * @property delegate
 * @discussion A property delegate. Set this property to receive the connection delegates.
 */

@property (nonatomic, weak) id <AtomManagerDelegate> delegate;

/*!
 * @property stateDidChangedHandler
 * @discussion Invokes when the VPNState changed during dialing.
 */
@property (nonatomic, copy) StateDidChangedHandler stateDidChangedHandler;

/*!
 * @property onPacketsTransmitted
 * @discussion Invokes when network packets starts transmitting after VPN connection is made.
 */
@property (nonatomic, copy) OnPacketsTransmitted onPacketsTransmitted;

/*!
 * @property AtomCredential
 * @discussion Gets and Sets the VPN Credentials object to be used in a VPN Connection. It must be provided before calling Connect method or provide UUID alternatively.
 */
@property (nonatomic, strong) AtomCredential *atomCredential;

/*!
 * @property AtomProperties
 * @discussion Gets or sets the AtomProperties which were used for the connection, or null if no connection has been made yet.
 */
@property (nonatomic, strong) AtomProperties *atomProperties;

/*!
 * @property UUID
 * @discussion Gets or Sets a Unique User identifier used to connect to a vpn server if Credentials object is not provided. ATOM SDK will generate VPN Credentials itself when this property is provided. This value will be ignored if Credentials are provided.
 */
@property (nonatomic, strong) NSString* UUID;

/*!
 * @method sharedInstanceWithSecretKey:
 * @discussion Initializes a new instance of the ATOM SDK using a secret key. If the ATOM SDK was initialized previously the same object is returned.
 * @param secretKey The Secret Key provided by ATOM at the time of subscription.
 */
+ (AtomManager *)sharedInstanceWithSecretKey:(NSString *)secretKey;

/*!
 * @method sharedInstanceWithAtomConfiguration:
 * @discussion Initializes a new instance of the ATOM SDK using AtomConfiguration. If the SDK was initialized previously the same object is returned.
 * @param atomConfiguration An AtomConfiguration object which enables the developer to provide the custom configuration. SecretKey is mandatory in any case.
 */
+ (AtomManager *)sharedInstanceWithAtomConfiguration:(AtomConfiguration *)atomConfiguration;

/*!
 @method
 
 @abstract
 Returns the previously instantiated singleton instance of the API.
 
 @discussion
 The API must be initialized with <code>sharedInstanceWithSecretKey:</code> before
 calling this class method.
 */
+ (AtomManager *)sharedInstance;

/*!
 * @method connectWithProperties:completion:errorBlock
 * @discussion Creates a VPN connection.This function is used to start the VPN tunnel using the current VPN configuration after validation of AtomProperties.
 * @param propertiesObject The AtomProperties object used by the ATOM SDK to establish a VPN connection.
 */
- (void)connectWithProperties:(AtomProperties *)propertiesObject completion:(void(^)(NSString* success))successBlock errorBlock:(void(^)(NSError *error))errorBlock;

/*!
 * @method disconnectVPN:
 * @discussion Disconnects existing VPN Connection. If AtomStatus is CONNECTING then use cancelVPN method.
 */
- (void)disconnectVPN;

/*!
 * @method reconnectVPN:
 * @discussion Reconnect to the last connected server. This will cause a dial error if no connection has been made yet.
 */
- (void)reconnectVPN;

/*!
 * @method cancelVPNConnection:
 * @discussion Cancels a VPN connection process if a connection process is already started and not reached to Connected state.
 */
- (void)cancelVPNConnection __deprecated_msg("Use cancelVPN instead.");

/*!
 * @method cancelVPN:
 * @discussion Cancels a VPN connection process if a connection process is already started and not reached to Connected state.
 */
- (void)cancelVPN;

/*!
 * @property getCurrentVPNStatus
 * @discussion Gets the current status of the VPN SDK. Please refer to AtomVPNStatus Enum for the possible values.
 */
- (AtomVPNStatus) getCurrentVPNStatus;

/*!
 * @property getConnectedIP
 * @discussion Gets the VPN IP of the current connected session. Returns empty string in case of disconnected state.
 */
- (NSString*) getConnectedIP;

/*!
 * @property getConnectedTime
 * @discussion Gets the time at which the current VPN connection was established.
 */
- (NSDate*) getConnectedTime;

/*!
 * @property lastDialedHost
 * @discussion The VPN server. Depending on the protocol, may be an IP address or host name. This value will be set to nil if no prior connection has been made.
 */
@property (nonatomic, strong) NSString *lastDialedHost __deprecated_msg("Use atomConnectionDetails instead.");

/*!
 * @property lastDialedHostMethod
 * @discussion The VPN server method. Depending on the protocol, server method through which @lastDialedHost was fetched. This value will be set to nil if no prior connection has been made.
 */
@property (nonatomic, strong) NSString *lastDialedHostMethod __deprecated_msg("Use atomConnectionDetails instead.");

/*!
 * @property lastDialedHostMethod
 * @discussion The VPN server type. Depending on the protocol, server type through which @lastDialedHost was fetched. This value will be set to nil if no prior connection has been made.
 */
@property (nonatomic, strong) NSString *lastDialedHostServerType __deprecated_msg("Use atomConnectionDetails instead.");

/*!
 * @property atomConnectionDetails
 * @discussion Gets the details of the last connection attempt.
 */
@property (nonatomic, strong) AtomConnectionDetails *atomConnectionDetails;

/*!
 * @property isAlwaysOnEnabled
 * @discussion Toggles VPN Always On feature. //-TODO update documentation
 */
@property (nonatomic) BOOL vpnAlwaysOn;

/*!
 * @property domainsArray
 * @discussion An array of web domain objects. e.g: www.<domain_name>.com
 */
@property (nonatomic, strong) NSArray *vpnOnDemandWithDomains;

#pragma mark - Request Inventory Methods

/*!
 * @method getProtocolsWithSuccess:errorBlock
 * @discussion Gets all the Protocols allowed to the reseller by Atom.
 * @param errorBlock If the array of AtomProtocol object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 * @param success Will be called with array of AtomProtocol
 */
- (void)getProtocolsWithSuccess:(void (^)(NSArray <AtomProtocol *> *protocolsList))success
                        errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getCountriesWithSuccess:errorBlock
 * @discussion Gets all the Countries allowed to the reseller by Atom.
 * @param errorBlock  If the array of AtomCountry object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 * @param success Will be called with array of AtomCountry
 */
- (void)getCountriesWithSuccess:(void (^)(NSArray <AtomCountry *> *countriesList))success
                        errorBlock:(void (^)(NSError *error))errorBlock;


/*!
 * @method getCountriesForSmartDialing:errorBlock
 * @discussion Get all the Countries those support advanced mechanism of VPN Dialing on our network. This advanced mechanism of dialing will help in establishing a VPN Tunnel, quicker than the conventional (and recommended) method.
 * @param errorBlock If the array of AtomCountry object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getCountriesForSmartDialing:(void (^)(NSArray <AtomCountry *> *countriesList))success
                     errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getOptimizedCountriesWithSuccess:errorBlock
 * @discussion Gets all the Countries optimized and sorted on the basis of realtime latency w.r.t. user's network conditions allowed to the reseller by Atom.
 * @param errorBlock If the array of AtomCountry object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 * @param success Will be called with array of AtomCountry
 */
- (void)getOptimizedCountriesWithSuccess:(void (^)(NSArray <AtomCountry *> *optimizedCountriesList))success
                                 errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getConnectionDetailsWithSuccess:errorBlock
 * @discussion This function can be used to return the last connected VPN interface details of the current session. AtomConnectionDetails includes the necessary details about the connection information.
 * @param errorBlock If the connectionDetails object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getConnectionDetailsWithSuccess:(void (^)(AtomConnectionDetails *connectionDetails))success
                                errorBlock:(void (^)(NSError *error))errorBlock __deprecated_msg("Use getLastConnectionDetailsWithSuccess instead.");

/*!
 * @method getLastConnectionDetailsWithSuccess:errorBlock
 * @discussion Gets the connection details of the last successful connection made using the provided Credentials or UUID.
 * @param errorBlock when no connection details found for this session or invalid credentials/UUID are provided.
 */
- (void)getLastConnectionDetailsWithSuccess:(void (^)(AtomConnectionDetails *connectionDetails))success
                             errorBlock:(void (^)(NSError *error))errorBlock;

#pragma mark - Install VPN Profile

/*!
 * @method installVPNProfileWithCompletion:errorBlock
 * @discussion This function is used to install the VPN profile. VPN profile is used to establish the VPN connections.
 * @param errorBlock If the successBlock is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)installVPNProfileWithCompletion:(void(^)(NSString* success))successBlock errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - On Demand VPN Method

/*!
 * @method updateOnDemandVpnStatusWithCompletion:errorBlock
 * @discussion This function is used to update and apply the On Demand VPN status of the VPN profile. On Demand VPN is used to establish the VPN connections based on the rules specified through @isOnDemandVpnEnabled, @isAlwaysOnEnabled, @isDomainEnabled, or @domainsArray properties.
 * @param errorBlock If the successBlock is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)updateOnDemandVpnStatusWithCompletion:(void(^)(NSString* success))successBlock errorBlock:(void(^)(NSError *error))errorBlock;

@end
