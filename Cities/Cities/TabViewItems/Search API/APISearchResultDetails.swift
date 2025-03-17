//
//  FavoriteDetails.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct APISearchResultDetails: View {
    
    // Input Parameter
    let cityStruct: CityStruct
    
    @Environment(\.modelContext) private var modelContext
    
    //-----------------------------------------------------
    // Create a list of all Country objects in the database
    //-----------------------------------------------------
    @Query private var citiesList: [City]
    @State private var selectedMapStyleIndex = 0
    
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    
    @State private var showAlertMessage = false
    
    var body: some View {
        
        mapCenterCoordinate = CLLocationCoordinate2D(latitude: cityStruct.latitude, longitude: cityStruct.longitude)
        
        return AnyView(
            // A Form cannot have more than 10 Sections.
            // Group the Sections if more than 10.
            Form {
                Section(header: Text("City Name")) {
                    Text(cityStruct.name)
                }
                Section(header: Text("Country Name"))
                {
                    CountryName(cca2: cityStruct.country)
                }
                Section(header: Text("Country Flag Name"))
                {
                    getImageFromUrl(url: "https://flagcdn.com/w320/\(cityStruct.country.lowercased()).png", defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(minWidth: 300)
                                    .frame(maxWidth: 320)
                }
                Section(header: Text("City Population"))
                {
                    Text("\(cityStruct.population)")
                }
                Section(header: Text("Add found city to database as favorite")) {
                    Button(action: {
                        var alreadyInDatabase = false
                        for aCity in citiesList {
                            if aCity.name == cityStruct.name {
                                alreadyInDatabase = true
                                break
                            }
                        }
                        
                        if alreadyInDatabase {
                            alertTitle = "City in Database"
                            alertMessage = "This city already exists in your favorites list."
                            showAlertMessage = true
                        } else {
                            // Instantiate a new Country object and dress it up
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
                            let newCity = City(
                                name: cityStruct.name,
                                latitude: cityStruct.latitude,
                                longitude: cityStruct.longitude,
                                country: cityStruct.country,
                                population: cityStruct.population,
                                region: cityStruct.region,
                                is_capital: cityStruct.is_capital
                            )
                            
                            // Insert the new Country object into the database
                            modelContext.insert(newCity)
                            
                            alertTitle = "City Added!"
                            alertMessage = "Selected found city is added to your database as your favorite."
                            showAlertMessage = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Country to Favorites")
                                .font(.system(size: 16))
                        }
                    }
                }
                Section(header: Text("City Type"))
                {
                    HStack {
                        Image(systemName: cityStruct.is_capital ? "star.fill" : "star")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text(cityStruct.is_capital ? "Capital" : "Ordinary City")
                    }
                }
                Section(header: Text("Region")) {
                    Text(cityStruct.region)
                }
                Section(header: Text("Select Map Style")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: FoundCityLocationOnMap(cityStruct: cityStruct, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Country on Map")
                                .font(.system(size: 16))
                        }
                    }
                }
                
                    
            
            }
                .font(.system(size: 14))
                .navigationTitle("Found City Details")
                .toolbarTitleDisplayMode(.inline)
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {}
                }, message: {
                    Text(alertMessage)
                })
                
                
            
        )   // End of AnyView
    }   // End of body var
}


struct FoundCityLocationOnMap: View {
    
    // Input Parameters
    let cityStruct: CityStruct
    let mapStyleIndex: Int
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // mapCenterCoordinate is a fileprivate var
            center: mapCenterCoordinate,
            // 1 degree = 69 miles. 30 degrees = 2,070 miles
            span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
        )
    )
    
    var body: some View {
        
        var mapStyle: MapStyle = .standard
        
        switch mapStyleIndex {
        case 0:
            mapStyle = MapStyle.standard
        case 1:
            mapStyle = MapStyle.imagery     // Satellite
        case 2:
            mapStyle = MapStyle.hybrid
        case 3:
            mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
        default:
            print("Map style is out of range!")
        }
        
        return AnyView(
            Map(position: $mapCameraPosition) {
                Marker(cityStruct.name, coordinate: mapCenterCoordinate)
            }
            .mapStyle(mapStyle)
            .navigationTitle(cityStruct.name)
            .toolbarTitleDisplayMode(.inline)
        )
    }
}
            
