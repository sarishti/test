//
//  LocationService.swift
//
//
//  Created by Anak Mirasing on 5/18/2558 BE.
//
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_ error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    static let sharedInstance: LocationService = { LocationService() }()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }

        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }

    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startMonitoringSignificantLocationChanges()
        self.locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.pausesLocationUpdatesAutomatically = true
        self.locationManager?.stopMonitoringSignificantLocationChanges()
        self.locationManager?.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }

        // singleton for get last(current) location
        self.currentLocation = location

        // use for real time update location
        updateLocation(currentLocation: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            // do on error
            self.updateLocationDidFailWithError(error: error as NSError)
        }

    }

    // Private function
    private func updateLocation(currentLocation: CLLocation) {
        DispatchQueue.main.async {
          self.findlocationAddress(currentLocation)
        }

    }
    func findlocationAddress(_ currentLocation: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
       delegate.tracingLocation(currentLocation)

    }
    private func updateLocationDidFailWithError(error: NSError) {

        guard let delegate = self.delegate else {
            return
        }

        delegate.tracingLocationDidFailWithError(error)
    }
}
