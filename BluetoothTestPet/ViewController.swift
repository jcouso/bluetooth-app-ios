//
//  ViewController.swift
//  BluetoothTestPet
//
//  Created by Juan Manuel Couso on 16/07/20.
//  Copyright © 2020 WeDevUp. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var openHouseChar: CBCharacteristic?

    @IBAction func openHouse(_ sender: Any) {
        print("Opening House")
        
        let data:UInt8 = 8
        let data2:UInt8 = 5
        
        sendCommandToHouse( withCharacteristic: openHouseChar!, withValue: Data([data, data2]))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)

        // Do any additional setup after loading the view.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central state is not power on")
        } else {
            print("Central scanning for", PetparkerPeripheral.petparkerServiceUUID);
            centralManager.scanForPeripherals(withServices: [PetparkerPeripheral.petparkerServiceUUID],  options: [CBCentralManagerScanOptionAllowDuplicatesKey : true ])
        }
    }
        
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        self.centralManager.stopScan()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
    
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected To Device")
            
            peripheral.discoverServices([PetparkerPeripheral.petparkerServiceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == PetparkerPeripheral.petparkerServiceUUID {
                    print("Device Servie found")
                    
                    peripheral.discoverCharacteristics([PetparkerPeripheral.petparkerCharacteristicUUID], for: service)
                    
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == PetparkerPeripheral.petparkerCharacteristicUUID {
                    print("Petparker Caraterict Found")
                    
                    openHouseChar = characteristic
                }
            }
        }
    }
    
    private func sendCommandToHouse( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
             // Check if it has the write property
             if peripheral != nil {

                 peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
             }
         }
}

