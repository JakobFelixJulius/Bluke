//
//  statusMenuController.swift
//  Bluke
//
//  Created by JSudau on 12.11.18.
//  Copyright © 2018 jfjs. All rights reserved.
//

import Cocoa
import IOBluetooth
import HotKey
import Carbon

struct BluetoothDevice {
	var name: String
	var device: IOBluetoothDevice
	var isSelected: Bool
}

class StatusMenuController: NSObject {
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var devicesMenu: NSMenu!
	
	var activated: Bool! = false
	var bluetoothDevices = [BluetoothDevice]()
	let statusItem = NSStatusBar.system.statusItem(withLength: -1)
	
	private var hotKey: HotKey? {
		didSet {
			guard let hotKey = hotKey else {
				print("error")
				return
			}
			
			hotKey.keyDownHandler = { [weak self] in
				self?.activateHelper()
			}
		}
	}
	
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(self)
	}
	
	@IBAction func activateClicked(_ sender: NSMenuItem) {
		activateHelper()
		print("activate clicked")
		sender.title = activated ? "Deactivate" : "Activate"
	}
	
	
	override func awakeFromNib() {
		// create & display menubar icon
//		let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
//		icon?.isTemplate = true // best for dark mode
//		statusItem.image = icon
		statusItem.title = "☖"
		
		// create action for left & right click
		if let button = statusItem.button {
			button.target = self
			button.action = #selector(self.statusBarButtonClicked(sender:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}
		
		// populate devices submenu
		updateBluetoothDevices()
		
		// Setup hot key for ⌥⌘R
		hotKey = HotKey(key: .r, modifiers: [.command, .option])
	}
	
	func updateBluetoothDevices() {
		bluetoothDevices.removeAll()
		
		print("Bluetooth devices:")
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
					let item = NSMenuItem(title: "\(device.name!)", action: #selector(deviceClicked), keyEquivalent: "")
					item.state = savedSelection ? .on : .off
					item.target = devicesMenu
					item.target = self
					devicesMenu.addItem(item)
				}
				
				print("Name: \(device.name)")
				print("Paired?: \(device.isPaired())")
				print("Connected?: \(device.isConnected())")
			}
		}
	}
	
	@objc func statusBarButtonClicked(sender: NSStatusBarButton) {
		let event = NSApp.currentEvent!
		
		if event.type == NSEvent.EventType.rightMouseUp {
			
			statusItem.menu = statusMenu
			statusItem.popUpMenu(statusMenu)
			
			// This is critical, otherwise clicks won't be processed again
			statusItem.menu = nil
			print("right click")
		} else {
			print("left click")
			activateHelper()
		}
	}
	
	func activateHelper() {
		activated = !activated
		statusItem.title = activated ? "☗" : "☖"
		activateBluetoothDevices()
	}
	
	func activateBluetoothDevices() {
		if activated {
			for item in bluetoothDevices {
				if item.isSelected {
					DispatchQueue.main.async {
						item.device.openConnection()
					}
				}
			}
		} else {
			for item in bluetoothDevices {
				if item.isSelected {
					DispatchQueue.main.async {
						item.device.closeConnection()
					}
				}
			}
		}
	}
	
	@objc func deviceClicked(sender: NSMenuItem) {
		sender.state = (sender.state == .on) ? .off : .on
		let index = bluetoothDevices.index(where: {$0.name == sender.title})
		bluetoothDevices[index!].isSelected = !bluetoothDevices[index!].isSelected
		UserDefaults().set(bluetoothDevices[index!].isSelected, forKey: bluetoothDevices[index!].name)
	}
}














