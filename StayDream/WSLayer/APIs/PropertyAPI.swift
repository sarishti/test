//
// PropertyAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire

// swiftlint:disable function_parameter_count
protocol PropertyAPI {

}
extension PropertyAPI {
    /**
     call property list
     - parameter page: (query) Page number (20 records per page)
     - parameter body: (body) property lat long and date
     - parameter handler: completion handler to receive the data
     */
    func propertyList(_ page: Int, body: Property, withHandler handler: @escaping (_ responseData: NSIResponse<PropertyListing>?) -> Void) {
        var path = "/property/properties/"
        if page > 0 {
            path = path + "?page=\(page)"
        }
        let URLString = Configuration.BaseURL() + path
        let headers = Configuration.customHeaders
        let parameters = body.encodeToJSON()
        let convertedParameters = APIHelper.convertBoolToString(source: parameters)
        let requestBuilder = RequestBuilder(urlString: URLString, requestMethod: "POST", requestParameters: convertedParameters, requestHeaders: headers, showLoader: true)
        JSONRequest(requestBuilder: requestBuilder) { (response, isLoadedFromCache) in
            if response.result.isSuccess {
                guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                    handler(NSIResponse<PropertyListing>(.nilResponse))
                    return
                }
                var nsiResponse = NSIResponse<PropertyListing>(JSON: jsonResponse)
                nsiResponse?.hasCache = isLoadedFromCache
                handler(nsiResponse)
            } else {
                handler(NSIResponse<PropertyListing>(.invalidStatus))
            }
        }
    }
    /**
     Property detail as per id
     - parameter propertyId: (path) page id
     - parameter handler: completion handler to receive the data
     */
    func propertyDetail(_ propertyId: Int, withHandler handler: @escaping (_ responseData: NSIResponse<PropertyList>?) -> Void) {
        var path = "/property/detail/{propertyId}/"
        path = path.replacingOccurrences(of: "{propertyId}", with: "\(propertyId)", options: .literal, range: nil)
        let URLString = Configuration.BaseURL() + path
        let headers = Configuration.customHeaders
        let nillableParameters: [String:Any?] = [:]
        let parameters = APIHelper.rejectNil(source: nillableParameters)
        let convertedParameters = APIHelper.convertBoolToString(source: parameters)
        let requestBuilder = RequestBuilder(urlString: URLString, requestMethod: "GET", requestParameters: convertedParameters, requestHeaders: headers, showLoader: true)
        JSONRequest(requestBuilder: requestBuilder) { (response, isLoadedFromCache) in
            if response.result.isSuccess {
                guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                    handler(NSIResponse<PropertyList>(.nilResponse))
                    return
                }
                var nsiResponse = NSIResponse<PropertyList>(JSON: jsonResponse)
                nsiResponse?.hasCache = isLoadedFromCache
                handler(nsiResponse)
            } else {
                handler(NSIResponse<PropertyList>(.invalidStatus))
            }
        }
    }
}
