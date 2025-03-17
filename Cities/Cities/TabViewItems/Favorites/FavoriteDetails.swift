//
//  FavoriteDetails.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct FavoriteDetails: View {
    
    // Input Parameter
    let city: City
    
    @State private var selectedMapStyleIndex = 0
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    
    @State private var showAlertMessage = false
    
    var body: some View {
        
        mapCenterCoordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        
        return AnyView(
            // A Form cannot have more than 10 Sections.
            // Group the Sections if more than 10.
            Form {
                Section(header: Text("City Name")) {
                    Text(city.name)
                }
                Section(header: Text("Country Name"))
                {
                    CountryName(cca2: city.country)
                }
                Section(header: Text("Country Flag Name"))
                {
                    getImageFromUrl(url: "https://flagcdn.com/w320/\(city.country.lowercased()).png", defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(minWidth: 300)
                                    .frame(maxWidth: 320)
                }
                Section(header: Text("City Population"))
                {
                    Text("\(city.population)")
                }
                Section(header: Text("City Type"))
                {
                    HStack {
                        Image(systemName: city.is_capital ? "star.fill" : "star")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text(city.is_capital ? "Capital" : "Ordinary City")
                    }
                }
                Section(header: Text("Region")) {
                    Text(city.region)
                }
                Section(header: Text("Select Map Style")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CityLocationOnMap(city: city, mapStyleIndex: selectedMapStyleIndex)) {
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
            .navigationTitle("City Details")
                
            
        )   // End of AnyView
    }   // End of body var
    
}


struct CityLocationOnMap: View {
    
    // Input Parameters
    let city: City
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
                Marker(city.name, coordinate: mapCenterCoordinate)
            }
            .mapStyle(mapStyle)
            .navigationTitle(city.name)
            .toolbarTitleDisplayMode(.inline)
        )
    }
}
            
