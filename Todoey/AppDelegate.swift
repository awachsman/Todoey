//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // For  diagnostic and informational purposes, print the location of Realm as it exists in the app
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        /*
         Iteration 1 - For test purposes, create a new data object of class Data() - add test variables
         
         let data = Data()
         data.name = "Abe"
         data.age = 50
         
         //Create a new constant from the Realm class
         do {
            let realm = try Realm()
                try realm.write() {
                    realm.add(data)
                }
            } catch {
                print("Error initializaing new realm, \(error)")
            }
                 
            return true
         */
        
        //Create a new constant from the Realm class
        do {
            let realm = try Realm()
        } catch {
            print("Error initializaing new realm, \(error)")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*NSPersistentContainer is a SQLLite  database by default, although others may be used as well.  This is the database that we'll be saving our items to
        Code was copied from CoreDataTestApp, so the name below was was changed from CoredataTestApp to match our model, i.e. "DataModel"
 */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        
        /* A context is a scratchpad where you can update, edit and otherwise modify data until you're happy with it before committing it to permanent storage.
         
         */
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

