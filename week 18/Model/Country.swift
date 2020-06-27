//
//  Country.swift
//  18_QuarantineApp
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation

class Country{
    
    var country: String
    var countryCode: String
    var province: String
    var city: String
    var cityCode: String
    var lat: String
    var lon: String
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var date: String
    
    
    init(country: String, countryCode: String, province: String, city: String, cityCode: String, lat: String, lon: String, confirmed: Int, deaths: Int, recovered: Int, active: Int, date: String) {
        self.country = country
        self.countryCode = countryCode
        self.province = province
        self.city = city
        self.cityCode = cityCode
        self.lat = lat
        self.lon = lon
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.active = active
        self.date = date
    }
    
    
}
