//
//  LogProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 03/02/25.
//

import SwiftUI

struct LogProjectView: View {
    @ObservedObject var coreDataVM = ProjectViewModel()
    @ObservedObject var currentProject: ProjectEntity
    
    var logsArray: [LogEntity] {
        let set = currentProject.logs as? Set<LogEntity> ?? []
        return set.sorted { $0.date ?? Date() < $1.date ?? Date() }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(logsArray, id: \.self) { log in
                    NavigationLink(destination: LogDetailView(log: log)) {
                        VStack {
                            Text(log.title ?? "Sem título")
                                .font(.headline)
                            Text(log.textContent ?? "Sem conteúdo")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .toolbar {
            NavigationLink(destination: AddLogView(currentProject: currentProject)) {
                Text("Adicionar Log")
            }
        }
    }
}



//#Preview {
//    LogProjectView()
//}
