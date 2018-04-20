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
 * @method atomManagerDidConnect
 * @discussion Invokes when a successful VPN Connection is made.
 */
- (void)atomManagerDidConnect;

/*!
 * @method atomManagerDidDisconnect:
 * @discussion Invokes when a VPN Connection is successfully disconnected.
 * @param manuallyDisconnected Identifying if the connection has been cancelled manually. The return value will be YES when using -cancelVPN otherwise the default value will be NO.
 */
- (void)atomManagerDidDisconnect:(BOOL)manuallyDisconnected;

/*!
 * @method atomManagerOnRedialing:withError:
 * @discussion Invokes whenever ATOM SDK tries to redial automatically in case of a failed connection attempt.
 * @param atomConnectionDetails Provides the details of the connection attempt.
 * @param error Contains the error occured during dialing.
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
 * @method disconnectVPN:
 * @discussion This function is used to stop the VPN tunnel. The VPN tunnel disconnect process is started and this function returns immediately.
 */
- (void)VPNConnected:(id)sender __deprecated_msg("Use atomManagerDidConnect: instead.");

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
 * @discussion The AtomManager class is used to initialize the secret key. The AtomManager class declares the programmatic interface for an object that manages VPN connections. This class can also be used for getting countries, ping based optimized countries, and protocols.
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
 * @discussion Invokes when Connection State is changed during dialing.
 */
@property (nonatomic, copy) StateDidChangedHandler stateDidChangedHandler;

/*!
 * @property onPacketsTransmitted
 * @discussion Invokes when network packets starts transmitting after VPN connection is made.
 */
@property (nonatomic, copy) OnPacketsTransmitted onPacketsTransmitted;

/*!
 * @property AtomCredential
 * @discussion Sets the VPN Credentials object to be used in a VPN Connection. It must be provided before calling -connectWithProperties:completion:errorBlock method or provide UUID alternatively.
 */
@property (nonatomic, strong) AtomCredential *atomCredential;

/*!
 * @property AtomProperties
 * @discussion The AtomProperties class contains all the preferences required by the ATOM SDK to establish VPN connection.
 */
@property (nonatomic, strong) AtomProperties *atomProperties;

/*!
 * @property UUID
 * @discussion Gets or Sets a Unique User identifier used to connect to a vpn server if Credentials object is not provided. ATOM SDK will generate a VPN account itself when this property is provided. This value will be ignored if Credentials are provided.
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
 * @discussion Initializes a new instance of the ATOM SDK using AtomConfiguration. If the ATOM SDK was initialized previously the same object is returned.
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
 * @discussion Creates a VPN Connection.
 * @param propertiesObject The VPNProperties object used by the SDK to establish a VPN connection.
 */
- (void)connectWithProperties:(AtomProperties *)propertiesObject completion:(void(^)(NSString* success))successBlock errorBlock:(void(^)(NSError *error))errorBlock;

/*!
 * @method disconnectVPN:
 * @discussion Disconnects a VPN Connection.
 */
- (void)disconnectVPN;

/*!
 * @method reconnectVPN:
 * @discussion Reconnect to the last connected server. This will cause a dial error if no connection has been made yet.
 */
- (void)reconnectVPN;

/*!
 * @method cancelVPNConnection:
 * @discussion This function is used to cancel the ongoing VPN connection process. The VPN tunnel connection process is cancelled and this function returns immediately.
 */
- (void)cancelVPNConnection __deprecated_msg("Use cancelVPN instead.");

/*!
 * @method cancelVPN:
 * @discussion Cancels a VPN Connection process if a connection process is already started and not reached to Connected state.
 */
- (void)cancelVPN;

/*!
 * @property getCurrentVPNStatus
 * @discussion Gets the current status of the VPN SDK. Please refer to AtomVPNStatus in AtomStatus.h for the possible values.
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
 * @discussion An AtomConnectionDetails object containing the last dialed connection details.
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
 * @discussion Gets all the Protocols allowed to this reseller by Atom.
 * @param errorBlock If the protocolsList object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getProtocolsWithSuccess:(void (^)(NSArray <AtomProtocol *> *protocolsList))success
                        errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getCountriesWithSuccess:errorBlock
 * @discussion Gets all the Countries allowed to this reseller by Atom.
 * @param errorBlock If the countriesList object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getCountriesWithSuccess:(void (^)(NSArray <AtomCountry *> *countriesList))success
                        errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getOptimizedCountriesWithSuccess:errorBlock
 * @discussion Ping the available datacenters and returns the countries with the current latency mapped to Models.Country.Latency.
 Gets all the Optimized Countries allowed to this reseller by Atom. Latency in AtomCountry object will be set to the pinged value.
 * @param errorBlock If the optimizedCountriesList object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getOptimizedCountriesWithSuccess:(void (^)(NSArray <AtomCountry *> *optimizedCountriesList))success
                                 errorBlock:(void (^)(NSError *error))errorBlock;

/*!
 * @method getConnectionDetailsWithSuccess:errorBlock
 * @discussion This function can be used to return the last connected VPN interface details of the current session. AtomConnectionDetails includes the necessary details about the connection information.
 * @param errorBlock If the connectionDetails object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
 */
- (void)getConnectionDetailsWithSuccess:(void (^)(AtomConnectionDetails *connectionDetails))success
                                errorBlock:(void (^)(NSError *error))errorBlock; __deprecated_msg("Use getLastConnectionDetailsWithSuccess instead.");

/*!
 * @method getLastConnectionDetailsWithSuccess:errorBlock
 * @discussion Gets the connection details of the last successful connection made using the provided Credentials or UUID.
 * @param errorBlock If the connectionDetails object is returned, this parameter is set to nil. Otherwise this parameter is set to the error that occurred.
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
