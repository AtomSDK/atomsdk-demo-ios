//
//  AtomConnectionDetails.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomConnectionDetails
 * @discussion The AtomConnectionDetails class manages the connection specific details of the last connection vpn configuration of the session.This class will also be handy in resolving details related to recently dialed connection.
 */
@interface AtomConnectionDetails : NSObject

/*!
 * @property username
 * @discussion The username with which last connection was made.
 */
@property (nonatomic, strong) NSString *username;

/*!
 * @property bandwidth
 * @discussion The bandwidth consumed in the last session.
 */
@property (nonatomic, strong) NSString *bandwidth;

/*!
 * @property sessionDuration
 * @discussion The duration of last session in minutes.
 */
@property (nonatomic, strong) NSString *sessionDuration;

/*!
 * @property country
 * @discussion The name of the country to which the last connection was made.
 */
@property (nonatomic, strong) NSString *country;

/*!
 * @property ipAddress
 * @discussion The IP address assigned in last VPN connection.
 */
@property (nonatomic, strong) NSString *ipAddress;

/*!
 * @property deviceType
 * @discussion The device type is used to represent the device/platform on which the last connected VPN connection was made.
 */
@property (nonatomic, strong) NSString *deviceType;

/*!
 * @property serverAddress
 * @discussion The host address at which the VPN connection was established.
 */
@property (nonatomic, strong) NSString *serverAddress;

/*!
 * @property fastestServerFindingMethod
 * @discussion The method used to find servers for the last VPN connection.
 */
@property (nonatomic, strong) NSString* fastestServerFindingMethod;

/*!
 * @property serverType
 * @discussion Representing the type of server host with which the VPN connection was made.
 */
@property (nonatomic, strong) NSString* serverType;

/*!
 * @property protocol
 * @discussion The Protocol of the VPN configuration with which last VPN connection was made.
 */
@property (nonatomic, strong) AtomProtocol* protocol;

/*!
 * @property timeTakenToFindSpeedTest
 * @discussion The time taken to find fastest server before starting connection to a server.
 */
@property (nonatomic) int timeTakenToFindFastestServer;

/*!
 * @property totalTimeTakenToConnect
 * @discussion The total time taken to connect successfully in seconds.
 */
@property (nonatomic) int totalTimeTakenToConnect;

/*!
 * @property fastestServerFindingApiResponse
 * @discussion The response of Fastest Server API.
 */
@property (nonatomic, strong) NSMutableDictionary* fastestServerFindingApiResponse;

/*!
 * @property connectionMethod
 * @discussion The connection method type used to dialed VPN using ATOM SDK (Params, PSK, Manual)
 */
@property (nonatomic, strong) NSString* connectionMethod;

/*!
 * @property serverIp
 * @discussion The IP address of the server with which VPN Connection is establish.
 */
@property (nonatomic, strong) NSString* serverIp;


/*!
 * @property isDisconnectedManually
 * @discussion Returns true if VPN Connection was disconnected by user otherwise false.
 */
@property (nonatomic) BOOL isDisconnectedManually;


/*!
 * @property connectionAttempts
 * @discussion The connection attempt tried to establish VPN Connection.
 */
@property (nonatomic) int connectionAttempts;

/*!
 * @property isCancelled
 * @discussion Returns true if VPN Connection was cancelled before Connection is made successfully otherwise false.
 */
@property (nonatomic) BOOL isCancelled;

/*!
 * @property isDialedWithSmartDialing
 * @discussion Returns true if VPN Connection was dialed with Smart Dialing otherwise false.
 */
@property (nonatomic) BOOL isDialedWithSmartDialing;

/*!
 * @property isDialedWithOptimization
 * @discussion Returns true if VPN Connection was dialed with Optimization otherwise false
 */
@property (nonatomic) BOOL isDialedWithOptimization;

@end
