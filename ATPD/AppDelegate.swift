//
//  AppDelegate.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import CoreData
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ATPD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                #if DEBUG
                print("❗️\(error.domain) : \(error.localizedDescription)")
                #endif
            }
        })
        return container
    }()
    
    private var projectViewModel: ProjectViewModel!
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - CoreData
extension AppDelegate {
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                #if DEBUG
                print("❗️\(error.domain) : \(error.localizedDescription)")
                #endif
            }
        }
    }
}

// MARK: - UISceneDelegate
extension AppDelegate: UISceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        projectViewModel = .init()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: ProjectView(viewmodel: projectViewModel))
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveContext()
    }
}

