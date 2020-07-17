//
//  ParticlePeripheral.swift
//  BluetoothTestPet
//
//  Created by Juan Manuel Couso on 16/07/20.
//  Copyright © 2020 WeDevUp. All rights reserved.
//

import Foundation

import UIKit
import CoreBluetooth

class PetparkerPeripheral: NSObject {

    /// MARK: - Particle LED services and charcteristics Identifiers

    public static let petparkerServiceUUID     = CBUUID.init(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    public static let petparkerCharacteristicUUID   = CBUUID.init(string: "fd758b93-0bfa-4c52-8af0-85845a74a606")


}
