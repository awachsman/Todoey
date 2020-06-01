//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // For  diagnostic/informational purposes, print location of Realm as it exists in the app
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        /* Iteration 1 - obsolete - For test purposes, create a new data object of class Data() - add test variables
         
         let data = Data()
         data.name = "Abe"
         data.age = 50
         
          Iteration 2 - obsolete - Create functions related to CoreData including 1) container = NSPersistentContainer(name: "DataModel") which maps to SQLite CoreData 2) comnstants and functions which refer to context
         
         */
        
        // Iteration 3 - Create a new constant from the Realm class
        do {
             _ = try Realm()
        } catch {
            print("Error initializaing new realm, \(error)")
        }
        
        return true
    }

}

