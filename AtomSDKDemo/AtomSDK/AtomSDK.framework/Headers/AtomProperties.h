//
//  AtomProperties.h
//  AtomSDKFramework
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomCountry.h"
#import "AtomProtocol.h"

/*!
 * @interface AtomProperties
 * @discussion The AtomProperties class contains all the preferences required by the ATOM SDK to establish VPN connection.
 */
@interface AtomProperties : NSObject

/*!
 * @property preSharedKey
 * @discussion Sets the PSK property if provided by the developer for this instance of AtomProperties.
 */
@property (nonatomic, strong) NSString *preSharedKey;

/*!
 * @property Country
 * @discussion Sets the AtomCountry object if provided by the developer for this instance of AtomProperties.
 */
@property (nonatomic, strong) AtomCountry *country;

/*!
 * @property Protocol
 * @discussion Sets the AtomProtocol object if provided by the developer for this instance of AtomProperties.
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
 * @discussion Gets the DedicatedHostName property if provided by the developer for this instance of AtomProperties.
 */
@property (nonatomic, strong) NSString *dedicatedHostName;

/*!
 * @property useOptimization
 * @discussion When set to YES, ATOM SDK will use real-time optimization mechanism to connect to your desired Country.
 */
@property (nonatomic) BOOL useOptimization;

/*!
 * @property skipUserVerification
 * @discussion Set this property to YES while dialing through dedicatedHostName if you want to skip user verification process. It is recommended to keep it false to avoid any unauthorized usage of VPN. Default value is NO.
 */
@property (nonatomic) BOOL skipUserVerification;

/*!
 * @method initWithPreSharedKey:protocol:
 * @discussion Initializes a new instance of AtomProperties object with the PSK provided by your backend server. All other properties of this class are ignored by the ATOM SDK when PSK is provided.
 * @param psk The PreShareKey provided by your backend server.
 */
- (instancetype)initWithPreSharedKey:(NSString *)psk;

/*!
 * @method initWithCountry:protocol:
 * @discussion Initializes a new instance of AtomProperties with the AtomCountry and AtomProtocol objects obtained from -getCountriesWithSuccess:errorBlock -getProtocolsWithSuccess:errorBlock methods of AtomManager.
 * @param country A Country to which you need to make the connection on. Countries list can be obtained from -getCountriesWithSuccess:errorBlock method of AtomManager.
 * @param protocol A Protocol with which you need to make the connection. Protocol list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithCountry:(AtomCountry *)country protocol:(AtomProtocol *)protocol;

/*!
 * @method initWithDedicatedHostName:protocol:
 * @discussion Initializes a new instance of AtomProperties with the dedicatedHostName and AtomProtocol object obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 * @param dedicatedHostName The Dedicated Host Name with which you want to make the connection.
 * @param protocol A Protocol with which you need to make the connection. Protocol list can be obtained from -getProtocolsWithSuccess:errorBlock method of AtomManager.
 */
- (instancetype)initWithDedicatedHostName:(NSString *)dedicatedHostName protocol:(AtomProtocol *)protocol;

@end
