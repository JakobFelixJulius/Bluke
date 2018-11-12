//
//  AppDelegate.swift
//  Bluke
//
//  Created by JSudau on 12.11.18.
//  Copyright © 2018 jfjs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	@IBAction func showPreferencesWindow(_ sender: Any) {
		print("showing preferences...")
	}
}

