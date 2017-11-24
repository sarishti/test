//
//  GooglePlacesAPI.swift
//  StayDream
//
//  Created by Sharisti on 03/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

protocol GooglePlaceAPI {

}
extension GooglePlaceAPI {
    /**
      get the auto complete result
     - parameter string: string
     - parameter handler: completion handler to receive the data
     */
    func autoCompleteResults(_ txtSearch: String, withHandler handler: @escaping (_ responseData: Array<GoogleAutocompleteJSONModel>?) -> Void) {

        let URLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(txtSearch)&key=" + Configuration.placesClientKey()
        let escapedStringUrl = URLString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        //"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(txtSearch)&components=country:us&key=Configuration.googleAPIKey()"
        print("URLString: \(URLString) escapedStringUrl:\(escapedStringUrl)")
        let nillableParameters: [String:Any?] = [:]
        let parameters = APIHelper.rejectNil(source: nillableParameters)
        let convertedParameters = APIHelper.convertBoolToString(source: parameters)

        let requestBuilder = RequestBuilder(urlString: escapedStringUrl!, requestMethod: "GET", requestParameters: convertedParameters, showLoader: false)

        JSONRequest(requestBuilder: requestBuilder) { (response, _) in
            if response.result.isSuccess {
                guard let jsonResponse = response.result.value as?  [String: Any] else {
                    print("jsonResponse:\(response.result.value)")
                    handler(nil)
                    return
                }
                let response = Array<GoogleAutocompleteJSONModel>(json: jsonResponse["predictions"])

                handler(response)
            } else {
                handler(nil)
            }
        }
    }
    /**
     call property list
     - parameter body: (body) property lat long and date
     - parameter handler: completion handler to receive the data
     */
    func placeCoordinate(placeId: String, withHandler handler: @escaping (_ responseData: CLLocation?) -> Void) {

//        https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=ChIJ5YLXCth1AjoRWZY9hhatmK4&key=AIzaSyAFL8g_B0OzTsuVgE6hAqy-3dAupBJgv70

        let URLString = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=\(placeId)&key=" + Configuration.placesClientKey()
        let nillableParameters: [String:Any?] = [:]
        let parameters = APIHelper.rejectNil(source: nillableParameters)
        let convertedParameters = APIHelper.convertBoolToString(source: parameters)

        let requestBuilder = RequestBuilder(urlString: URLString, requestMethod: "GET", requestParameters: convertedParameters, showLoader: true)
        JSONRequest(requestBuilder: requestBuilder) { (response, _) in
            if response.result.isSuccess {
                guard let jsonResponse = response.result.value as?  [String: Any] else {
                    handler(nil)
                    return
                }
                if let status = jsonResponse["status"] as? String, status == "OK"{
                    if let result = jsonResponse["result"] as? NSDictionary, let geometry = result["geometry"] as? NSDictionary, let locationDic  =  geometry["location"] as? Dictionary<String, Any> {
                        let location = CLLocation.init(latitude:locationDic["lat"] as! CLLocationDegrees, longitude: locationDic["lng"] as! CLLocationDegrees)
                        handler(location)
                    }
                } else {
                     handler(nil)
                }

            } else {
                handler(nil)
            }
        }
    }
}
