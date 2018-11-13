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
	
	var preferencesController: NSWindowController?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	@IBAction func showPreferences(_ sender: Any) {
		
		if !(preferencesController != nil) {
			let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Preferences"), bundle: nil)
			preferencesController = storyboard.instantiateInitialController() as? NSWindowController
		}
		
		if (preferencesController != nil) {
			preferencesController!.showWindow(sender)
		}
	}
}

