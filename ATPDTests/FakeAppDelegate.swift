//
//  FakeAppDelegate.swift
//  ATPDTests
//
//  Created by Francisco F on 3/13/23.
//

import UIKit

@objc(FakeAppDelegate)
class FakeAppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("ℹ️ >>> FAKE AppDelegate")
        return true
    }
}
