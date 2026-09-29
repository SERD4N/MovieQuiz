//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 29.09.2026.
//

import Foundation

final class StatisticService{
    private let storage: UserDefaults = .standard
    private enum Keys: String{
        case gameCount
        case gameCorrect
        case gameTotal
        case gameDate
        case totalCorrectAnswers
        case totalQuestionAsked
    }
}

extension StatisticService: StatisticServiceProtocol{
    
    
    var gameCount: Int {
        get{
            storage.integer(forKey: Keys.gameCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get{
            let correct = storage.integer(forKey: Keys.gameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.gameTotal.rawValue)
            let date = storage.object(forKey: Keys.gameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set{
            storage.set(newValue.correct, forKey: Keys.gameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.gameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.gameDate.rawValue)
        }
    }
    
    private var totalCorrectAnswers: Int{
        get{
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int{
        get{
            storage.integer(forKey: Keys.totalQuestionAsked.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalQuestionAsked.rawValue)
        }
    }
    
    
    var totalAccurancy: Double {
        get{
            guard totalQuestionsAsked > 0 else {return 0}
            return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gameCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame){
            bestGame = newGame
        }
        
    }
    
    
}
