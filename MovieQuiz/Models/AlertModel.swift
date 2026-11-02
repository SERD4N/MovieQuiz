//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 28.09.2026.
//

import Foundation
struct AlertModel{
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
