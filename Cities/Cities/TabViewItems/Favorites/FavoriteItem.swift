//
//  FavoriteItem.swift
//  Cities
//
//  Created by Gunnar Montes and Osman Balci on 3/4/25.
//  Copyright © 2025 Gunnar Montes. All rights reserved.
//

import SwiftUI

struct FavoriteItem: View {
    
    // Input Parameter
    let city: City
    
    var body: some View {
        HStack {
            
            getImageFromUrl(url: "https://flagcdn.com/w320/\(city.country.lowercased()).png", defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: city.is_capital ? "star.fill" : "star")
                        .imageScale(.small)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                    Text(city.name)
                   
                }
                CountryName(cca2: city.country)
                Text("\(city.population)")   // Inserts thousand separators
                
            }
            .font(.system(size: 14))
        }
    }
}


