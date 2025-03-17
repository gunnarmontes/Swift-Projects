//
//  CityApiData.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//



import Foundation

// Global variable to contain the API search results
var foundCitiesList = [CityStruct]()

/*
 ================================================
 |   Fetch and Process JSON Data from the API   |
 |   for the Given Category and Search Query    |
 ================================================
 */
public func getFoundCitiesFromApi(query: String) {
    
    // Initialize the global variable to contain the API search results
    foundCitiesList = [CityStruct]()
    
    /*
     **************************************************
     *   Obtain REST Cities API Query URL String   *
     **************************************************
     */
    
    let apiUrlString = "https://api.api-ninjas.com/v1/city?name=\(query)"
  

    
    /*
     ***************************************************
     *   Fetch JSON Data from the API Asynchronously   *
     ***************************************************
     */
    var jsonDataFromApi: Data
    
    // restCitiesApiHeaders is defined in Globals.swift
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: cityApiHeaders, apiUrl: apiUrlString, timeout: 10.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return      // foundCitiesList will be empty
    }
    
    /*
     **************************************************
     *   Process the JSON Data Fetched from the API   *
     **************************************************
     */
    do {
        /*
         Foundation framework’s JSONSerialization class is used to convert JSON data
         into Swift data types such as Dictionary, Array, String, Int, Double or Bool.
         */
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        /*
         JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
         Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
         where Dictionary Key type is String and Value type is Any (instance of any type)
         */
        
        /*
         ----------------------------------------------
         |   REST Countries API JSON File Structure   |
         ----------------------------------------------
         
         REST Cities API always returns the search results in a
         JSON Array regardless of which search category is selected.
         
         The following JSON data is returned for each country found
         under each search category.
         
         The green checkmark icon marks the data to be used.
         
         [                      <== Top Level Array of JSON Objects representing list of cities
             {                  <== JSON Object representing a country
                 ✅"name": "Istanbul",
                 ✅"latitude": 41.01,
                 ✅"longitude": 28.9603,
                 ✅"country": "TR",
                 ✅"population": 15154000,
                 ✅"region": "Marmara Region",
                 ✅"is_capital": false,
                 
             },
             {
                Another city if any
             }
             :
                Other cities if any
             :
         ]
         */
        
        //----------------------------
        // Obtain Top Level JSON Array
        //----------------------------
        
        var searchResultsJsonArray = [Any]()
        
        if let jsonArray = jsonResponse as? [Any] {
            searchResultsJsonArray = jsonArray
        } else {
            return  // foundCitiesList will be empty
        }
        
        // Iterate over the searchResultsJsonArray containing JSON objects representing countries
        for cityJsonObject in searchResultsJsonArray {
            
            // Make sure that the array item is indeed a JSON object (Swift dictionary type)
            var cityDataDictionary = [String: Any]()
            
            if let jObject = cityJsonObject as? [String: Any] {
                cityDataDictionary = jObject
            } else {
                // Skip this city
                continue
            }
            
            /*
             continue:  skips the current loop iteration
             break:     skips all remaining iterations
             */
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
            //--------------------
            // Obtain City Name
            //--------------------
            
            var name = ""
            
            if let nameFound = cityDataDictionary["name"] as? String {
                name = nameFound
            }
            
            var latitude = 0.0
            
            if let latFound = cityDataDictionary["latitude"] as? Double {
                latitude = latFound
            }
            
            var longitude = 0.0
            
            if let lonFound = cityDataDictionary["longitude"] as? Double {
                longitude = lonFound
            }
            
            var country = ""
            
            if let countryFound = cityDataDictionary["country"] as? String {
                country = countryFound
            }
            
            var population = 0
            
            if let popFound = cityDataDictionary["population"] as? Int {
                population = popFound
            }
            
            var region = ""
            
            if let regionFound = cityDataDictionary["region"] as? String {
                region = regionFound
            }
            
            var is_capital = false
            
            if let is_capFound = cityDataDictionary["is_capital"] as? Bool {
                is_capital = is_capFound
            }
            
            
            //-------------------------------------------------------------------------
            // Create an Instance of City Struct and Append it to foundCitiesList
            //-------------------------------------------------------------------------
            let cityFound = CityStruct(name: name, latitude: latitude, longitude: longitude, country: country, population: population, region: region, is_capital: is_capital)
            
            foundCitiesList.append(cityFound)
            
        }   // End of for loop
        
        // Sort the list in alphabetical order with respect to commonName
        foundCitiesList = foundCitiesList.sorted(by: { $0.name < $1.name })
        
    } catch {
        return  // foundCitiesList will be empty
    }
    
}
