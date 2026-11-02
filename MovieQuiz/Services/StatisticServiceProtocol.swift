//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 29.09.2026.
//

import Foundation
protocol StatisticServiceProtocol{
    var gameCount: Int {get}
    var bestGame: GameResult {get}
    var totalAccurancy: Double {get}
    
    func store(correct count: Int, total amount: Int)
}

