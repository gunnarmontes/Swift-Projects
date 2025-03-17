//
//  DatabaseClasses.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class City {
    
    var name: String
    var latitude: Double
    var longitude: Double
    var country: String
    var population: Int
    var region: String
    var is_capital: Bool
    
    init(name: String, latitude: Double, longitude: Double, country: String, population: Int, region: String, is_capital: Bool) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.population = population
        self.region = region
        self.is_capital = is_capital
    }
    
}

