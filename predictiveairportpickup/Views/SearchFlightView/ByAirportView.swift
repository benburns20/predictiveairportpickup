//
//  SearchByAirportView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/12/22.
//

import SwiftUI

struct ByAirportView: View {
    
    @ObservedObject var airportsModel: AirportsModel
    @ObservedObject var manager: LocationManager
    
    @State var showingAirportSearchView = false
    @State var isPickerVisible = false
    
    @Binding var rootIsActive: Bool
    @Binding var airportSelected: String
    @Binding var selectedDate: Date
    @Binding var dateChanged: Bool
    
    let screenWidth = UIScreen.main.bounds.size.width - 50
    
    func getDateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        if dateChanged {
            return formatter.string(from: selectedDate)
        } else {
            return "Date"
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Button("") {
                }
                    .frame(width: screenWidth, height: 40)
                    .foregroundColor(.gray)
                    .background(Color("Gray"))
                    .cornerRadius(13)
                
                HStack {
                    //Placeholder
                    if airportSelected == "" {
                        Text("Departure Airport")
                            .font(.system(size: 20, weight: .regular))
                            .tracking(0.38)
                            .foregroundColor(.gray)
                    } else {
                        Text(airportSelected)
                            .font(.system(size: 20, weight: .regular))
                            .tracking(0.38)
                            .lineLimit(1)
                    }
                    Spacer()
                    Image("Forward Arrow")
                        .padding()
                }
                    .frame(width: screenWidth - 10)
                    .padding(.leading, 13)
            }
            .frame(height: 40)
            .padding([.leading, .trailing, .top])
            .onTapGesture() {
                showingAirportSearchView.toggle()
            }
            .sheet(isPresented: $showingAirportSearchView) {
                AirportSearchView(airportsModel: airportsModel, airportValue: $airportSelected)
            }
            
            ZStack {
                Button("") {
                }
                    .frame(width: screenWidth, height: 40)
                    .foregroundColor(.gray)
                    .background(Color("Gray"))
                    .cornerRadius(13)
                
                HStack {
                    //Placeholder
                    Text("Hartsfield-Jackson Atlanta Airport")
                        .font(.system(size: 20, weight: .regular))
                        .tracking(0.38)
                    Spacer()
                }
                    .frame(width: screenWidth - 10)
                    .padding(.leading, 13)
            }
            .frame(height: 40)
            .padding([.leading, .trailing, .top])
            
//            HStack {
//                ZStack {
//                    Button("") {
//                    }
//                        .frame(width: 140, height: 40)
//                        .foregroundColor(.gray)
//                        .background(Color("Gray"))
//                        .cornerRadius(13)
//
//                    HStack {
//                        //Placeholder
//                        if dateChanged {
//                            Text(getDateAsString(date: selectedDate))
//                                .font(.system(size: 20, weight: .regular))
//                                .tracking(0.38)
//                                .padding(.leading, 10)
//                        } else {
//                            Text(getDateAsString(date: selectedDate))
//                                .font(.system(size: 20, weight: .regular))
//                                .tracking(0.38)
//                                .foregroundColor(.gray)
//                                .padding(.leading, 10)
//                        }
//                        Spacer()
//                        Button {
//                            isPickerVisible = true
//                            dateChanged = true
//                        } label: {
//                            Image(systemName: "calendar")
//                                .padding(.trailing, 27)
//                        }
//                    }
//                    .popover(isPresented: $isPickerVisible, attachmentAnchor: .point(.bottom), arrowEdge: .bottom, content: {
//                            VStack {
//                                HStack {
//                                    Button("Done") {
//                                        isPickerVisible = false
//                                        print(selectedDate)
//                                    }
//                                    .padding()
//                                    Spacer()
//                                }
//
//                                DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
//                                    .datePickerStyle(GraphicalDatePickerStyle())
//                            }
//                        })
//                        .frame(width: 150)
//                        .padding(.leading, 13)
//                }
//                .frame(height: 40)
//                .padding()
//            }
        }
        .offset(y: 30)
    }
}

struct AirportSearchView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var airportsModel: AirportsModel
    
    @State var searchQuery = ""
    
    @Binding var airportValue: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    Button(name) {
                        airportValue = name
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchQuery)
            .navigationTitle("Airports")
        }
    }
    
    var searchResults: [String] {
        if searchQuery.isEmpty {
            return airportsModel.allAirports
        } else {
            return airportsModel.allAirports.filter { $0.localizedStandardContains(searchQuery) }
        }
    }
}
