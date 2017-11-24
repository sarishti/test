//
//  StayDreamSingleton.swift
//  StayDream
//
//  Created by Sharisti on 30/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location: CLLocation)
}

final class StayDreamSingleton: NSObject, CLLocationManagerDelegate {
   static let sharedInstance = StayDreamSingleton()
       var locationManager: CLLocationManager?

    var currentLocation: CLLocation?

    var delegate: LocationUpdateProtocol!

    private override init() {
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager?.requestAlwaysAuthorization()
        self.locationManager?.startUpdatingLocation()

    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation
        let userInfo: NSDictionary = ["location": currentLocation!]

//        DispatchQueue.main.async() { () -> Void in
//            self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
//        NotificationCenterNotificationCenter.defaultCenter().postNotificationName(kLocationDidChangeNotification, object: self, userInfo: userInfo as [NSObject : AnyObject])
//        }
    }

}
