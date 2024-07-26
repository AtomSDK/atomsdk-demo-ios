//
//  PacketTunnelProvider.swift
//  PacketTunnelOpenVPNiOS
//
//  Created by Syed Faizan Ahmed on 25/07/2024.
//  Copyright © 2024 Abdul Basit. All rights reserved.
//

import NetworkExtension
import AtomSDKTunnel

class PacketTunnelProvider: AtomPacketTunnelProvider {
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        super.startTunnel(options: options, completionHandler: completionHandler)
    }
}
