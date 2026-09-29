//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 29.09.2026.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameResult) -> Bool{
        correct > another.correct
    }
}
