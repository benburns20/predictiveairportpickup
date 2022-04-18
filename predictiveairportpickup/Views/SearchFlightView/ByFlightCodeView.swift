//
//  ByAirlineView.swift
//  predictiveairportpickup
//
//  Created by Ben Burns on 4/12/22.
//

import SwiftUI

struct ByFlightCodeView: View {
    
    @ObservedObject var airlinesModel: AirlinesModel
    @ObservedObject var manager: LocationManager
    
    @State var showingAirlineSearchView = false
    @State var isPickerVisible = false
    
    @Binding var rootIsActive: Bool
    @Binding var airlineSelected: String
    @Binding var selectedDate: Date
    @Binding var dateChanged: Bool
    @Binding var flightCode: String
    
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
            HStack {
                ZStack {
                    Button("") {
                    }
                        .frame(width: 90, height: 40)
                        .foregroundColor(.gray)
                        .background(Color("Gray"))
                        .cornerRadius(13)
                    
                    HStack {
                        //Placeholder
                        if airlineSelected == "" {
                            Text("AA")
                                .font(.system(size: 20, weight: .regular))
                                .tracking(0.38)
                                .padding(.leading, 15)
                        } else {
                            Text(airlineSelected)
                                .font(.system(size: 20, weight: .regular))
                                .tracking(0.38)
                                .padding(.leading, 15)
                        }
                        Spacer()
                    }
                        .frame(width: 100)
                        .foregroundColor(.gray)
//                        .padding(.leading, 30)
                }
                .frame(height: 40)
                .onTapGesture() {
                    self.showingAirlineSearchView.toggle()
                }
                .sheet(isPresented: $showingAirlineSearchView) {
                    AirlineSearchView(airlinesModel: airlinesModel, airlineValue: $airlineSelected)
                }
                                        
                ZStack {
                    Button("") {
                    }
                        .frame(width: screenWidth - 110, height: 40)
                        .foregroundColor(.gray)
                        .background(Color("Gray"))
                        .cornerRadius(13)
                    HStack {
                        //Placeholder
//                        Text("1234")
//                            .font(.system(size: 20, weight: .regular))
//                            .tracking(0.38)
                        TextField("1234", text: $flightCode)
                            .font(.system(size: 20, weight: .regular))
                        Spacer()
                    }
//                        .frame(width: screenWidth - 210)
                        .foregroundColor(.gray)
                        .padding(.leading, 13)
                }
                .frame(height: 40)
            }
            .frame(width: screenWidth, height: 40)
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

struct AirlineSearchView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var airlinesModel: AirlinesModel
    
    @State var searchQuery = ""
    
    @Binding var airlineValue: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    Button(name) {
                        airlineValue = airlinesModel.airlinesMapping[name]!
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
            return airlinesModel.airlines
        } else {
            return airlinesModel.airlines.filter { $0.contains(searchQuery) }
        }
    }
}
