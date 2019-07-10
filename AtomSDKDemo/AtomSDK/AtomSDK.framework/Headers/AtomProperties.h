//
//  AtomProperties.h
//  AtomSDKFramework
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomCountry.h"
#import "AtomProtocol.h"
#import "AtomChannel.h"
#import "AtomCity.h"
/*!
 * @interface AtomProperties
 * @discussion Contains all the properties required by the ATOM SDK to establish VPN connection.
 */
@interface AtomProperties : NSObject

/*!
 * @property preSharedKey
 * @discussion Gets the PSK property if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong) NSString *preSharedKey;

/*!
 * @property Country
 * @discussion Gets the Country object if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong,readonly) AtomCountry *country;

/*!
 * @property Channel
 * @discussion Gets the Channel object if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong,readonly) AtomChannel *channel;

/*!
 * @property City
 * @discussion Gets the City object if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong,readonly) AtomCity *city;

/*!
 * @property Protocol
 * @discussion Gets the Protocol object if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong) AtomProtocol *protocol;

/*!
 * @property Protocol
 * @discussion Set this property to make ATOM SDK dial automatically to this protocol if Primary Protocol fails to connect.
 */
@property (nonatomic, strong) AtomProtocol *secondaryProtocol;

/*!
 * @property Protocol
 * @discussion Set this property to make ATOM SDK dial automatically to this protocol if Primary and Secondary Protocol fails to connect.
 */
@property (nonatomic, strong) AtomProtocol *tertiaryProtocol;


/*!
 * @property dedicatedHostName
 * @discussion Gets the DedicatedHostName property if provided by the developer for the instance of AtomProperties.
 */
@property (nonatomic, strong) NSString *dedicatedHostName;

/*!
 * @property customConfiguration
 * @discussion Gets the configuration property if provided by the developer for the instance of AtomProperties. For TCP/UDP protocol only.
 */
@property (nonatomic, strong) NSString *configuration;

/*!
 * @property useOptimization
 * @discussion When set to True, ATOM SDK will use real-time optimization mechanism to connect to your desired Country.
 */
@property (nonatomic) BOOL useOptimization;


/*!
 * @property useSmartConnect
 * @discussion Set this property to TRUE for countries that supports advanced mechanism of VPN Dialing on our network. This method of dialing will help in establishing a VPN Tunnel, quicker than the conventional (and recommended) method.
 
 How to get countries those support advanced mechanism of VPN Dialing?
 To get the list of countries those support advanced dialing mechanism use SDK method getCountriesForSmartDialing.
 
 Important:
 1. Setting this Parameter to TRUE, will override UseOptimized (if used). This means that UsedOptimization and UseSmartDialing cannot work together and overrides each other properties.
 
 2. This mechanism only works with countries those supports advanced dialing mechanism, this means, this property can only be used when VPNProperties is being initialized with Country and Protocol.
 */
@property (nonatomic) BOOL useSmartDialing;

/**
 Initializes a new instance of AtomProperties object with the PSK provided by your backend server. All other properties of this class are ignored by the ATOM SDK when PSK is provided.

 @param  psk : The Pre-shared Key provided by your backend server.
 */
- (instancetype)initWithPreSharedKey:(NSString *)psk;


/**
 Initializes a new instance of AtomProperties with a AtomCountry and AtomProtocol object obtained from -getCountriesWithSuccess:errorBlock and -getProtocolsWithSuccess:errorBlock methods of AtomManager.

 @param country The Country to which you need to make the connection on. Countries list can be obtained from -getCountriesWithSuccess:errorBlock method of AtomManager.
 @param protocol The Protocol with which you need to make the connection. Protocols list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithCountry:(AtomCountry *)country protocol:(AtomProtocol *)protocol;

/**
 Initializes a new instance of AtomProperties with a AtomChannel and AtomProtocol object obtained from -getProtocolsWithSuccess:errorBlock methods of AtomManager.
 
 @param channel The Channel to which you need to make the connection on.
 @param protocol The Protocol with which you need to make the connection. Protocols list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithChannel:(AtomChannel *)channel protocol:(AtomProtocol *)protocol;

/**
 Initializes a new instance of AtomProperties with a AtomCity and AtomProtocol object obtained from -getProtocolsWithSuccess:errorBlock methods of AtomManager.
 
 @param country The Country to which you need to make the connection on. Countries list can be obtained from -getCountriesWithSuccess:errorBlock method of AtomManager.
 @param city The city to which you need to make the connection on.
 @param protocol The Protocol with which you need to make the connection. Protocols list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithCountry:(AtomCountry *)country andCity:(AtomCity *)city andProtocol:(AtomProtocol *)protocol;


/**
 Initializes a new instance of AtomProperties with a dedicatedHostName and the AtomProtocol object obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.

 @param dedicatedHostName The Dedicated Host Name with which you want to make the connection.This should be a valid hostname or IP Address, Dial error with a validation exception will be thrown otherwise.
 @param protocol The Protocol with which you need to make the connection. Protocols list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithDedicatedHostName:(NSString *)dedicatedHostName protocol:(AtomProtocol *)protocol;

/**
 Initializes a new instance of AtomProperties with a dedicatedHostName and the AtomProtocol object obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 
 @param dedicatedHostName The Dedicated Host Name with which you want to make the connection.This should be a valid hostname or IP Address, Dial error with a validation exception will be thrown otherwise.
 @param protocol The Protocol with which you need to make the connection. Protocols list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 @param configuration Specify configuration while dialing using (For TCP & UDP Protocols only).
 
 */
- (instancetype)initWithDedicatedHostName:(NSString *)dedicatedHostName protocol:(AtomProtocol *)protocol customConfig:(NSString *)configuration;



@end
