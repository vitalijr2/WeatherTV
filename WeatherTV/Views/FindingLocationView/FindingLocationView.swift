//
//  FindingLocaationView.swift
//  WeatherTV
//
//  Created by Сергей on 27.04.2021.
//

import SwiftUI

struct FindingLocationView: View {
    @EnvironmentObject var location: LocationManager
    @State private var isFirsOnAppear = true
    @Binding var selection: String
    @Binding var nameCurrentLocation: String
    
    var body: some View {
        
        VStack {

            if isShowAllowAccess {
                VStack {
                    Text("Turning on location services allows us to show you local weather.")
                        .font(.title2)
                    Button("Open in settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
                
            } else if isFindingCurrentLocation {
                
                Text("Finding a location")
                    .font(.title2)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        location.requestLocation()
                    }
                
            } else {
                if let placemark = location.placemark {
                   
                    WeatherView(
                        viewModel: WeatherViewModel(
                            location: .getFrom(placemark)
                        )
                    )
                    .onAppear {
                        guard let newNameCurrentLocation = placemark.locality else { return }
                        nameCurrentLocation = newNameCurrentLocation
                    }
                }
            }
        }
//        .onAppear {
//            guard isFirsOnAppear else { return }
//            if selection == "localWeather" {
//                location.requestWhenInUseAuthorization()
//                isFirsOnAppear = false
//            }
//        }
        .onChange(of: selection) { selection in
            guard isFirsOnAppear else { return }
            if selection == "localWeather" {
                print(location.status.debugDescription.description )
                location.requestWhenInUseAuthorization()
                print(location.status .debugDescription.description)
                isFirsOnAppear = false
            }
        }
        //        .onAppear {
        //            location.requestLocation()
        //            location.requestWhenInUseAuthorization()
        //        }
        
    }
}


extension FindingLocationView {
    
  
    var isShowAllowAccess: Bool {
        location.status == .denied || location.status == .none
    }
    
    var isFindingCurrentLocation: Bool {
        location.location == nil  || location.status == .none // && !isShowAllowAccess
    }
}

struct FindingLocaationView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLocationView(selection: .constant(""), nameCurrentLocation: .constant("orenburg"))
            .environmentObject(LocationManager.shared)
    }
}
