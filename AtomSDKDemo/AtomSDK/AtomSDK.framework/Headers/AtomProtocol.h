//
//  Protocol.h
//  Sdk Travelee
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomProtocol
 * @discussion The AtomProtocol class declares the programmatic interface of an object that manages the protocol-specific portion of a VPN configuration.
 *
 * AtomProtocol is an abstract base class from which other protocol-specific classes are derived.
 */
@interface AtomProtocol : NSObject

/*!
 * @property protocolId
 * @discussion The protocol id. Depending on the protocol.
 */
@property (nonatomic) int protocolId;

/*!
 * @property name
 * @discussion The protocol name. Depending on the protocol.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property number
 * @discussion The protocol number. Depending on the protocol.
 */
@property (nonatomic) int number;

@end
