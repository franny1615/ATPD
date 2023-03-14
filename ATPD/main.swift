//
//  main.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import UIKit

let appDelegate: AnyClass = NSClassFromString("FakeAppDelegate") ?? AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegate))
