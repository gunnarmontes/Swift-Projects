

//
//  APISearchResultItem.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 2/10/25.
//  Copyright © 2025 Gunnar Montes All rights reserved.
//

import SwiftUI

struct APISearchResultItem: View {
    
    // Input Parameter
    let cityStruct: CityStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: "https://flagcdn.com/w320/\(cityStruct.country.lowercased()).png", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: cityStruct.is_capital ? "star.fill" : "star")
                        .imageScale(.small)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                    Text(cityStruct.name)
                   
                }
                CountryName(cca2: cityStruct.country)
                Text("\(cityStruct.population)")   // Inserts thousand separators
                
            }
            .font(.system(size: 14))
        }
    }
}

