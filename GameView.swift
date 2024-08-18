//
//  GameView.swift
//  tictactoe
//
//  Created by xristiana zi on 25/7/24.
//

import SwiftUI




struct GameView: View {
    
    
    @StateObject private var vM = GameViewModel()  // connect my view  with the  game view model
    // state object privaet we can make changes to the game view class and updates
    
    
    
    var body: some View {
        GeometryReader {geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: vM.columns, spacing: 5 ) {
                    ForEach(0..<9){i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3-15,
                                       height: geometry.size.height/3-15)
                            Image(systemName:vM.moves[i]? . indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            // on the tapgesture we want to create a move and add it to moves array
                            vM.processPlayerMove(for: i)
                           
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(vM.isGameboardDisabled)
            .padding()
            .alert(item: $vM.alertItem, content: {alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {vM.resetGame()}))
            })
        }
    }
}

enum Player {
    case human , computer
    }

struct Move{
    
    let player : Player
    let boardIndex : Int
    var indicator : String {
        return player == .human ? "xmark" : "circle"
    }
}


#Preview {
    GameView()
}


