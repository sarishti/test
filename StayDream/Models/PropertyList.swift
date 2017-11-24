//
// PropertyList.swift
//

import Foundation
import ObjectMapper

protocol Loopable {
    func allAmenities() throws -> [String: Any]
}

extension Loopable {
    func allAmenities() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
}

struct PropertyList: Mappable, Loopable {
/// PropertyList properties
    /** building tag name */
    var buildingTagName: String?
    /** property short description */
    var propertyShortDescription: String?
    /** view_type_code */
    var viewTypeCode: String?
    /** billing_currency_code */
    var billingCurrencyCode: String?
    /** room_rate_amount */
    var roomRateAmount: Float?
    /** rating_number */
    var ratingNumber: Float?
    /** id */
    var id: Int?
    /** property_photo_count */
    var propertyPhotoCount: Double?
    /** distance in km */
    var distance: Double?
    /** latitute of property */
    var buildingLatitudeDecimalDegrees: String?
    /** latitute of property */
    var buildingLongitudeDecimalDegrees: String?
    /** property long description */
    var propertyLongDescription: String?
    /** accommodate count */
    var accommodateCount: Int?
    /** accommodate count */
    var bathroomCount: Int?
    /** accommodate count */
    var bedroomCount: Int?
    /** accommodate count */
    var bedCount: Int?
    /** check in time */
    var checkInAfterTime: String?
    /** check out time */
    var checkOutBeforeTime: String?
    /** pets allowed */
    var petsAllowedIndicator: Bool?
    /** pets allowed */
    var elevatorIndicator: Bool?
    /** pets allowed */
    var smokingAllowedIndicator: Bool?
    /** pets allowed */
    var indoorFireplaceIndicator: Bool?
    /** pets allowed */
    var wirelessInternetIndicator: Bool?
    /** pets allowed */
    var kitchenIndicator: Bool?
    /** pets allowed */
    var cableTvIndicator: Bool?
    /** pets allowed */
    var iptvIndicator: Bool?
    /** pets allowed */
    var hotTubIndicator: Bool?
    /** pets allowed */
    var gymIndicator: Bool?
    /** pets allowed */
    var poolIndicator: Bool?
    /** pets allowed */
    var tvIndicator: Bool?
    /** pets allowed */
    var ironIndicator: Bool?
    /** pets allowed */
    var dryerIndicator: Bool?
    /** pets allowed */
    var washerIndicator: Bool?
    /** pets allowed */
    var hangersIndicator: Bool?
    /** pets allowed */
    var hairDryerIndicator: Bool?
    /** pets allowed */
    var essentialsIndicator: Bool?
    /** pets allowed */
    var shampooIndicator: Bool?
    /** pets allowed */
    var heatingIndicator: Bool?
    /** pets allowed */
    var airConditioningIndicator: Bool?
    /** pets allowed */
    var airPurifierIndicator: Bool?
    /** pets allowed */
    var bathtubIndicator: Bool?
    /** pets allowed */
    var cribIndicator: Bool?
    /** pets allowed */
    var highChairIndicator: Bool?
    /** pets allowed */
    var smokeDetectorIndicator: Bool?
    /** pets allowed */
    var carbonMonoxideDetectorIndicator: Bool?
    /** pets allowed */
    var firstAidKitIndicator: Bool?
    var reviewCount:Int?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        buildingTagName <- map["building_tag_name"]
        reviewCount <- map["reviews_count"]
        propertyShortDescription <- map["property_short_description"]
        viewTypeCode <- map["view_type_code"]
        billingCurrencyCode <- map["billing_currency_code"]
        roomRateAmount <- map["room_rate_amount"]
        ratingNumber <- map["rating_number"]
        id <- map["id"]
        propertyPhotoCount <- map["property_photo_count"]
        distance <- map["distance"]
        buildingLatitudeDecimalDegrees <- map["building_latitude_decimal_degrees"]
        buildingLongitudeDecimalDegrees <- map["building_longitude_decimal_degrees"]
        propertyLongDescription <- map["property_long_description"]
        accommodateCount <- map["accommodate_count"]
        bathroomCount <- map["bathroom_count"]
        bedroomCount <- map["bedroom_count"]
        bedCount <- map["bed_count"]
        checkInAfterTime <- map["check_in_after_time"]
        checkOutBeforeTime <- map["check_out_before_time"]
        petsAllowedIndicator <- map["pets_allowed_indicator"]
        elevatorIndicator <- map["elevator_indicator"]
        smokingAllowedIndicator <- map["smoking_allowed_indicator"]
        indoorFireplaceIndicator <- map["indoor_fireplace_indicator"]
        wirelessInternetIndicator <- map["wireless_internet_indicator"]
        kitchenIndicator <- map["kitchen_indicator"]
        cableTvIndicator <- map["cable_tv_indicator"]
        iptvIndicator <- map["iptv_indicator"]
        hotTubIndicator <- map["hot_tub_indicator"]
        gymIndicator <- map["gym_indicator"]
        poolIndicator <- map["pool_indicator"]
        tvIndicator <- map["tv_indicator"]
        ironIndicator <- map["iron_indicator"]
        dryerIndicator <- map["dryer_indicator"]
        washerIndicator <- map["washer_indicator"]
        hangersIndicator <- map["hangers_indicator"]
        hairDryerIndicator <- map["hair_dryer_indicator"]
        essentialsIndicator <- map["essentials_indicator"]
        shampooIndicator <- map["shampoo_indicator"]
        heatingIndicator <- map["heating_indicator"]
        airConditioningIndicator <- map["air_conditioning_indicator"]
        airPurifierIndicator <- map["air_purifier_indicator"]
        bathtubIndicator <- map["bathtub_indicator"]
        cribIndicator <- map["crib_indicator"]
        highChairIndicator <- map["high_chair_indicator"]
        smokeDetectorIndicator <- map["smoke_detector_indicator"]
        carbonMonoxideDetectorIndicator <- map["carbon_monoxide_detector_indicator"]
        firstAidKitIndicator <- map["first_aid_kit_indicator"]
    }

    func encodeToJSON() -> [String : Any] {
        return self.toJSON()
    }
}
