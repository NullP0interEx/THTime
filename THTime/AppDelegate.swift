//
//  AppDelegate.swift
//  THTime
//
//  Created by Roman Kobosil on 11.10.16.
//  Copyright © 2016 Roman Kobosil. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
       
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

