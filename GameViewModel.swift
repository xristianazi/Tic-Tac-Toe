//
//  GameViewModel.swift
//  tictactoe
//
//  Created by xristiana zi on 9/8/24.
//

import SwiftUI



// our game view view should be nothing but UI
final class  GameViewModel: ObservableObject { // any time things change its gonna publish in update 
    
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    
    @Published  var moves : [Move?] = Array(repeating: nil, count :9) 
    @Published  var isGameboardDisabled = false
    @Published  var alertItem: AlertItem?
    
    func processPlayerMove( for position : Int ){
        if isSquareOccupied(in: moves, forIndex: position){return}
        moves[position] = Move(player: .human,  boardIndex: position)
       
        
        // check for win condition or draw
        
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return // nothinh runs after i check the win condition
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer ,  boardIndex: computerPosition)
            isGameboardDisabled = false
            
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
        
        
        
        
        
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) ->Bool {
        return moves.contains(where:{$0?.boardIndex == index })
        
    }
    
    // If AI can win . then win
    // If AI can't win , then block
    // If AI can't block , then take middle sqaure
    //IF AI can't take middle sqaure , take random available sqaure
    
    func determineComputerMovePosition(in moves :[Move?])-> Int{
        
        // If AI can win, then win
        
        let winPatterns: Set<Set<Int>> = [[0,1,2] , [3,4,5], [6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap{$0}.filter{$0.player == .computer}
        let computerPositions = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return  winPositions.first! }
            }
        }
        
        // If AI can't win , then block
        
        
        let humanMoves = moves.compactMap{$0}.filter{$0.player == .human}
        let humanPositions = Set(humanMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return  winPositions.first! }
            }
        }
        
        // If AI can't block , then take middle sqaure
        let centerSqaure = 4
        if !isSquareOccupied(in: moves, forIndex: centerSqaure){
            return centerSqaure
        }
        
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    func checkWinCondition(for player : Player , in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2] , [3,4,5], [6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        for pattern in winPatterns  where pattern.isSubset(of: playerPositions){
            return true
            
        }
        
        // compactmap we removes all the nils
        return false
    }
    
    func checkForDraw( in moves:[Move?]) -> Bool{
        return moves.compactMap{$0}.count == 9 // i remove all the nills and if the moves is eqaul to  9 then the game is over
    }
    
        
        func resetGame() {
            
            moves = Array(repeating: nil, count: 9)
        }
    
    
}
