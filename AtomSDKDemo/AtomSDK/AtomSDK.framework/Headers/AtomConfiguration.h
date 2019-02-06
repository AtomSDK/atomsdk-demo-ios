//
//  AtomConfiguration.h
//  AtomSDK
//
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomConfiguration
 * @discussion Represents a set of properties which contains the configuration settings to initialize the sdk.
 */
@interface AtomConfiguration : NSObject

/*!
 * @property secretKey
 * @discussion The Secret Key provided by ATOM at the time of subscription.
 */
@property (nonatomic, strong) NSString *secretKey;

/*!
 * @property baseUrl
 * @discussion The base Url of all the requests to be made by the ATOM SDK. It is optional and can be managed through ATOM Console.
 */
@property (nonatomic, strong) NSURL *baseUrl;

/*!
 * @property vpnInterfaceName
 * @discussion Name of the VPN adapter to be displayed.
 */
@property (nonatomic, strong) NSString *vpnInterfaceName;

@end
