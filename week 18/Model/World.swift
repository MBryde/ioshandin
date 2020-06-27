//
//  World.swift
//  18_QuarantineApp
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation

class World {
    
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    
    init(confirmed: Int, deaths: Int, recovered: Int) {
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.active = confirmed - deaths - recovered
    }
    
}
