//
//  Protocol.h
//  Atom SDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomProtocol
 * @discussion Represents a Network protocol used to create a VPN tunnel.
 */
@interface AtomProtocol : NSObject

/*!
 * @property protocolId
 * @discussion Gets or sets the integer id of the protocol.
 */
@property (nonatomic) int protocolId;

/*!
 * @property name
 * @discussion Gets or sets the name the protocol.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property number
 * @discussion The protocol number. Depending on the protocol.
 */
@property (nonatomic) int number;

/*!
 * @property dns
 * @discussion The dns. Depending on the protocol.
 */
@property (nonatomic, strong) NSArray *dns;

/*!
 * @property protocolSwitch
 * @discussion The protocolSwitch. Depending on the protocol.
 */
@property (nonatomic, strong) NSArray *protocolSwitch;

@end
