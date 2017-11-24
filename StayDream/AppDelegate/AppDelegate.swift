//
//  AppDelegate.swift
//  StayDream
//
//  Created by Sharisti on 05/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import AWSS3
import GoogleMaps
import Fabric
import Crashlytics
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AccessTokenAPI, LocationServiceDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppUtility.showLoader(isOffSet: true)
        // Override point for customization after application launch.
      AppUtility.removeKeyChainValues()
        checkToCallkeyTokenService()
        // IQKeybaord
        self.setKeyBoardManager()
        // location manager
        self.setLocationManager()
        // s3 bucket
        self.setS3Bucket()
        //Google
        GMSServices.provideAPIKey(Configuration.googleMapsAPIKey())
        GMSPlacesClient.provideAPIKey(Configuration.placesClientKey())
        // fabric
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if checkLocationServiceEnabled() {
            //location service call
            self.loadLocationIntalization()
        } else {
            //location service not call
        }

    }
    func loadLocationIntalization() {
        // Do any additional setup after loading the view.
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    // check location sevrice enaled
    func checkLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    /// use to tracing the location
    ///
    /// - Parameters:
    ///   - currentLocation: cuurrent location
    ///   - address: address
    ///   - city: city description
    ///   - state: state
    func tracingLocation(_ currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
    }

    /// use to trace the location
    ///
    /// - Parameter error: error
    func tracingLocationDidFailWithError(_ error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: Custom Function
    func setKeyBoardManager() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    // MARK: Location manager
    func setLocationManager() {
        LocationService.sharedInstance.startUpdatingLocation()
         AppUtility.delay(5.0) {
            LocationService.sharedInstance.stopUpdatingLocation()
        }

    }

    // MARK: App Token service

    // Check keychain to call token service
    func checkToCallkeyTokenService() {
        if KeychainWrapper.standard.object(forKey: AppConstants.appTokenKeyChain) == nil {
            self.callAppTokenService()
        } else {
            if let tokenObj = KeychainWrapper.standard.object(forKey: AppConstants.appTokenKeyChain) {
                if let appTokenObj = tokenObj as? AccessToken, let token = appTokenObj.accessToken {
                    print("From keychain get Access Token \(token)")
                    Configuration.customHeaders["Authorization"] = "Bearer \(token)"
                    if let userToken = UserUtility.getUserToken() {
                        Configuration.customHeaders["Authorization"] = "Bearer \(userToken)"
                        print("User token:  \(userToken)")
                    }
                }
            }
        }
    }

    /// Get app token service with predefined user name and password for resource security on backend
    func callAppTokenService() {
        self.getToken(withHandler: { (appTokenObj) in
            if let appToken = appTokenObj {
                /// Set APP Token In Key Chain
                if let accessToken = appToken.accessToken {
                    let isKeySave = KeychainWrapper.standard.set(appToken, forKey: AppConstants.appTokenKeyChain)
                    print("Key save in key chain \(isKeySave)")
                    Configuration.customHeaders["Authorization"] = "Bearer \(accessToken)"
                    print("Apptoken: \(accessToken)")
                }
           } else {
                 self.callAppTokenService()
            }

        })

    }
    // MARK: S3 Bucket Setup

    /// Set s3 bucket credentials
    func setS3Bucket() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                                identityPoolId:Configuration.s3PoolId())

        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

    }

}
