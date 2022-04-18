//
//  predictiveairportpickupApp.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 3/29/22.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import AWSCognitoAuthPlugin

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let models = AmplifyModels()
        let apiPlugin = AWSAPIPlugin(modelRegistration: models)
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
        let cognitoAuthPlugin = AWSCognitoAuthPlugin()
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: cognitoAuthPlugin)
            try Amplify.configure()
            print("Initialized Amplify with auth, datastore and api plugins")
        } catch {
            assert(false, "Could not init Amplify: \(error)")
        }
        return true
    }
}

@main
struct predictiveairportpickupApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
