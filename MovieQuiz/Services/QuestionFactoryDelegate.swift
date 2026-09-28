//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 27.09.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {              
    func didReceiveNextQuestion(question: QuizQuestion?)
}
