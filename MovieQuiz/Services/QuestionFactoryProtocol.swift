//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 27.09.2026.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
