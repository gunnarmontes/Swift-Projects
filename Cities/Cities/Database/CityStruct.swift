//
//  CityStruct.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

/*
<> CityStruct is used to populate the database with intitial content
   in DatabaseInitialContent.json for which it has to be Decodable.
<> CityStruct is also used to represent the JSON objects fetched from
   the API for which it has to be Hashable to display them in a dynamic list.
*/
struct CityStruct: Decodable, Hashable {
    var name: String
    var latitude: Double
    var longitude: Double
    var country: String
    var population: Int
    var region: String
    var is_capital: Bool
}

/*
 Sample struct
 {
     "name": "San Francisco",
     "latitude": 37.7562,
     "longitude": -122.443,
     "country": "US",
     "population": 3592294,
     "region": "California",
     "is_capital": false
 }
 */
