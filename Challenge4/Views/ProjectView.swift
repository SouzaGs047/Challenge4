//
//  ProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 31/01/25.
//

import SwiftUI

struct ProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    @State var selectedTab : Int = 1
    
        var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        selectedTab = 1
                    }, label: {
                        Text("Logs")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == 1 ? .black : .white)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .foregroundStyle(selectedTab == 1 ? .pink : .black)
                            )
        
                    })
                    
                    Text (" | ")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink)
                    
                    
                        Button(action: {
                            selectedTab = 2
                        }, label: {
                            Text("Projeto")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 2 ? .black : .white)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .foregroundStyle(selectedTab == 2 ? .pink : .black)
                                )
                                
                        })
                }
//                .padding(.bottom, 15)
//                .frame(height: 60)
                
                
                TabView (selection: $selectedTab,
                         content:  {
                    LogProjectView(currentProject: currentProject)
                    .tag(1)
                    
                    EditProjectView()
                    .tag(2)
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle(currentProject.name ?? "Sem Título")
            }
        }
        
    

//#Preview {
//    ProjectView()
//}
