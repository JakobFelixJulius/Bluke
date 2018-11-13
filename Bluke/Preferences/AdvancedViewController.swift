//
//  AdvancedViewController.swift
//  Bluke
//
//  Created by Jakob Sudau on 14.11.18.
//  Copyright © 2018 jfjs. All rights reserved.
//

import Cocoa
import IOBluetooth

class AdvancedViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var bluetoothDevices = [BluetoothDevice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the size for each view
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        updateBluetoothDevices()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title with the active TabView Title
        self.parent?.view.window?.title = self.title!
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bluetoothDevices.count
    }
    
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        return nil
//    }
    
    func updateBluetoothDevices() {
        bluetoothDevices.removeAll()
        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return
        }
        
        for item in devices {
            if let device = item as? IOBluetoothDevice {
                if (device.name != nil) {
                    
                    var savedSelection = false
                    savedSelection = UserDefaults.standard.bool(forKey: device.name!)
                    bluetoothDevices.append(BluetoothDevice(name: device.name!, device: device, isSelected: savedSelection))
                }
            }
        }
    }
    
}
