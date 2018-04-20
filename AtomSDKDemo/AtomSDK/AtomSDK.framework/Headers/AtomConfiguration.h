//
//  AtomConfiguration.h
//  AtomSDK
//
//  Created by M. Hassan Ali on 4/3/18.
//  Copyright © 2018 Hassan. All rights reserved.
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
 * @discussion The base Url of all the requests to be made by the ATOM SDK. It is optional and can be managed through ATOM Admin Panel.
 */
@property (nonatomic, strong) NSURL *baseUrl;

/*!
 * @property vpnInterfaceName
 * @discussion Name of the VPN profile to be displayed under device Settings > VPN.
 */
@property (nonatomic, strong) NSString *vpnInterfaceName;

@end
