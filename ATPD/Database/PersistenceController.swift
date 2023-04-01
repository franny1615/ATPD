//
//  PersistenceController.swift
//  ATPD
//
//  Created by Francisco F on 3/25/23.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ATPD")
        
        container.loadPersistentStores { storeDescription, error in
            #if DEBUG
            let error = error as? NSError
            print("❗️\(error?.domain ?? "DOMAIN") : \(error?.localizedDescription ?? "")")
            #endif
        }
    }
}
