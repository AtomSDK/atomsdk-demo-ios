//
//  AtomConnectionDetails.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomConnectionDetails
 * @discussion The AtomConnectionDetails class declares the programmatic interface of an object that manages the connection specific details of the last connected vpn configuration of the session. This class will be handy in resolving details related to recently established connection.
 */
@interface AtomConnectionDetails : NSObject

/*!
 * @property username
 * @discussion The username component of the VPN authentication credential used to establish the connection. The username will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *username;

/*!
 * @property bandwidth
 * @discussion The bandwidth is used to represent the last connected VPN connection. The bandwidth will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *bandwidth;

/*!
 * @property session_duration
 * @discussion The session_duration is used to represent the time duration of the last connected VPN connection. The session_duration will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *session_duration;

/*!
 * @property country
 * @discussion The country component of the VPN configuration, representing where the last connected VPN connection was made. The country will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *country;

/*!
 * @property protocol_no
 * @discussion The protocol_no component of the VPN configuration, representing the last used connected VPN interface. The protocol_no will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *protocol_no __deprecated_msg("no longer supported.");

/*!
 * @property ip_address
 * @discussion The ip_address is used to represent the ip of the last connected VPN connection. The ip_address will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *ip_address;

/*!
 * @property device_type
 * @discussion The device_type is used to represent on which device the last connected VPN connection was made. The device_type will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *device_type;

/*!
 * @property serverAddress
 * @discussion A string identifying the host address at which the VPN connection is established. The serverAddress will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString *serverAddress;

/*!
 * @property speedTestMethod
 * @discussion A string identifying the method from which the host address is found. The speedTestMethod will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString* speedTestMethod;

/*!
 * @property serverType
 * @discussion A string identifying the type of the host address. The serverType will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) NSString* serverType;

/*!
 * @property atomProtocol
 * @discussion An object identifying the protocol details. The atomProtocol object will be nil if not set, non-nil otherwise
 */
@property (nonatomic, strong) AtomProtocol* atomProtocol;



@end
