//
//  CountrySlug.swift
//  18_QuarantineApp
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation

class CountrySlug {
    
    var country: String
    var slug: String
    var iso2: String
    
    init(country: String, slug: String, iso2: String) {
        self.country = country
        self.slug = slug
        self.iso2 = iso2
    }
}
