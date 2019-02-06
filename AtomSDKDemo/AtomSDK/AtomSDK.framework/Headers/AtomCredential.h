//
//  AtomCredential.h
//  AtomSDKFramework
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCredential
 * @discussion Represents the network credentials used to authenticate to the VPN server.
 */
@interface AtomCredential : NSObject

/*!
 * @property username
 * @discussion Gets or sets the username used to authenticate to the VPN server.
 */
@property (nonatomic, strong) NSString *username;

/*!
 * @property password
 * @discussion Gets or sets the password used to authenticate to the VPN server.
 */
@property (nonatomic, strong) NSString *password;

/*!
 * @method initWithUsername:password:
 * @discussion Creates a AtomCredential object with a username and a password.
 * @param username The username component of the VPN authentication credential.
 * @param password The password component of the VPN authentication credential.
 */
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

@end
