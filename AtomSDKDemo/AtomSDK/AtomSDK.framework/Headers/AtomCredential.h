//
//  AtomCredential.h
//  AtomSDKFramework
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCredential
 * @discussion The AtomCredential class declares the programmatic interface of an object that manages credential part of a VPN configuration.
 */
@interface AtomCredential : NSObject

/*!
 * @property username
 * @discussion The username component of the VPN authentication credential.
 */
@property (nonatomic, strong) NSString *username;

/*!
 * @property password
 * @discussion The password component of the VPN authentication credential.
 */
@property (nonatomic, strong) NSString *password;

/*!
 * @method initWithUsername:password:
 * @discussion Initializes a newly-allocated AtomCredential object.
 * @param username The username component of the VPN authentication credential.
 * @param password The password component of the VPN authentication credential.
 */
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

@end
