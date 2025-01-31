//
//  addLogProject.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 31/01/25.
//

import SwiftUI

struct AddLogView: View {
    var coreDataVM = LogViewModel()
    @ObservedObject var currentProject: ProjectEntity
    @Environment(\.dismiss) var dismiss
    
    @State var titleLog: String = ""
    @State var textContentLog: String = ""
    
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("Título...", text: $titleLog)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding(.horizontal)
            
            TextField("Conteúdo...", text: $textContentLog)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding(.horizontal)
            
            Button(action: {
                guard !titleLog.isEmpty else {return}
                guard !textContentLog.isEmpty else {return}
                coreDataVM.addLog(to: currentProject, title: titleLog, textContent: textContentLog)
                titleLog = ""
                textContentLog = ""
                dismiss()
            }
            , label: {
                Text("Adicionar Log")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .background(in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
            })
            .padding(.horizontal)
        }.navigationTitle("Adicionar Log")
        
        Spacer()
    }
}

//#Preview {
//    addLogView()
//}
